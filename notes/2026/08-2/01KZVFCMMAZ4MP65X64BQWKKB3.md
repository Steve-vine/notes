---
id: 01KZVFCMMAZ4MP65X64BQWKKB3
created: 2026-08-12T17:12:45.962539Z
updated: 2026-08-12T17:18:28.953767Z
type: task
title: Port httpx to the engine plugin contract
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 313
sprint: syc8wmf
assignee: steve
imported_from: linear
label: null
priority: medium
task_status: done
---
**M6 engine port (3 of 4).** Port `httpx` onto the M5 plugin contract — the **second external-tool wrapper**, confirming the wrapper pattern subfinder establishes.

Porting means:

* Engine image bundles SDK + shim around the httpx binary (EXTERNAL_JOB), spec-1.0.0 handshake + NDJSON via the SDK stdout path.
* `EngineVersion` CR sole declaration: `acceptsAssetKinds` (e.g. subdomain), `declaredAssetKinds` (url + technology), params JSON Schema, r…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-306](https://linear.app/stevevine/issue/DEV-306/port-httpx-to-the-engine-plugin-contract)