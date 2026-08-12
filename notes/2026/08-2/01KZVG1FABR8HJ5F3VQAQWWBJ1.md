---
id: 01KZVG1FABR8HJ5F3VQAQWWBJ1
created: 2026-08-12T17:24:08.65114Z
updated: 2026-08-12T17:24:08.65114Z
type: task
title: Workflow dispatcher crashes advancing chained step — TargetKind/AssetKind enum mismatch
assignee: steve
imported_from: linear
priority: urgent
label:
- follow_up
- bug
task_status: done
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 373
---
## Summary

Brief 020 dispatcher crashes when advancing past step 0 of any chained workflow (Selector → Scan). Step 1 stays at QUEUED forever; the workflow run is permanently stuck at `running`. Surfaced during Brief 022 / [DEV-186](<https://linear.app/stevevine/issue/DEV-186>) smoke test on minikube — first end-to-end chained run since Brief 020 landed.

## Root cause

`tasks/workflow_runs.py::_build_next_inputs_from_outputs` filters `assets.ki…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-188](https://linear.app/stevevine/issue/DEV-188/workflow-dispatcher-crashes-advancing-chained-step-targetkindassetkind) · parent DEV-186