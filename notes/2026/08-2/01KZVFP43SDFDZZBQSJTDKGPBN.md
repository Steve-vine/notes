---
id: 01KZVFP43SDFDZZBQSJTDKGPBN
created: 2026-08-12T17:17:56.729362Z
updated: 2026-08-12T17:19:08.126067Z
type: task
title: Brief 061 — Route on I/O declarations (drop workflow step kinds)
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 337
sprint: ssxh43d
assignee: steve
imported_from: linear
label: null
priority: medium
task_status: done
---
## Scope

Kill the Selector/Scan step-type binary. Workflow steps stop carrying a `step_type` discriminator; routing happens entirely on the engine's declared I/O (`accepts_asset_kinds` / `produces_asset_kinds` / produces findings) from its `EngineVersion`.

## What this brief delivers

* **Workflow step model:** remove `step_type` column (or repurpose as a derived UI label)
* **Chaining logic** in `_build_next_inputs_from_outputs` — routes pure…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-268](https://linear.app/stevevine/issue/DEV-268/brief-061-route-on-io-declarations-drop-workflow-step-kinds)