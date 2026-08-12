---
id: 01KZVB2JKXQNVBMTPF3ZDE6BZ9
created: 2026-08-12T15:57:21.917443Z
updated: 2026-08-12T15:58:31.370239Z
type: task
title: Simplify test DB lifecycle
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 96
sprint: s1hm0kb
assignee: steve
imported_from: linear
label:
- follow_up
- tech_debt
priority: low
task_status: backlog
---
The session-scoped shared engine + per-test reconfigure tests are a bit ceremonial now; could retire the explicit reconfigure paths once every test uses the shared engine.

Source: Obsidian To Do § From Brief 004.

---

Imported from Linear [DEV-33](https://linear.app/stevevine/issue/DEV-33/simplify-test-db-lifecycle) · parent DEV-8