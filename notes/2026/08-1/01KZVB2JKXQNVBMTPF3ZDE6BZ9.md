---
id: 01KZVB2JKXQNVBMTPF3ZDE6BZ9
created: 2026-08-12T15:57:21.917443Z
updated: 2026-08-12T15:57:21.917443Z
type: task
title: Simplify test DB lifecycle
task_status: backlog
label:
- follow_up
- tech_debt
priority: low
imported_from: linear
assignee: steve
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 96
---
The session-scoped shared engine + per-test reconfigure tests are a bit ceremonial now; could retire the explicit reconfigure paths once every test uses the shared engine.

Source: Obsidian To Do § From Brief 004.

---

Imported from Linear [DEV-33](https://linear.app/stevevine/issue/DEV-33/simplify-test-db-lifecycle) · parent DEV-8