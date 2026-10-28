---
id: 01M61Y5M5CGZWG728MHQRVYV9R
created: 2026-10-28T19:00:42.284894Z
updated: 2026-10-28T23:14:38.033407Z
type: task
title: 'ADR: an exception is an approved risk acceptance against a control — the control shows "Excepted until", Compliance counts it apart from met, and nothing new needs approving'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1398
sprint: s81z16q
comments:
- id: 01M62CPFH6NGQ7KAK54NZW4T1Z
  author: Steve Vine
  at: 2026-10-28T23:14:34.662082Z
  text: 'Done — ADR 0130 merged in PR #1416 (decisions/0130-control-exceptions.md). It records the decision as planned: an exception is an approved, in-date risk acceptance that names the control(s) it''s an exception to; the control shows "Excepted until" beside its real status; Compliance counts excepted apart from met with the headline unchanged; no new register and no new approval. It amends ADR 0011, 0012 and 0056. My three calls are listed under "Calls made in planning, not yet confirmed by Steve": multi-control acceptances, no automatic conversion (a candidates list instead), and "Excepted" as the requirement state.'
assignee: steve
label:
- brief
priority: high
task_status: review
---
Sprint 94, Control Exceptions. ADR 0130. Builds on ADR 0123 §9 (acceptance needs an approver and runs out) and ADR 0011 (control assessment).

Steve, 2026-10-28:
- the original feature list had an exceptions/waivers register: "Controls that a company deliberately doesn't meet, with justification, compensating controls, owner, expiry and mandatory review";
- no fourth status — the control keeps its real status and carries an "Excepted" marker;
- Compliance shows excepted controls **separately, not counted as met**.

## What the ADR decides

- **No new register and no new approval.** An exception is a risk whose **accept** treatment is approved and in date, and which names the control(s) it is an **exception to**. The pieces already exist:

  | Waiver register | Compass |
  |---|---|
  | Justification | The accept treatment's rationale |
  | Compensating controls | The controls that reduce the risk (existing link) |
  | Owner | The risk owner |
  | Approver | The acceptance's approver (*Approve risk assessments and accept risks*; nobody approves their own) |
  | Expiry | The acceptance's expiry (12 months by default, Settings) |
  | Mandatory review | The risk's review date, plus "runs out" reminders in Actions |

- **A risk gains "Exception to"** — the control(s) it is a shortfall against — kept apart from "Controls that reduce it". A control can't be both on the same risk.
- **The marker is earned, never set.** A control shows **Excepted until 3 Mar 2027** beside its real status (e.g. **Partial · Excepted until 3 Mar 2027**) only while a linked acceptance is approved and in date. It goes the moment the acceptance runs out, is closed, is declined, or the risk rises over appetite. The status underneath never changes, so there's nothing to put back.
- **Which controls can carry it:** in-scope controls that are Not implemented or Partial (or not yet assessed). An out-of-scope control can't be excepted — out of scope means it doesn't apply; excepted means it applies and isn't met. An Implemented control linked as an exception shows no marker, and the risk says "No longer needed — ACC.8 is met".
- **Compliance counts four ways:** met, excepted, not met, out of scope. The headline % stays met over in scope, so it doesn't move; **"4% excepted"** sits beside it. A framework requirement whose only shortfalls are excepted controls reads **Excepted**, not Met.
- **History:** the control's History says when an exception started and ended and why, read from the risk's own record — nothing new is stored on the assessment.
- **Unchanged:** DDQ citations (an excepted control is still not met), risk assessments' frozen control states, the Trust Centre (shows no compliance figures).

## My calls (for Steve to overturn)

- An acceptance can name more than one control (one legacy system can break several controls).
- No automatic conversion: risks already Accepted and linked to a control do **not** become exceptions until someone adds "Exception to". A one-off list of candidates appears in Posture ▸ Exceptions (COM-1405).
- Requirement state "Excepted" rather than "Met with exceptions" — shorter, and plainly not met.

## The sprint

COM-1399 Exception to (foundation) → COM-1400 the marker → COM-1402 request from the control → COM-1403 Compliance → COM-1404 SoA / reports / audit pack → COM-1405 Exceptions list → COM-1406 Polaris.

**Chain:** independent (documents only).

**Done when:** ADR 0130 is merged.