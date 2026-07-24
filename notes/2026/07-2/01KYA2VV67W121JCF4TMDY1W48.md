---
id: 01KYA2VV67W121JCF4TMDY1W48
created: 2026-07-24T12:51:05.543234Z
updated: 2026-07-24T13:49:40.936553Z
type: task
title: Record usage and cost for budget-exceeded chat turns
project: 01KX671DATY39VW6GWK3M2T3DN
number: 253
sprint: sthz8ne
comments:
- id: 01KYA6705M4PFMPYSSTQJ24DDP
  author: Steve Vine
  at: 2026-07-24T13:49:36.820729Z
  text: |-
    Done — PR #230 (feature/ise-253-budget-exceeded-usage → main).

    Root cause confirmed: on UsageLimitExceeded, `stream_chat` returned before `usage` was captured, so `_close_turn`'s `usage is not None` guard skipped `record_usage` and the run persisted at 0 tokens / $0.00.

    Fix: pass a caller-owned `RunUsage` into `agent.run(usage=...)` — pydantic-ai's graph mutates it in place, so the partial token count survives the exception. On the budget-exceeded path we now record it via the existing `record_usage`, which was relaxed to tolerate a missing `messages_json` (the run returns no result to transcribe on this path) and stamp just the token/cost accounting. Go-forward only, as noted (no stored token split to backfill).

    Test: `test_a_turn_that_trips_the_token_cap_still_records_its_tokens` forces a 1-token cap so the model runs, overshoots, then trips — asserts the AgentRun records `budget_exceeded` WITH real tokens and a non-zero cost. Full assist/issue-chat/engine suites green; mypy clean.

    Follow-up flagged: the single-shot engine path (`engine.py::_run_with_fallback`) has the same 0-token gap for scheduled/issue-scoped agents — out of scope for this chat-turn task, worth a separate ticket.
assignee: steve
priority: medium
task_status: review
---
When a chat turn trips the per-turn token cap, the `UsageLimitExceeded` handler (`ai/chat.py:553`) returns before `usage` is captured, so `record_usage` never runs — the `agent_run` row persists with 0 input/output/cache tokens and no `cost_usd`. The real token count survives only inside the `outcome` error string.

Concrete example: run `ffcd71a4` (issue-chat, 2026-07-24 09:22 UTC) burned 69,537 tokens (~$0.20) and is recorded as $0.00.

Impact: budget-exceeded turns — precisely the most expensive chat turns — are invisible to every spend panel, the daily-ceiling accounting, the assist/issue-chat daily shares, and the per-conversation caps. That's an accounting leak in the ISE-68 model and undermines the Sprint 23 spend-visibility work.

Fix: capture partial usage from the run before yielding the `budget_exceeded` error (pydantic-ai exposes usage on the exception/run state), then `record_usage` + cost-estimate as on the success path. Backfill isn't possible (token split not stored), so just fix go-forward.