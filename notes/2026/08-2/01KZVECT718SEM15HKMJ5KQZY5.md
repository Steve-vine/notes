---
id: 01KZVECT718SEM15HKMJ5KQZY5
created: 2026-08-12T16:55:23.105038Z
updated: 2026-08-12T16:55:23.105038Z
type: task
title: 'Run report: inventory-selector shows "0 assets" though it fed seeds downstream (show seed count)'
task_status: done
imported_from: linear
priority: low
label: follow_up
assignee: steve
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 234
---
## Context

The `inventory-selector` (Scope-feed) step reports `asset_count: 0` in the run report, even when it clearly did its job — it fed seeds to the next step (web-probe received and probed them). This reads as a failure ("found nothing") when it's working as designed.

Per ADR-037 §1 / Brief 116c, the Scope-feed selector emits **non-persisted seeds** (it mints no assets); the seeds are stashed on the step meta as `seed_inputs` and `_advanc…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-446](https://linear.app/stevevine/issue/DEV-446/run-report-inventory-selector-shows-0-assets-though-it-fed-seeds)