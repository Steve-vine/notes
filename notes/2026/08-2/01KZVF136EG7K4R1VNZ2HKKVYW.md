---
id: 01KZVF136EG7K4R1VNZ2HKKVYW
created: 2026-08-12T17:06:27.662176Z
updated: 2026-08-12T17:06:27.662176Z
type: task
title: katana — JS-aware web crawler (M7 engine 4/4)
label: feature
task_status: done
priority: medium
imported_from: linear
assignee: steve
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 283
---
**M7 new engine (4 of 4).** Build `katana` as a self-contained engine against the finalised spec 1.1.0 / CRD v2 — **no backend or frontend changes** (M6.5 acceptance bar). JS-aware crawler; extends in-app attack surface (URL → URLs). The deepest test of chain depth in M7.

## Footprint (engine-only)

* `app/scanners/katana/` — Dockerfile, `runner.py`, conformance tests.
* `chart/seeds/katana.yaml` — `Engine` + `EngineVersion` CRs.
* Nothing else…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-355](https://linear.app/stevevine/issue/DEV-355/katana-js-aware-web-crawler-m7-engine-44)