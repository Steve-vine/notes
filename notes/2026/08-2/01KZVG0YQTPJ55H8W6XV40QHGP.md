---
id: 01KZVG0YQTPJ55H8W6XV40QHGP
created: 2026-08-12T17:23:51.674624Z
updated: 2026-08-12T17:23:51.674624Z
type: task
title: Strip whitespace from workflow_schedule cron_expression
priority: low
label: bug
assignee: steve
imported_from: linear
task_status: done
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 368
---
## Observation

`PUT /api/v1/workflows/{id}/schedule` accepts and persists trailing whitespace in `cron_expression`. Live cluster verification of Brief 024 found the stored value as `"*/10 * * * *   "` (three trailing spaces). `croniter.is_valid` tolerates the whitespace so the cron still fires correctly, but the round-tripped value drifts on every PUT and looks wrong in API responses + the UI's read view.

Surfaced during …

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-193](https://linear.app/stevevine/issue/DEV-193/strip-whitespace-from-workflow-schedule-cron-expression)