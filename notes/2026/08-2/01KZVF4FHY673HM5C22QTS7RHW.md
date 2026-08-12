---
id: 01KZVF4FHY673HM5C22QTS7RHW
created: 2026-08-12T17:08:18.622872Z
updated: 2026-08-12T17:11:10.040418Z
type: task
title: M6.5 P3 — Controller validation of setting-reference annotations
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 292
sprint: set2ygr
assignee: steve
imported_from: linear
label: null
priority: null
task_status: done
---
**Piece 3 of 7 — M6.5.** Install-time validation of the `x-rv-setting-ref` annotation in the engine controller.

## Why this shrank

Triage assumed "CRD v2 schema + migration." It isn't needed: the CRD stores `paramsSchema` as `x-kubernetes-preserve-unknown-fields` (free-form), and the DB cache already stores the whole `params_schema` blob. So the spec-1.1.0 `x-rv-setting-ref` annotation is carried end-to-end with **no CRD schema change, no cach…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-328](https://linear.app/stevevine/issue/DEV-328/m65-p3-controller-validation-of-setting-reference-annotations)