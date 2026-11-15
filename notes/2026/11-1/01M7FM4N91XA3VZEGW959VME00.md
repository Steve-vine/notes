---
id: 01M7FM4N91XA3VZEGW959VME00
created: 2026-11-15T12:50:28.769291Z
updated: 2026-11-15T12:50:34.946249Z
type: task
title: Workflows — a company's workflows on Automation ▸ Workflows, each a trigger, conditions and actions, enabled or disabled, versioned, with every run recorded; first triggers are evidence collected and evidence status changed, first actions set a status and raise or close a gap
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1851
sprint: s7nqsy0
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint "Automation - Workflows" (ADR in COM-1848). Builds on COM-1850 (evidence status). The graphical builder, test runs, the Compass sources and Polaris are their own tasks. This one is the foundation they share.

## What people see

- **Automation ▸ Workflows** lists the company's workflows: name, what starts it, enabled or disabled, last run and its outcome, runs in the last 30 days, and who last changed it. Filters: enabled/disabled and trigger. People without *Manage workflows* can read but not change.
- **A workflow** has:
  - a **name** and an optional description;
  - one **trigger**: *Evidence collected* (a new capture or an upload), optionally narrowed to particular controls or checks, or *Evidence status changed*, optionally narrowed to controls and from/to statuses;
  - **conditions**, grouped by *all of* / *any of*, about the evidence's control, its check, its status, and the captured items (every / none / at most N items meet …, as rules can today), with room for the Compass sources (COM Compass sources task);
  - **actions** if the conditions are met, and optionally **actions otherwise**: *set this evidence's status* (Compliant / Non-compliant), *raise a gap on the control* (wording from the workflow, marked "Raised by workflow: <name>"), *close the gap this workflow raised*.
- **Enabled / disabled.** A new workflow starts disabled. Enabling asks for confirmation and says what it will act on ("Runs whenever evidence is collected for ACC.13"). Disabling stops it at once. Nothing already done is undone.
- **Versions.** Saving a change makes a new version, with who and when. The page shows the history and what changed between versions. An enabled workflow's change takes effect from the next run.
- **Runs.** Every run is kept: when, which version, what started it (the piece of evidence), what each condition found, and what it did ("Set Non-compliant: 3 of 41 changes not on the approved list"). Opening a piece of evidence shows the runs that judged it, and a gap raised by a workflow links to its run.
- **Several workflows on one piece of evidence**: if two set conflicting statuses, Non-compliant wins, and the evidence shows both runs. That's my call, for Steve to overturn: the cautious answer.
- **A workflow that breaks** (a document it reads is deleted, a field is gone) records a failed run with the reason. It doesn't change the evidence's status, and it goes on Actions to whoever last enabled it.
- **Permission**: a new *Manage workflows* right, on the roles that today can approve collected checks.

## Notes for the builder

- A workflow is **data the engine evaluates**, like rules today (`core/collection/rules.py`): no code per workflow, no service-specific logic (ADR 0147 §9; the COM-1696 test still applies).
- Shape it for growth: a trigger registry, a condition registry and an action registry, so later triggers (schedules, vulnerability due, document review overdue), cross-record decisions and more actions (notify, ticket) are additions, not rewrites. Steps are a small graph (trigger → condition nodes → action nodes) so the builder can draw it directly.
- Runs go on Celery: idempotent, taking IDs, with a TASK_LABELS entry. Guard against loops, since a status change can trigger a workflow that changes a status: one run per piece of evidence per workflow version per event, and a depth limit.
- Reuse the gap raise/close mechanics of Compass checks (ADR 0132 §4–§5), keyed on the workflow, so a workflow only closes its own gaps.

## Done when

- A workflow can be created (through the API until the builder lands), enabled and disabled, and runs on both triggers.
- It sets statuses and raises and closes its own gaps, and every run is kept with its version, inputs and outcome.
- Versions are kept and shown. A failed run is recorded and reaches Actions. Conflicting verdicts resolve to Non-compliant.
- Loops can't happen: there's a test for a status-change workflow that would re-trigger itself.
- Tests for each trigger, condition kind and action, and the runs list. The Workflows page is on the Browser smoke.

**On the chain** (migration + API).