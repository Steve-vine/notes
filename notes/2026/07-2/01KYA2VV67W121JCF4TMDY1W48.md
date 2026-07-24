---
id: 01KYA2VV67W121JCF4TMDY1W48
created: 2026-07-24T12:51:05.543234Z
updated: 2026-07-24T12:51:05.543234Z
type: task
title: Record usage and cost for budget-exceeded chat turns
label: bug
assignee: steve
priority: medium
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 253
---
When a chat turn trips the per-turn token cap, the `UsageLimitExceeded` handler (`ai/chat.py:553`) returns before `usage` is captured, so `record_usage` never runs — the `agent_run` row persists with 0 input/output/cache tokens and no `cost_usd`. The real token count survives only inside the `outcome` error string.

Concrete example: run `ffcd71a4` (issue-chat, 2026-07-24 09:22 UTC) burned 69,537 tokens (~$0.20) and is recorded as $0.00.

Impact: budget-exceeded turns — precisely the most expensive chat turns — are invisible to every spend panel, the daily-ceiling accounting, the assist/issue-chat daily shares, and the per-conversation caps. That's an accounting leak in the ISE-68 model and undermines the Sprint 23 spend-visibility work.

Fix: capture partial usage from the run before yielding the `budget_exceeded` error (pydantic-ai exposes usage on the exception/run state), then `record_usage` + cost-estimate as on the success path. Backfill isn't possible (token split not stored), so just fix go-forward.