---
id: 01KZVF9DY9PT2EH6H2SSDQ4HDN
created: 2026-08-12T17:11:00.80959Z
updated: 2026-08-12T17:11:09.982076Z
type: task
title: 'Asset/Finding company-scoping (1/4): model + migration — asset_projects assoc, drop project_id columns'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 302
assignee: steve
imported_from: linear
label: null
priority: high
task_status: done
---
Implements the schema half of ADR 035 (Asset/Finding company-scoping). **Foundation of the cluster — GATE; blocks the other three.**

## Scope

* New `asset_projects` association table: `(asset_id FK→assets ON DELETE CASCADE, project_id FK→projects ON DELETE CASCADE, first_observed_at)`, unique on `(asset_id, project_id)`, indexed for the project-filter join. Pure provenance (observed-by); no primary/owning project.
* **Drop** `assets.project_id…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-319](https://linear.app/stevevine/issue/DEV-319/assetfinding-company-scoping-14-model-migration-asset-projects-assoc)