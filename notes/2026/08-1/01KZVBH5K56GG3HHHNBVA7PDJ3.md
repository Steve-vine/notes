---
id: 01KZVBH5K56GG3HHHNBVA7PDJ3
created: 2026-08-12T16:05:20.101833Z
updated: 2026-08-12T16:06:06.624115Z
type: task
title: 'Workflow delete: investigate whether to preserve or cascade runs/assets/findings'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 125
sprint: s1hm0kb
assignee: steve
imported_from: linear
label:
- follow_up
priority: medium
task_status: backlog
---
## Problem

Today, deleting a Workflow CASCADEs through `workflow_runs` → `workflow_step_runs` → assets/findings discovered by those runs (`asset.discovered_in_workflow_run_id` is the CASCADE link). The frontend `DestructiveConfirm` copy in `features/workflows/workflow-detail.tsx` claims "Past runs and their findings remain in the database", which contradicts the actual database behaviour. So both the behaviour and the messaging need a decision.

## The user-facing question

There are legitimate reasons for either outcome at delete time:

* **Cascade everything.** User created a workflow by mistake, ran it once on the wrong scope, wants the noise gone. Or a workflow ran on a now-decommissioned target and its results are no longer relevant.
* **Preserve runs / assets / findings.** The workflow was a one-shot historical scan and the user wants the workflow definition gone but the discovered assets and open findings to stay actionable. Or compliance/audit retention requires the discovery record to outlive the workflow that produced it.

A single hard-coded behaviour can't serve both. The proposed direction is a user choice at delete time.

## Investigation scope

1. Decide the deletion shape. Likely options:
   * Radio in the `DestructiveConfirm` dialog: "Delete workflow only" vs "Delete workflow and all discovered assets/findings".
   * Or two endpoints / a query parameter: `DELETE /workflows/{id}` (default preserve) vs `DELETE /workflows/{id}?cascade=true`.
2. Decide how "preserve" actually behaves at the schema level. Setting `asset.discovered_in_workflow_run_id` to `NULL` on workflow deletion (rather than CASCADE) is the simplest path and keeps the asset row intact. Same question for `workflow_run`/`workflow_step_run` — preserve them with `workflow_id=NULL`, or block delete if any runs exist?
3. Confirm the parallel `discovered_in_scan_id` lineage (Brief 020) doesn't need the same treatment in scope here — it's behind the deprecated Scans surface.
4. Document the chosen behaviour in `architectural-standards.md` so future cascade decisions follow the pattern.
5. Ship the implementation as a follow-up brief (or small fix, depending on how heavy it gets).

## Acceptance

* Decision recorded in this issue (comment or linked doc) covering: API shape, schema migration (if any), frontend confirm-dialog UX, and the rule for `discovered_in_workflow_run_id` on parent-row deletion.
* Follow-up implementation issue (or brief) created with the agreed scope.
* This issue closes when the design is decided, not when the code lands.

## Source

Surfaced during Brief 022 drafting; flagged through Briefs 023–027 as the active Phase 3 follow-up.

---

Imported from Linear [DEV-196](https://linear.app/stevevine/issue/DEV-196/workflow-delete-investigate-whether-to-preserve-or-cascade)