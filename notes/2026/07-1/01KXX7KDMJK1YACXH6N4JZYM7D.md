---
id: 01KXX7KDMJK1YACXH6N4JZYM7D
created: 2026-07-19T13:03:44.786601071Z
updated: 2026-07-19T13:23:51.467667Z
type: task
title: Obs Loop scheduler + per-integration cadence (Settings)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 139
sprint: srmqjcq
blocked_by:
- 01KXX7K8R65X6T8GT55032WHF8
assignee: steve
label:
- feature
priority: high
task_status: backlog
---
**Sprint 14 (vertical slice: backend + UI).** The engine + the control for it.

- **Backend**: a slow scheduled loop (Celery beat) that runs each integration's `observations` capability (ADR 0027) on an admin-set schedule/opt-in, persisting Observations (`Finding` with `signal_type=observation` + confidence). Idempotent, per-integration containment.
- **UI**: a **Settings → Integrations** control per integration — enable/disable observation detection, set cadence, and see last-run status + any error.

**DoD**: an admin enables and schedules the Obs Loop for an integration from Settings and sees it run (last-run timestamp); observations it produces appear on the existing **Observations** screen. Not done until the Settings control drives a visible run.

Depends on ADR 0030.