---
id: 01KZVFPC39XJ0S14GRH73CVSFJ
created: 2026-08-12T17:18:04.905934Z
updated: 2026-08-12T17:19:14.867151Z
type: task
title: Brief 059a — Engine + EngineVersion CRDs, controller, DB cache + seed CRs
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 339
sprint: ssxh43d
assignee: steve
imported_from: linear
label: null
priority: high
task_status: done
---
## Scope

**Foundational** half of the original Brief 059 (split at triage 2026-05-25). Lays down the CRD layer and controller without touching the dispatcher's existing read path. The cache is populated by the controller from day one but **no dispatcher code reads it** — `EngineMetadata` in `core/engines.py` is still authoritative until the cutover in Brief 059b. This brief is intentionally low-risk and reverts cleanly.

Carries ADR 031 — Engin…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-266](https://linear.app/stevevine/issue/DEV-266/brief-059a-engine-engineversion-crds-controller-db-cache-seed-crs)