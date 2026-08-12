---
id: 01KZVBFNQY45AMHSWM6066357B
created: 2026-08-12T16:04:31.102534Z
updated: 2026-08-12T16:04:31.102534Z
type: task
title: workflow_step_run_assets join table for selected-not-discovered provenance
label: feature
imported_from: linear
assignee: steve
task_status: backlog
priority: medium
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 120
---
Add a `workflow_step_run_assets(step_run_id, asset_id)` join table to distinguish "Assets selected by a Step" from "Assets discovered by a Step". Deferred from Brief 037 / ADR 024 / DEV-183.

## Context

Internal Selectors (introduced by ADR 024 / Brief 037) reference existing Assets rather than discovering new ones. v1 accepts a "rediscovery" provenance fib: the dispatcher's upsert path overwrites `Asset.discovered_in_workflow_step_run_id` for each selected Asset, so `_build_next_inputs_from_outputs` (which queries by that FK) works unchanged.

The trade-off: an Asset's `discovered_in_workflow_*` pointer reflects the most-recent Step that touched it, not the Step that actually discovered it. Acceptable today because nothing depends on accurate discovery provenance.

Trigger this issue when accurate discovery provenance becomes operationally important — e.g. for audit, finding-to-source attribution, or a UI that distinguishes "discovered here" from "selected here".

## Scope (sketch)

* New table `workflow_step_run_assets(step_run_id, asset_id, PRIMARY KEY (step_run_id, asset_id))`.
* Internal Selectors write to the join table instead of overwriting `discovered_in_workflow_step_run_id`.
* `_build_next_inputs_from_outputs` unions the join table with the discovery FK query.
* `Asset.discovered_in_*` reverts to "the first scanner that discovered me" and stops being overwritten by Selector runs.
* Migration consideration: backfill is probably not worth doing — accept lossy historical provenance for Assets already overwritten by asset-query.
* Update `docs/architectural-standards.md` rediscovery-vs-discovery subsection to reflect the new model.

## Done when

* An asset-query run against existing Assets adds rows to `workflow_step_run_assets` and leaves `Asset.discovered_in_*` unchanged.
* `_build_next_inputs_from_outputs` returns selected Assets to downstream Steps via the join.
* Architectural standards updated.

---

Imported from Linear [DEV-245](https://linear.app/stevevine/issue/DEV-245/workflow-step-run-assets-join-table-for-selected-not-discovered)