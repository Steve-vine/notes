---
id: 01M7FM41DZBMGHD1YWPWPXDRPH
created: 2026-11-15T12:50:08.447798Z
updated: 2026-11-16T23:03:22.883279Z
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
- id: 01M7GM12SHFN3E3NMWY0FD69MR
  author: Steve Vine
  at: 2026-11-15T22:07:45.96912Z
  text: |-
    Passed (pre-UAT, 2026-11-15, build f8665615, E2E Test Company), with three points I couldn't check, listed at the end.

    Steps and what I saw (E2E Admin A):
    - The Evidence register has a sortable Compliance column and a Compliance filter. Uploaded files and links show Compliant or Unchecked ("Not checked") with who set it beside the pill. The library document (Approved Standard Changes) shows "—", as designed.
    - INS.10's Evidence tab shows the Compliance column, with who set each status.
    - CHK-2's page shows a pill on each capture in its history. I set the oldest capture (6 Nov, 10:56) from Unchecked to Compliant without a note: the note is optional, and Set status was enabled without one. Its history shows "Unchecked → Compliant, E2E Admin A". The other four captures stayed Unchecked, so only that piece changed.
    - Override needs a reason: I made a small workflow ("E2E UAT 20261115 uploads on ACC.3 are compliant"), enabled it, and added a link on ACC.3. The workflow set the link Compliant ("Workflow: … (v1)"). I disabled the workflow straight after. Opening the pill showed the workflow's verdict, its runs and Set status. Choosing Unchecked left Override greyed out until I typed a reason. After overriding, the pill reads "E2E Admin A, overridden: <reason>", with "Workflow … judged it Compliant" still visible underneath. History shows both changes, and the evidence's audit trail has the workflow's change (by Compass) and my override, with the reason.
    - That status change also started "Gaps from evidence", which correctly did nothing (no gap raised, none to close).
    - As E2E Viewer, the pill opens the history read-only, with no Set status.
    - Polaris (in-app chat) explained the link's status correctly: the workflow set it Compliant, then E2E Admin A overrode it, quoting the reason.

    Couldn't check:
    - Whether a new capture after an override starts fresh. CHK-2 can't collect any more (its Collection integration was deleted), and E2E Test Company has no other collected check.
    - The status in an audit pack. I didn't make a pack.
    - Polaris setting or overriding a status on request. Steve could try: "set <piece> to Non-compliant because …".

    Screenshots: ~/compass-uat/s7nqsy0/COM-1850/
assignee: steve
label:
- feature
priority: high
task_status: done
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