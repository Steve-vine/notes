---
id: 01KYAT544CHRMKK31GCPMEDG37
created: 2026-07-24T19:38:06.860746Z
updated: 2026-07-25T07:40:03.505637Z
type: task
title: Record usage and cost for limit-killed engine runs (ISE-253's second door)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 267
sprint: sthz8ne
assignee: steve
priority: medium
task_status: active
---
ISE-253 fixed usage recording for budget-exceeded *chat* turns — the same gap exists on the `run_agent` path in `engine.py`. Found live 2026-07-24: two analyse-issue runs (`ca2934c1`, `5a4358e7`) each burned 200k+ tokens before the `UsageLimitExceeded` kill and persisted with NULL cost. Today's spend panel reads $0.43 while real spend was ~ $1.60 — the runs that hit limits are exactly the most expensive ones, and they are invisible to the ceiling, the panels, and the Sprint 23 per-day/per-incident views.

Fix: on the engine's `UsageLimitExceeded` handler (engine.py ~line 130), capture partial usage from the run state before finishing the run — same approach as the ISE-253 chat fix — then `record_usage` + cost estimate as on success. Test: a run that exceeds the token cap persists non-zero input/output/cache tokens and a cost_usd.