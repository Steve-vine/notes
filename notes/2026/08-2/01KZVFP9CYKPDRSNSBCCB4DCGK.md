---
id: 01KZVFP9CYKPDRSNSBCCB4DCGK
created: 2026-08-12T17:18:02.142289Z
updated: 2026-08-12T17:19:12.745461Z
type: task
title: Brief 060a — Dynamic asset kinds machinery (backend)
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 338
sprint: ssxh43d
assignee: steve
imported_from: linear
label: null
priority: high
task_status: done
---
## Scope

Implement the dynamic asset-kinds machinery that Brief 056 §6 describes as a mechanism but doesn't make real. After this brief, installing an `EngineVersion` that declares a new kind (e.g. `certificate`, `service`) extends the platform's registry without a code change or migration.

## What this brief delivers

* `asset_kinds` **table** — name, canonical_pattern, description, first_declared_by, lifecycle state
* **Migration:** `assets.…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-267](https://linear.app/stevevine/issue/DEV-267/brief-060a-dynamic-asset-kinds-machinery-backend)