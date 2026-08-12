---
id: 01KZVFKHV0HESYTDYFGGPJRFD9
created: 2026-08-12T17:16:32.480254Z
updated: 2026-08-12T17:17:25.126717Z
type: task
title: Flip `engine_strict_handshake` default to True (M6 close)
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 334
sprint: syc8wmf
assignee: steve
imported_from: linear
priority: medium
task_status: done
---
Brief 058 / DEV-265 introduced `Settings.engine_strict_handshake` (default `False`) as a transitional gate. Under grace mode, engine streams missing a valid `handshake` first event log a WARN and set `meta.handshake_missing=True` but the step run continues. Under strict mode, they f…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-272](https://linear.app/stevevine/issue/DEV-272/flip-engine-strict-handshake-default-to-true-m6-close)