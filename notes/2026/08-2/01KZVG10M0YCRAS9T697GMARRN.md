---
id: 01KZVG10M0YCRAS9T697GMARRN
created: 2026-08-12T17:23:53.600389Z
updated: 2026-08-12T17:24:45.640635Z
type: task
title: Re-validate workflow schedules on workflow PATCH
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 369
sprint: sv5cbvq
assignee: steve
imported_from: linear
label:
- feature
priority: null
task_status: done
---
When a workflow's first step is replaced (PATCH on the workflow) with a step whose engine doesn't accept the schedule's stored `inputs[].kind`, the attached `workflow_schedule` is **not** re-validated. The schedule appears healthy in the API; the next tick fires, `create_workflow_run` validates the seed inputs against the new first-step engine, and dispatch fails with `WorkflowRunInputKindNotSupportedError`. The tick task catches it, logs `workf…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-192](https://linear.app/stevevine/issue/DEV-192/re-validate-workflow-schedules-on-workflow-patch)