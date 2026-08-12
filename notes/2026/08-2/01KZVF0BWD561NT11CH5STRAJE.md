---
id: 01KZVF0BWD561NT11CH5STRAJE
created: 2026-08-12T17:06:03.789107Z
updated: 2026-08-12T17:06:07.460344Z
type: task
title: 'Dispatcher: finding-ingest rejects CR-declared asset kinds (AssetKind enum gap)'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 278
assignee: steve
imported_from: linear
label: null
priority: medium
task_status: done
---
**Escalated from** DEV-357 **(Brief 104) per the M7 engine-only guardrail.** Discovered 2026-06-09 verifying tlsx TLS-posture findings end-to-end on the dev cluster.

## Problem

The dispatcher's V1 **finding**-ingest path coerces a finding's `asset_kind` to the bootstrap `AssetK…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-362](https://linear.app/stevevine/issue/DEV-362/dispatcher-finding-ingest-rejects-cr-declared-asset-kinds-assetkind)