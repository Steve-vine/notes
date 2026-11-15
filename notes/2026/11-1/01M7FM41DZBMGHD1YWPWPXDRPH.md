---
id: 01M7FM41DZBMGHD1YWPWPXDRPH
created: 2026-11-15T12:50:08.447798Z
updated: 2026-11-15T15:22:50.753337Z
type: task
title: Every piece of evidence on a control shows Compliant, Non-compliant or Unchecked — a person sets an Unchecked one, overrides a judged one with a reason, and the choice stays with that piece of evidence only
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1850
sprint: s7nqsy0
blocked_by:
- 01M7FM37RNKW81E5SQ1QDQA2MN
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint "Automation - Workflows" (ADR in COM-1848). Comes before the workflow tasks, which set this status.

## What people see

- **Every piece of evidence linked to a control** carries a status pill: **Compliant** (green), **Non-compliant** (red) or **Unchecked** (grey). That means each capture Evidence Collection gathers, and each file or record uploaded to Assurance ▸ Evidence.
- **Where it shows**: the control's Evidence tab (each piece, newest first), a collected check's page (each capture), the Evidence register (a column and a filter), and an audit pack (each piece's status and who or what set it).
- **Who set it** sits beside the pill: "Workflow: Approved standard changes (v3)", "Steve Vine, overridden: change approved by CAB email, see note", or "Not checked".
- **Unchecked**: anyone who can edit the control's evidence can set it to Compliant or Non-compliant. A note is optional.
- **Judged by a workflow**: they can override it to the other status (or back to Unchecked) and **must give a reason**. The pill shows it was overridden, and the workflow's own verdict stays visible underneath.
- **Per piece, not per check**: an override on Monday's capture doesn't touch Tuesday's. Tuesday's starts Unchecked, or is judged afresh by a workflow.
- **History**: every change (who or what, when, from → to, reason) shows on the evidence and in the activity log.
- **Before workflows exist** (this task lands first): everything starts Unchecked and people set it by hand. Existing collected checks with an approved rule show their latest capture as Compliant or Non-compliant, from the rule's verdict, marked "Rule (being replaced by a workflow)" until the switch-over task.
- Polaris (chat and MCP) can read a piece of evidence's status and history. It may set or override one only if the person asks, with the reason they give.

## Notes for the builder

- One status model for both kinds of evidence (collected captures and Evidence register items), so workflows and screens treat them alike.
- Status changes must be recorded as events the workflow engine can trigger on (*evidence status changed*, COM workflows foundation).
- Archived evidence (COM-1738) keeps its status, read-only.

## Done when

- Both kinds of evidence show the pill in every place listed, with who set it.
- Setting an Unchecked piece, and overriding a judged one (reason required), works on screen and through Polaris, and is in the history and activity log.
- A new capture after an override starts fresh.
- Tests cover setting, override-needs-reason, per-piece independence and history. Browser smoke opens a control's Evidence tab and sees the pills.

**On the chain** (migration + API).