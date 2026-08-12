---
id: 01KZVB1VZ56V2YVS0VGYDGMCBC
created: 2026-08-12T15:56:58.725508Z
updated: 2026-08-12T15:58:14.56914Z
type: task
title: Add partial unique index for soft-deleted target re-creation
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 89
sprint: s1hm0kb
assignee: steve
imported_from: linear
label:
- follow_up
- tech_debt
priority: low
task_status: backlog
---
Add `(company_id, project_id, kind, value) WHERE deleted_at IS NULL` to replace the app-layer duplicate check in `TargetRepository.create()`. The session summary's claim that `WHERE deleted_at IS NULL` would prevent re-creation after soft-delete is incorrect (the partial-index `WHERE` excludes soft-deleted rows from the uniqueness check). App-layer check works at current scale; promote when concurrency or scale warrants race-safety.

Source: Obsidian To Do § From Brief 008a.

---

Imported from Linear [DEV-40](https://linear.app/stevevine/issue/DEV-40/add-partial-unique-index-for-soft-deleted-target-re-creation) · parent DEV-13