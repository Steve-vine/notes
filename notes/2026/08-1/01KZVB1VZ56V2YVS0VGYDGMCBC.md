---
id: 01KZVB1VZ56V2YVS0VGYDGMCBC
created: 2026-08-12T15:56:58.725508Z
updated: 2026-08-12T15:56:58.725508Z
type: task
title: Add partial unique index for soft-deleted target re-creation
priority: low
label:
- follow_up
- tech_debt
assignee: steve
task_status: backlog
imported_from: linear
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 89
---
Add `(company_id, project_id, kind, value) WHERE deleted_at IS NULL` to replace the app-layer duplicate check in `TargetRepository.create()`. The session summary's claim that `WHERE deleted_at IS NULL` would prevent re-creation after soft-delete is incorrect (the partial-index `WHERE` excludes soft-deleted rows from the uniqueness check). App-layer check works at current scale; promote when concurrency or scale warrants race-safety.

Source: Obsidian To Do § From Brief 008a.

---

Imported from Linear [DEV-40](https://linear.app/stevevine/issue/DEV-40/add-partial-unique-index-for-soft-deleted-target-re-creation) · parent DEV-13