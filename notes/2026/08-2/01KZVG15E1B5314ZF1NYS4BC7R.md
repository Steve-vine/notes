---
id: 01KZVG15E1B5314ZF1NYS4BC7R
created: 2026-08-12T17:23:58.529244Z
updated: 2026-08-12T17:23:58.529244Z
type: task
title: 'workflow_schedules: drop redundant ix_workflow_schedules_workflow_id index'
label: bug
assignee: steve
imported_from: linear
task_status: done
priority: medium
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 370
---
Migration `0008_workflow_schedules.py` creates an explicit index `ix_workflow_schedules_workflow_id` on top of the `UNIQUE(workflow_id)` constraint. Postgres already creates an implicit unique index for the constraint, so the explicit index duplicates it.

Tiny waste of disk + minor write overhead on every UPSERT / UPDATE. Not a functional bug.

## Fix

A new migration that drops `ix_workflow_schedules_workflow_id`. Don't edit `0008` retroactive…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-191](https://linear.app/stevevine/issue/DEV-191/workflow-schedules-drop-redundant-ix-workflow-schedules-workflow-id)