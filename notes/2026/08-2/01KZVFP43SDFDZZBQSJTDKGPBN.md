---
id: 01KZVFP43SDFDZZBQSJTDKGPBN
created: 2026-08-12T17:17:56.729362Z
updated: 2026-08-12T17:17:56.729362Z
type: task
title: Brief 061 — Route on I/O declarations (drop workflow step kinds)
assignee: steve
priority: medium
task_status: done
imported_from: linear
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 337
---
## Scope

Kill the Selector/Scan step-type binary. Workflow steps stop carrying a `step_type` discriminator; routing happens entirely on the engine's declared I/O (`accepts_asset_kinds` / `produces_asset_kinds` / produces findings) from its `EngineVersion`.

## What this brief delivers

* **Workflow step model:** remove `step_type` column (or repurpose as a derived UI label)
* **Chaining logic** in `_build_next_inputs_from_outputs` — routes pure…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-268](https://linear.app/stevevine/issue/DEV-268/brief-061-route-on-io-declarations-drop-workflow-step-kinds)