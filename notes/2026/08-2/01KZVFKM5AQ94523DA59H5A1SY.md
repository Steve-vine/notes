---
id: 01KZVFKM5AQ94523DA59H5A1SY
created: 2026-08-12T17:16:34.858019Z
updated: 2026-08-12T17:16:34.858019Z
type: task
title: Brief 063 — Port asset-query as reference implementation
task_status: done
assignee: steve
priority: high
imported_from: linear
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 335
---
## Scope

Port `asset-query` (currently an internal engine per ADR 024) to the new contract end-to-end: SDK-emitted handshake, `EngineVersion` CR install, declared I/O, conformance-CLI passing. First engine on the new contract. **Proves the M5 substrate works.**

## What this brief delivers

* **asset-query as an** `EngineVersion` **install** — declares its `accepts_asset_kinds`, `produces_asset_kinds`, params JSON Schema, resource needs, transp…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-270](https://linear.app/stevevine/issue/DEV-270/brief-063-port-asset-query-as-reference-implementation)