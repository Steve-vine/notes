---
id: 01KZVFTBGMQ26GVAGJ836YE2NE
created: 2026-08-12T17:20:15.380027Z
updated: 2026-08-12T17:21:30.777158Z
type: task
title: Findings list and detail UI
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 352
sprint: sz0gev3
assignee: steve
imported_from: linear
label:
- feature
priority: medium
task_status: done
---
Frontend surface for findings, analogous to `features/workflows` and `features/assets`. Required to validate Phase 4 end-to-end without curl.

## Scope

**Findings list (project-scoped)**

* `features/findings/finding-list.tsx` — paginated table with severity, status, asset, title, first-seen, SLA deadline columns.
* Filters: severity (multi-select), status (multi-select), asset search.
* TanStack Query hook with structured cache key factory mat…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-250](https://linear.app/stevevine/issue/DEV-250/findings-list-and-detail-ui)