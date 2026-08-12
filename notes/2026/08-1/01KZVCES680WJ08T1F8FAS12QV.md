---
id: 01KZVCES680WJ08T1F8FAS12QV
created: 2026-08-12T16:21:30.440263Z
updated: 2026-08-12T16:22:31.436123Z
type: task
title: Workflow scheduling with Celery beat
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 149
sprint: sv5cbvq
assignee: steve
imported_from: linear
label:
- feature
priority: null
task_status: done
---
Add a Schedule to a Workflow; Celery beat dispatches WorkflowRuns on cadence. New failure surface — flag schedule drift, duplicate runs on worker restart, and timezone handling in the brief.

---

Imported from Linear [DEV-182](https://linear.app/stevevine/issue/DEV-182/workflow-scheduling-with-celery-beat)