---
id: 01KZVG0W4ED8X63JM8JE0H2JBD
created: 2026-08-12T17:23:49.006618Z
updated: 2026-08-12T17:24:39.557141Z
type: task
title: Expose WorkflowRun.meta on workflow run API responses
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 367
sprint: sv5cbvq
assignee: steve
imported_from: linear
label:
- bug
priority: medium
task_status: done
---
## Observation

`WorkflowRun.meta` is stored correctly in the DB by `create_workflow_run` (dispatcher writes `triggered_by`, `schedule_id`, `schedule_dispatch` for scheduled runs per Brief 023's contract), but **the field is missing from** `WorkflowRunResponse` and `WorkflowRunSummaryResponse`. The API never surfaces it on either the detail or list endpoints.

Confirmed during …

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-194](https://linear.app/stevevine/issue/DEV-194/expose-workflowrunmeta-on-workflow-run-api-responses)