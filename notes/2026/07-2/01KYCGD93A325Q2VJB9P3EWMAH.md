---
id: 01KYCGD93A325Q2VJB9P3EWMAH
created: 2026-07-25T11:26:17.194395Z
updated: 2026-07-25T11:40:09.040431Z
type: task
title: Per-stage token instrumentation + run-detail spend breakdown
project: 01KX671DATY39VW6GWK3M2T3DN
number: 283
sprint: svgrad3
blocked_by:
- 01KYCGD343RQ8WCTXBJP7DMZW5
assignee: steve
priority: medium
task_status: todo
---
**Sprint 24 tuning, batch 1. Pillar 2 — and the sprint's user-facing screen.** ISE-264 audit rec 4; journey gap D ("you can see what an incident cost, but not why").

- Record a `token_breakdown` on `AgentRun` (JSONB; migration): estate-context size, per-tool-result sizes (by tool), iteration count, system-prompt/schema overhead, output size.
- Surface it on the run-detail screen as a spend breakdown — an operator can see *where* a big run's tokens went and judge whether the cost was warranted.
- First job once live: confirm or correct the audit's structural estimates (its stated purpose), and provide the measured numbers the per-task-caps task (batch 2) needs.
- Rides along: fix the stale L15 trigger description — `AI_TASK_DESCRIPTIONS["analyse-issue"]` claims a detection-schedule trigger that doesn't exist (`models.py:124`); correct to the real triggers (button / issue-chat / post-execution verify).

Sequence after the push→pull task ideally, so the breakdown measures the new context shape.