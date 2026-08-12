---
id: 01KZVEFSMGW0FBWSTK6YEAXY46
created: 2026-08-12T16:57:00.81651Z
updated: 2026-08-12T16:57:00.81651Z
type: task
title: 'Conformance: assert engine emitted asset kinds ⊆ declaredAssetKinds'
task_status: done
priority: high
assignee: steve
imported_from: linear
label: follow_up
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 242
---
## Context

DEV-437 — `port-scanner` and `service-detection` emit `kind="endpoint"` while their (deployed) EngineVersion CRs declared `port`/`service`, so every asset was silently dropped at ingest (`UnknownAssetKindError`). The drift went unnoticed because **nothing checks t…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-438](https://linear.app/stevevine/issue/DEV-438/conformance-assert-engine-emitted-asset-kinds-declaredassetkinds) · parent DEV-437