---
id: 01M7FM71XGNFF9CKSV0Z9RG6DJ
created: 2026-11-15T12:51:47.248626Z
updated: 2026-11-15T12:51:52.973881Z
type: task
title: Switch-over — every approved pass/fail rule becomes an enabled workflow that judges exactly as before, each company gets a "Gaps from evidence" workflow, and the rule screens retire, so no gap opens or closes because of the change
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1856
sprint: s7nqsy0
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint "Automation - Workflows" (ADR in COM-1848 §9). Comes last on the chain: needs COM-1850, COM-1851, COM-1854 and COM-1855.

## What people see

- **Each approved rule is now a workflow**, named after its check ("CHK-7 · Branch rules require review"), enabled, owned by whoever approved the rule. It has the same trigger (that check's evidence collected), the same test (every / none / at most, the same fields and values, the same *when nothing is found*) and the same verdict, now as the capture's status. Its first version says "Converted from the rule approved by <person> on <date>".
- **Proposed rules still waiting on Review** become **disabled** workflows, so nothing waits on a queue that's gone. A person enables them after testing.
- **Each company gets "Gaps from evidence"**, enabled: *Evidence status changed → Non-compliant → raise a gap on the control; otherwise → close the gap this workflow raised*.
- **Existing open gaps raised by rules** carry over to "Gaps from evidence", so they close on the next Compliant capture as before, not by the switch itself. Their history notes the hand-over.
- **The rule screens go**: the Evidence tab's and check page's *Write a rule / Ask Polaris for a rule* become **Build a workflow** (opening the builder on the *Judge a check's evidence* starting point, already pointed at that check). All checks' Passing / Failing / No rule column becomes the latest evidence's status (Compliant / Non-compliant / Unchecked) and links to the workflow that judged it.
- **Before and after are the same**: the statuses and open gaps on each company are identical immediately after the switch.

## Notes for the builder

- A data migration converts rules to workflows. Run it in the Helm pre-upgrade hook (never at start-up). Mind the migrations fresh-DB blind spot: test against a populated database with rules in every state (approved, proposed, switched off, replaced, with and without `when_empty`).
- Retire the rule API and Polaris's rule tools only after the conversion, in the same release. Old rule data stays readable in history.
- Compass's built-in checks are untouched (COM-1848 §10).

## Done when

- On staging (and on a copy of production data before release), a before/after comparison shows the same status and the same open gaps for every company, recorded on this task.
- Proposed rules are disabled workflows. Rule screens show Build a workflow. All checks shows evidence status.
- Migration tests cover each rule state. Browser smoke opens a converted workflow.

**On the chain** (migration + API).