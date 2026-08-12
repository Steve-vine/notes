---
id: 01KZVFCC8YQQYX7XCX94Z32T18
created: 2026-08-12T17:12:37.406928Z
updated: 2026-08-12T17:13:39.956874Z
type: task
title: 'M6 close-out: delete legacy registration code path + remove M5 shim'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 311
sprint: syc8wmf
assignee: steve
imported_from: linear
priority: medium
task_status: done
---
**M6 close-out — "engine metadata: cache is the only source."** Every engine (asset-query, cloudflare, subfinder, httpx, nuclei) is CR-sourced and emits a spec-1.0.0 handshake; `_OPTS_REGISTRY` is already an empty dict and the dispatcher, `/engines` route, and workflow validation already read the CR cache for CR-sourced engines (all of them). This issue removes the now-dead in-code engine-metadata layer so the cache is provably the only source. …

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-308](https://linear.app/stevevine/issue/DEV-308/m6-close-out-delete-legacy-registration-code-path-remove-m5-shim)