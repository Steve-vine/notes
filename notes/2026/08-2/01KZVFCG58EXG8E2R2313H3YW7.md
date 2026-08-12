---
id: 01KZVFCG58EXG8E2R2313H3YW7
created: 2026-08-12T17:12:41.384141Z
updated: 2026-08-12T17:13:42.035922Z
type: task
title: Port nuclei to the engine plugin contract
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 312
sprint: syc8wmf
assignee: steve
imported_from: linear
priority: medium
task_status: done
---
**M6 engine port (4 of 4) — the capstone port.** Port `nuclei` onto the M5 plugin contract. Done **last** deliberately: it's the most complex engine (findings + evidence + `HTTP_POST` transport per ADR 026), so by the time we touch it the contract has survived three ports and nuclei-isms won't shape the spec.

Porting means:

* Engine image: SDK + shim around the nuclei binary (EXTERNAL_JOB), spec-1.0.0 handshake; emits `finding` events + eviden…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-307](https://linear.app/stevevine/issue/DEV-307/port-nuclei-to-the-engine-plugin-contract)