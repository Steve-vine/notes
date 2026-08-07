---
id: 01KYAT544CHRMKK31GCPMEDG37
created: 2026-07-24T19:38:06.860746Z
updated: 2026-08-07T09:40:41.849082Z
type: task
title: Record usage and cost for limit-killed engine runs (ISE-253's second door)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 267
sprint: sthz8ne
comments:
- id: 01KYC52B5GHR9CJYFFQ4EX7W8X
  author: Steve Vine
  at: 2026-07-25T08:08:04.528259Z
  text: |-
    Done — PR #251 (green), merged to staging.

    Fix: `_run_with_fallback` in engine.py now threads a run-owned `RunUsage()` accumulator into `agent.run_sync(..., usage=run_usage)` (the graph mutates it in place, so the partial token count survives the raise — same approach as the ISE-253 chat fix). On `UsageLimitExceeded` it calls `record_usage(run, messages_json=None, usage=run_usage, model=model_id)` before finishing, stamping input/output/cache tokens + a cost estimate. No transcript (the run never returned a result). Fresh accumulator per attempt so a fallback's cost is its own.

    Test: `test_per_run_token_budget_is_enforced` now asserts a limit-killed run persists non-zero `input_tokens` and a non-null `cost_usd`.

    No OpenAPI change (populates existing columns only). Combined with ISE-266 on staging: a limit-killed run both records its cost AND terminates as `run_limit_exceeded`.
assignee: steve
label: null
priority: medium
task_status: done
---
ISE-253 fixed usage recording for budget-exceeded *chat* turns — the same gap exists on the `run_agent` path in `engine.py`. Found live 2026-07-24: two analyse-issue runs (`ca2934c1`, `5a4358e7`) each burned 200k+ tokens before the `UsageLimitExceeded` kill and persisted with NULL cost. Today's spend panel reads $0.43 while real spend was ~ $1.60 — the runs that hit limits are exactly the most expensive ones, and they are invisible to the ceiling, the panels, and the Sprint 23 per-day/per-incident views.

Fix: on the engine's `UsageLimitExceeded` handler (engine.py ~line 130), capture partial usage from the run state before finishing the run — same approach as the ISE-253 chat fix — then `record_usage` + cost estimate as on success. Test: a run that exceeds the token cap persists non-zero input/output/cache tokens and a cost_usd.