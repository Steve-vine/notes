---
id: 01KXX7KDMJK1YACXH6N4JZYM7D
created: 2026-07-19T13:03:44.786601071Z
updated: 2026-07-23T13:55:00.318063Z
type: task
title: Obs Loop scheduler + per-integration cadence (Settings)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 139
sprint: srmqjcq
blocked_by:
- 01KXX7K8R65X6T8GT55032WHF8
comments:
- id: 01KXXS360Z89NE9B17B6JTRDMJ
  author: Steve Vine
  at: 2026-07-19T18:09:27.071571759Z
  text: |-
    Done. Obs Loop engine + Settings control built. PR #125 → main (CI all green: backend, frontend, api-types, secret-scan). Merged to staging (f4c4e81). Moved to Review.

    Backend: split detect()=Alerts / detect_observations()=Observations; signal-type-scoped reconcile so the Alert and Obs loops never recover each other's findings; new ISE_api.obs_loop (Beat dispatch-obs-loop, opt-in, per-integration containment); per-system obs cadence + last-run fields (migration 0030); POST /systems/{id}/obs-run. UI: Observation detection card on system detail (enable/cadence/last-run/Run now). Detectors land in ISE-140.
assignee: steve
priority: high
task_status: done
---
**Sprint 14 (vertical slice: backend + UI).** The engine + the control for it.

- **Backend**: a slow scheduled loop (Celery beat) that runs each integration's `observations` capability (ADR 0027) on an admin-set schedule/opt-in, persisting Observations (`Finding` with `signal_type=observation` + confidence). Idempotent, per-integration containment.
- **UI**: a **Settings → Integrations** control per integration — enable/disable observation detection, set cadence, and see last-run status + any error.

**DoD**: an admin enables and schedules the Obs Loop for an integration from Settings and sees it run (last-run timestamp); observations it produces appear on the existing **Observations** screen. Not done until the Settings control drives a visible run.

Depends on ADR 0030.