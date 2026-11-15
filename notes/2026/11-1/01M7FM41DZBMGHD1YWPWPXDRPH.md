---
id: 01M7FM41DZBMGHD1YWPWPXDRPH
created: 2026-11-15T12:50:08.447798Z
updated: 2026-11-15T16:40:28.648068Z
type: task
title: Every piece of evidence on a control shows Compliant, Non-compliant or Unchecked — a person sets an Unchecked one, overrides a judged one with a reason, and the choice stays with that piece of evidence only
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1850
sprint: s7nqsy0
blocked_by:
- 01M7FM37RNKW81E5SQ1QDQA2MN
comments:
- id: 01M7G19NZH97B5SB1JYE4DVNBZ
  author: Steve Vine
  at: 2026-11-15T16:40:24.817738Z
  text: |-
    Done — PR #1847 merged (1315cb0e, migration 0858). Every capture a collected check takes, and every file, link and vendor certificate in the Evidence register, shows Compliant (green), Non-compliant (red) or Unchecked (grey), with who set it beside the pill: "Rule (being replaced by a workflow)", "Workflow: … (vN)", "<person>, overridden: <reason>", or "Not checked". Under an override the rule's or workflow's own verdict stays visible.

    Where it shows: the control's Evidence tab (a Compliance column, and each collected check's latest capture), each capture in a check's history and a Captures panel on a judged check's page, the register (sortable Compliance column + filter), the evidence page header, and audit packs (status and who set it, as at when the pack is made).

    Setting it: click the pill → history and Set status. Anyone with Manage evidence or Record assessments. An Unchecked piece takes an optional note; overriding a rule's/workflow's verdict needs a reason (refused without). Only that piece changes; the next capture starts afresh. Archived evidence keeps its status read-only; a capture held for review isn't evidence yet, so it can't be set. Once a person has made the call, a later automated verdict never undoes it.

    Before workflows: an approved rule's verdict marks the captures it judges, and the migration backfilled the latest capture of each live check with an approved rule from its last result.

    History and Activity carry every change in words. Polaris has two new tools: read a piece's status and history, and set it only when the person asks, with their reason. It names pieces as the register does, or by CHK ID and day.

    Calls: library documents and Compass's built-in checks carry no status ("—"); the column is called Compliance because the register already has Status (Current / Due soon / Out of date). Browser smoke has a new journey (INS.10's Evidence tab: pills, set Compliant, history) — first run on staging.
assignee: steve
label:
- feature
priority: high
task_status: review
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