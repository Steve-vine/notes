---
id: 01KYCGDVFDM7AV65JPACK9K2ZH
created: 2026-07-25T11:26:36.013235Z
updated: 2026-07-25T11:26:36.013235Z
type: task
title: Per-task-type run caps from measured numbers
label:
- improvement
- follow_up
task_status: backlog
assignee: steve
priority: medium
project: 01KX671DATY39VW6GWK3M2T3DN
number: 286
---
**Sprint 24 tuning, batch 2 — start after batch 1 completes.** ISE-264 audit rec 5.

Once the push→pull context and cheap-verdict-first land (shrinking the real footprint) and per-stage instrumentation measures it, set per-task-type default run caps sized from the numbers: analyse-issue is a *recheck* and should not share diagnose's 200k budget — markedly lower. Mechanism already exists (`AILimits`, ISE-248/ADR 0033); this is sensible per-task defaults.

Explicitly NOT: raising `ai_run_max_tokens` — the audit's headline finding is that the cap is a runaway guard, not the cost control, and raising it treats the symptom.