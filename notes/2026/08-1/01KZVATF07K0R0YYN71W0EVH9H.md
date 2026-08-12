---
id: 01KZVATF07K0R0YYN71W0EVH9H
created: 2026-08-12T15:52:56.071793Z
updated: 2026-08-12T15:53:57.357489Z
type: task
title: 'Asset list endpoint: search, faceting, count performance at scale'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 68
sprint: s1yya2y
assignee: steve
imported_from: linear
label:
- tech_debt
priority: low
task_status: backlog
---
Current implementation does `COUNT(*)` over the same filter. Fine at current scale; revisit when projects exceed \~100k assets. Will likely need a separate count cache, or estimated-count + paged-when-needed UX.

Source: Obsidian To Do § Backlog.

---

Imported from Linear [DEV-73](https://linear.app/stevevine/issue/DEV-73/asset-list-endpoint-search-faceting-count-performance-at-scale)