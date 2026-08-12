---
id: 01KZVFXR9MYK02FCGYWB6S9A3W
created: 2026-08-12T17:22:06.772744Z
updated: 2026-08-12T17:22:06.772744Z
type: task
title: 'Engine params form: required `list[str]` falls back to raw-JSON edit'
priority: medium
task_status: done
assignee: steve
label: bug
imported_from: linear
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 359
---
**Observed during Brief 034 smoke (**DEV-234**), 2026-05-16.**

When creating a Workflow step with subfinder, the `domains` field (required `list[str]`, `min_length=1`) renders as a raw-JSON textarea with the hint "No dedicated input for this parameter — edit as raw JSON". The user has to type `[\"v…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-237](https://linear.app/stevevine/issue/DEV-237/engine-params-form-required-liststr-falls-back-to-raw-json-edit)