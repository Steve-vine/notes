---
id: 01KZVDZF3VY3ZC0YVJ4SY4EAMT
created: 2026-08-12T16:48:05.755384Z
updated: 2026-08-12T16:48:39.2668Z
type: task
title: 'Dispatcher guard: warn when a root target''s kind isn''t in the engine''s accepted input set'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 209
sprint: sp88phy
assignee: steve
imported_from: linear
label:
- tech_debt
priority: low
task_status: done
---
Surfaced fixing [DEV-578](<https://linear.app/stevevine/issue/DEV-578>).

### Problem

In DEV-578 the port-scanner engine declared `supportedTargetKinds: [domain, ip]` in its seed CR but the runner's `_SUPPORTED_INPUT_KINDS` omitted `domain`. A root step triggered with `RV_TARGET_KIND=domain` had its target **silently dropped** by `_collect_inputs` → no inputs → the engine returned cleanly and the step reported `succeeded` **with** `asset_count=0`. The failure was invisible: nothing in the run report or step status distinguished "scanned and found nothing" from "dropped the input I was handed".

This is a whole *class* of mismatch — any engine whose runner-accepted input kinds drift from the kinds its CR advertises (`supportedTargetKinds` for the trigger target, `acceptsAssetKinds` for chained inputs) will silently no-op rather than fail loudly.

### Proposed

A dispatcher-side (or ingest-side) guard that detects when an engine is handed a root target — or chained input — whose kind the engine then accepts zero of, and surfaces it as a warning / non-silent signal rather than a clean success. Options to weigh during triage:

* Dispatcher pre-flight: cross-check the trigger target kind against the engine's declared accepted kinds before launching the Job, and warn (or refuse) on mismatch.
* Engine-side: have the SDK emit a non-fatal `warning` event when `_collect_inputs` drops **every** input, so "0 inputs accepted" is visible in the event stream and run report instead of an INFO log line.
* Conformance CLI: assert `supportedTargetKinds ⊆ runner-accepted kinds` so the drift is caught at engine-build time.

### Acceptance

A root step (or chained step) whose input kind the engine drops entirely no longer presents as a silent `succeeded / 0 assets` — it produces a visible warning, and/or the drift is caught before the Job runs.

---

Imported from Linear [DEV-582](https://linear.app/stevevine/issue/DEV-582/dispatcher-guard-warn-when-a-root-targets-kind-isnt-in-the-engines)