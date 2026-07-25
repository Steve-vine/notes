---
id: 01KYCGDVFDM7AV65JPACK9K2ZH
created: 2026-07-25T11:26:36.013235Z
updated: 2026-07-25T13:06:17.396168Z
type: task
title: Per-task-type run caps from measured numbers
project: 01KX671DATY39VW6GWK3M2T3DN
number: 286
sprint: svgrad3
blocked_by:
- 01KYCGCWNZ51471E3ZM80R6BTE
- 01KYCGD343RQ8WCTXBJP7DMZW5
- 01KYCGD93A325Q2VJB9P3EWMAH
assignee: steve
label: null
priority: medium
task_status: backlog
---
**Sprint 24 tuning, batch 2 — start after batch 1 completes.** ISE-264 audit rec 5.

Once the push→pull context and cheap-verdict-first land (shrinking the real footprint) and per-stage instrumentation measures it, set per-task-type default run caps sized from the numbers: analyse-issue is a *recheck* and should not share diagnose's 200k budget — markedly lower. Mechanism already exists (`AILimits`, ISE-248/ADR 0033); this is sensible per-task defaults.

Explicitly NOT: raising `ai_run_max_tokens` — the audit's headline finding is that the cap is a runaway guard, not the cost control, and raising it treats the symptom.