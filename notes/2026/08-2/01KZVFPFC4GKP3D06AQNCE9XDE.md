---
id: 01KZVFPFC4GKP3D06AQNCE9XDE
created: 2026-08-12T17:18:08.260578Z
updated: 2026-08-12T17:19:16.652713Z
type: task
title: Brief 058 — Dispatcher handshake parsing + version negotiation
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 340
sprint: ssxh43d
assignee: steve
imported_from: linear
label: null
priority: medium
task_status: done
---
## Scope

Make the dispatcher actually enforce the engine contract pinned in Brief 056 / ADR 030. Until this brief lands, the SDK (Brief 057) emits handshakes but the dispatcher ignores them — the wire contract is documented but not enforced.

## What this brief delivers

* Dispatcher reads the `handshake` event as the first emission on every engine stream
* Records `engine_name`, `engine_version`, `spec_version`, `image_digest` in `WorkflowStep…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-265](https://linear.app/stevevine/issue/DEV-265/brief-058-dispatcher-handshake-parsing-version-negotiation)