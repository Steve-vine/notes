---
id: 01KZVFKAZM57W6JH76Z955RJ1H
created: 2026-08-12T17:16:25.460281Z
updated: 2026-08-12T17:16:25.460281Z
type: task
title: Frontend deprecation badge for engines with `deprecated` lifecycle
task_status: done
assignee: steve
priority: low
imported_from: linear
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 332
---
## Context

Brief 059b honours `EngineVersion.spec.lifecycle` server-side:

* `available` → step run dispatches normally
* `deprecated` → step run dispatches with a WARN log, and the `/engines` API exposes `lifecycle: "deprecated"` on the engine row
* `retired` → resolver excludes it; new step runs rejected with `ENGINE_VERSION_RETIRED`

The API surface is in 059b. **The UI side is not.** Operators using the workflow editor / engine picker still…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-277](https://linear.app/stevevine/issue/DEV-277/frontend-deprecation-badge-for-engines-with-deprecated-lifecycle)