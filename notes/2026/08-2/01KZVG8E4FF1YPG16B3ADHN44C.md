---
id: 01KZVG8E4FF1YPG16B3ADHN44C
created: 2026-08-12T17:27:56.81552Z
updated: 2026-08-12T17:28:28.291012Z
type: task
title: tlsx — TLS / certificate analysis (M7 engine 2/4)
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 395
sprint: s0ht2jk
assignee: steve
imported_from: linear
label:
- feature
priority: low
task_status: done
---
**M7 new engine (2 of 4).** Build `tlsx` as a self-contained engine against the finalised spec 1.1.0 / CRD v2 — **no backend or frontend changes** (M6.5 acceptance bar). Cheap, high-value; validates the SDK's small-engine ergonomics.

## Footprint (engine-only)

* `app/scanners/tlsx/` — Dockerfile, `runner.py`, conformance tests.
* `chart/seeds/tlsx.yaml` — `Engine` + `EngineVersion` CRs.
* Nothing else. Any backend/frontend gap surfaced → **new…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-117](https://linear.app/stevevine/issue/DEV-117/tlsx-tls-certificate-analysis-m7-engine-24)