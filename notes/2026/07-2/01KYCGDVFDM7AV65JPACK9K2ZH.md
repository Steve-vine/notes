---
id: 01KYCGDVFDM7AV65JPACK9K2ZH
created: 2026-07-25T11:26:36.013235Z
updated: 2026-08-13T19:00:23.486763Z
type: task
title: Per-task-type run caps from measured numbers
project: 01KX671DATY39VW6GWK3M2T3DN
number: 286
sprint: svgrad3
blocked_by:
- 01KYCGCWNZ51471E3ZM80R6BTE
- 01KYCGD343RQ8WCTXBJP7DMZW5
- 01KYCGD93A325Q2VJB9P3EWMAH
comments:
- id: 01KYD0JWMXYBEBS7ET7RAKHP9K
  author: Steve Vine
  at: 2026-07-25T16:08:58.269398Z
  text: |-
    Done — PR #261 (feature/ise-286-per-task-run-caps → main), CI running.

    - PER_TASK_RUN_MAX_TOKENS + run_max_tokens_for(task, limits): per-task default bounded by the admin ceiling ai_run_max_tokens (min). analyse-issue 60k (was sharing diagnose's 200k), propose 120k, followup 20k, summarise-state 30k, summarise-document 45k, extract-claims 60k; diagnose keeps the full ceiling. Wired in _run_with_fallback. Reuses AILimits/ADR 0033 — no migration.
    - NOT a raise of ai_run_max_tokens (the cap is a runaway guard). Sized to task shape post-282/281; refine against ISE-283 measured numbers as staging data accrues.
    - Headless tuning — effect visible on the run-detail Spend breakdown (ISE-283) and via run_limit_exceeded when a cap trips.
    - Tests: test_per_task_run_caps.py (recheck-vs-diagnose, ceiling-is-a-floor, disabled-ceiling bounds, unknown task). ruff+mypy(312 fresh) green.
assignee: steve
label: null
priority: medium
task_status: done
tech: null
---
**Sprint 24 tuning, batch 2 — start after batch 1 completes.** ISE-264 audit rec 5.

Once the push→pull context and cheap-verdict-first land (shrinking the real footprint) and per-stage instrumentation measures it, set per-task-type default run caps sized from the numbers: analyse-issue is a *recheck* and should not share diagnose's 200k budget — markedly lower. Mechanism already exists (`AILimits`, ISE-248/ADR 0033); this is sensible per-task defaults.

Explicitly NOT: raising `ai_run_max_tokens` — the audit's headline finding is that the cap is a runaway guard, not the cost control, and raising it treats the symptom.