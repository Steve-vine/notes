---
id: 01M7FM4N91XA3VZEGW959VME00
created: 2026-11-15T12:50:28.769291Z
updated: 2026-11-15T22:07:59.053895Z
type: task
title: Workflows — a company's workflows on Automation ▸ Workflows, each a trigger, conditions and actions, enabled or disabled, versioned, with every run recorded; first triggers are evidence collected and evidence status changed, first actions set a status and raise or close a gap
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1851
sprint: s7nqsy0
blocked_by:
- 01M7FM41DZBMGHD1YWPWPXDRPH
comments:
- id: 01M7G45BG4R72HDMFT9AV8NKM5
  author: Steve Vine
  at: 2026-11-15T17:30:28.740728Z
  text: |-
    Done — PR #1848 merged (fbe53c63, migration 0860). Automation ▸ Workflows is in the menu: the company's workflows with what starts each, enabled or disabled (and any problems), last run and outcome, runs in 30 days and who last changed it; filters on status and trigger. Anyone who can see Posture reads it; changing needs the new Manage workflows right, given to every role that holds Record assessments (the right that approves collected checks), custom roles included.

    A workflow's page: its definition read as plain sentences with any problems; Runs (what started each, what it read, what each condition found, what it did); Versions (who saved each, read any version, what changed between two); Enable / Disable with a confirmation saying what it acts on ("Runs whenever evidence is collected for ACC.4"). A workflow with problems can't be enabled. New ones start disabled.

    Triggers: Evidence collected (a capture filed, or a file / link / certificate added on a control; narrow to controls or checks) and Evidence status changed (narrow to controls and from/to). Actions: set status, raise a gap ("Raised by workflow: <name>", linked to its run), close the gap this workflow raised — raise/close/reopen as a Compass check's gaps do. Opening a piece of evidence lists the runs that judged it; when workflows disagree Non-compliant wins, and it says so. A broken run is recorded as failed with its reason, changes nothing, and puts "Workflow · Repair" on Actions for whoever last enabled it. Loops can't happen (one run per piece per version per event, depth limit 5; tested).

    Definitions are created through the API until the builder (COM-1854). Calls (in an ADR 0155 amendment): captured items are judged one capture at a time (a rule judged all accounts' newest captures together — COM-1856 will convert accordingly); a field missing from every captured item fails the run; workflow names are unique per company; workflows can't be deleted yet. Browser smoke opens Workflows and a workflow's tabs.
- id: 01M7GM1FJDWSCJKWF3JZ49WH0A
  author: Steve Vine
  at: 2026-11-15T22:07:59.053695Z
  text: |-
    Passed (pre-UAT, 2026-11-15, build f8665615, E2E Test Company).

    Steps and what I saw:
    - Automation ▸ Workflows (E2E Admin A) lists each workflow: name, what starts it, Enabled/Disabled (and "1 problem" where there is one), last run with its outcome, runs in 30 days, and who last changed it. There are Status and Starts when filters. Before my pass the company had "CHK-2 · …" (converted) and "Gaps from evidence", both enabled.
    - I built and saved "E2E UAT 20261115 repos are in Inventory". It saved as Version 1, Disabled. I changed it and saved again: Version 2, and the Versions tab shows who saved each version and when, plus "What changed: + Raise a gap on the control …".
    - Enable asks for confirmation and says what it will act on ("Runs whenever evidence is collected by CHK-2 · …"). It also shows the last test, or offers "Test first". After enabling, the page reads "Enabled by E2E Admin A". Disable asks for confirmation ("It stops at once. Nothing it already did is undone") and returned it to Disabled. I left it disabled.
    - A saved workflow with a problem can't be enabled: Enable is greyed out, with the hint "Put its problems right before enabling it". Example: "E2E UAT 20261115 has problems".
    - A real run on the evidence-collected trigger: my ACC.3 workflow ran when I added a link on ACC.3 and set it Compliant. Its Runs tab lists the run (v1, the evidence, "Conditions met", "Set Compliant"). I disabled it afterwards.
    - A real run on the status-changed trigger: "Gaps from evidence" ran on each status change. Its run detail shows what started it ("…'s status changed from Unchecked to Compliant, by a person"), what it read, what each step found, what it did, and the version as it ran. Opening a piece of evidence lists the runs that judged it.
    - Roles behave as ADR 0155 §7 says. E2E Viewer can read the list and the pages and can Test, but has no New workflow, Save, Enable, Disable or block palette. /automation/workflows/new tells them "Making workflows needs Manage workflows", and enabling directly through the API was refused with Insufficient permissions. E2E Assessor has New workflow, the palette, Save and Enable, so it holds Manage workflows.

    Not seen: a failed run reaching Actions, and conflicting verdicts resolving to Non-compliant. Both need a broken or competing workflow running for real, which E2E Test Company can't set up now that CHK-2 no longer collects.

    Workflows I left in E2E Test Company, all disabled: "E2E UAT 20261115 repos are in Inventory", "… has problems", "… uploads on ACC.3 are compliant", and "… Polaris rule" (made by Polaris).

    Screenshots: ~/compass-uat/s7nqsy0/COM-1851/
assignee: steve
label:
- feature
priority: high
task_status: review
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