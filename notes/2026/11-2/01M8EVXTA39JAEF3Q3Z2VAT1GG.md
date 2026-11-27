---
id: 01M8EVXTA39JAEF3Q3Z2VAT1GG
created: 2026-11-27T16:03:00.54741Z
updated: 2026-11-27T16:04:34.584021Z
type: task
title: Workflow triggers before and after a joiner, a mover and a leaver, per person, each publishing the values it provides; plus Outcome and Business role conditions
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2197
sprint: snt3b17
blocked_by:
- 01M8EVTSMYCWN977F49XWV61RH
assignee: steve
label:
- feature
priority: high
task_status: todo
---
**On the chain** (workflow definitions and run records widen beyond evidence; API change). ADR 0185. Can be built alongside COM-2194–2196; COM-2198 needs both.

## What people see
- **New triggers** in the workflow editor, under a new group **Access Control**:
  - **Before a joiner** / **After a joiner**
  - **Before a mover** / **After a mover**
  - **Before a leaver** / **After a leaver**
  Each runs **once per person** on a request: a request for five joiners runs five times.
  - **Before** fires when Compass is about to make that person's changes: an approved request starting, at its scheduled time if it has one, or straight away if expedited. Compass waits for that person's before-workflows to finish before changing anything (COM-2198 covers a failure).
  - **After** fires when that person's changes are finished, including any AD to-do done by hand or the wait for the account to reach Entra.
- **Each trigger publishes the values it provides**, listed on the trigger in the editor, each with a description and an example, so a script's inputs can be picked from them:
  - **Every access trigger**: request reference (ACR-123), company, requested by, approved by, scheduled date, the person's display name, sign-in name, email address, logon name (AD), employee ID, primary business role, other business roles, manager (name and sign-in name), and each **joiner/account field** the company has set up, by its label ("Department", "Cost centre", "Extension attribute 7 – Payroll number").
  - **Mover**: the same, **before and after the move** ("Department before", "Department after"), and the roles gained and lost.
  - **Leaver**: leave date, and what happens to the account (disabled / deleted on a date).
  - **After-triggers also**: **Outcome** (Succeeded / Failed), the reason it failed, the account's identifiers once made (Entra object ID, AD object GUID), and what was granted or removed (groups, mailboxes, lists).
  - Values that aren't known at that point (no account ID before a joiner) aren't offered on that trigger.
- **New conditions**:
  - **Outcome is** Succeeded / Failed (after-triggers only; a refused or failed person is *Failed*).
  - **Business role is / is not** (the primary role or any role).
  - **Company is / is not**.
- **Workflow runs** for these triggers show the person and request in place of a piece of evidence, link to the request, and appear in the workflow's run history as today.
- **Testing a workflow** (the existing Test) can pick a past request's person and shows which values the trigger would publish and which branch it would take. It never runs a script.
- Evidence workflows are unchanged.

## Notes (technical)
- `WorkflowRun.evidence_kind/evidence_id` are required today. Widen the run's subject (e.g. `subject_kind` + `subject_id`, evidence or access request subject); migration keeps existing rows.
- Register the triggers in `core/workflows/triggers.py`. Event emission: **after** = from `request_completion.settle()` per subject (today it calls only `secrets.leavers.owner_left`), queued via `core/workflows/events.py` after commit. **Before** = from the start of per-subject execution in `tasks/access_execute.py`; the hold itself is COM-2198.
- A trigger's published values are declared once (name, label, type, description, example), served to the editor, and used by COM-2198 to map script inputs and to type-check them.
- Joiner fields come from `core/joiner_fields.py` per company. Sensitive values (the temporary password) are **not** published.
- Engine: values reach steps through the run `Context`. Today it carries only the evidence (`registry.py`); add a value map (trigger values plus step outputs, COM-2198).
- The loop guard and depth still apply.

**Done when:** on staging, in E2E Test Company, a workflow on *After a joiner* with *Outcome is Succeeded* and *Business role is Sales* runs once for each Sales joiner on a two-person request and not for the other. Its run shows the person, the request and the published values. A *Before a leaver* workflow runs before the leaver's account is disabled, and Test on a past joiner shows the values without running anything.