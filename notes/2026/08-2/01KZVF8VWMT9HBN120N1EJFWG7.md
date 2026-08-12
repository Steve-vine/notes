---
id: 01KZVF8VWMT9HBN120N1EJFWG7
created: 2026-08-12T17:10:42.324461Z
updated: 2026-08-12T17:11:07.986469Z
type: task
title: 'Asset/Finding company-scoping (backend close-out): drop project-scoping columns + migrate last readers'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 297
assignee: steve
imported_from: linear
label: null
priority: medium
task_status: done
---
Backend contract close-out for ADR 035 — split from DEV-322 (2026-06-05) so the destructive column drop is an isolated, focused PR rather than buried in the frontend cutover. Removes the last readers/writers of the project-scoping columns, then drops them. **Blocked by** …

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-324](https://linear.app/stevevine/issue/DEV-324/assetfinding-company-scoping-backend-close-out-drop-project-scoping)