---
id: 01KZVBNQXBWB4Y4G3N52MNFD77
created: 2026-08-12T16:07:49.931073Z
updated: 2026-08-12T16:08:24.904763Z
type: task
title: '`useParams({from})` route ID typing is too permissive'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 131
sprint: s1hm0kb
assignee: steve
imported_from: linear
label:
- follow_up
- tech_debt
priority: low
task_status: backlog
---
TanStack Router's Register type lets through any string literal. Production builds drop the `Invariant failed: ...` message body, so the surface error was an unhelpful "Invariant failed". Mitigation options: (a) typed wrapper hook that requires a route reference object, (b) eslint rule banning string literals in `from:`, (c) generated route-tree IDs via TanStack Router's file-based mode. Option (a) is the cheapest. Affects all 5 route wrappers under `routes/projects/`.

Source: Obsidian To Do § From Brief 008b.

---

Imported from Linear [DEV-47](https://linear.app/stevevine/issue/DEV-47/useparamsfrom-route-id-typing-is-too-permissive) · parent DEV-14