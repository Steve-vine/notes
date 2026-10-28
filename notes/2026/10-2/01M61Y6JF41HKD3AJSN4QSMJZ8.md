---
id: 01M61Y6JF41HKD3AJSN4QSMJZ8
created: 2026-10-28T19:01:13.316808Z
updated: 2026-10-28T19:03:21.890848Z
type: task
title: The control shows "Excepted until" beside its real status while an approved acceptance stands — and it goes, with a line in History and an Action, the day the acceptance stops
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1400
sprint: s81z16q
blocked_by:
- 01M61Y62XPN7S8R9VHANYWRPDS
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 94, Control Exceptions (ADR 0130, COM-1398). Builds on COM-1399 (Exception to).

## What people see

- **Wherever a control's status shows** — the Assessments queue and panel, the control's page, Gaps, SAP controls, the incident review card — an excepted control reads **Partial · Excepted until 3 Mar 2027** (or Not implemented · …). The marker is a pill; hovering or tapping it says who accepted it, who approved it, the reason, and links to the risk.
- **The assessment panel:** the Status buttons are unchanged — the marker can't be set there. Under them, a line: "Excepted until 3 Mar 2027 by R-14 — the status stays what it really is".
- **Assessments queue** gains a filter **Excepted**.
- **Awaiting approval:** a control whose exception is waiting shows a quieter **Exception awaiting approval** pill; it counts as not met until approved.
- **When it stops** (runs out, closed, declined, residual over appetite, link removed, control taken out of scope):
  - the marker goes at once;
  - the control's **History** says "Exception R-14 ended — ran out on 3 Mar 2027" (or why);
  - **Actions:** the existing "Acceptance of R-14 runs out on 3 March" names the control when it's an exception — "Exception to ACC.8 (R-14) runs out on 3 March" — to owner and approver 30 days ahead; on the day it lapses, the control's owner gets "ACC.8 is no longer excepted — fix it or renew the exception".
- **History** also shows when an exception started ("Excepted until 3 Mar 2027 — R-14 approved by Jo Bloggs").
- **Taken out of scope** while excepted: the exception's risk shows "ACC.8 is now out of scope — this exception isn't needed".

## Who can do what

Nobody sets the marker. It follows the acceptance, whose rules (approver, nobody approves their own) are unchanged.

## Notes (technical)

- One function decides "excepted on day D" from `core/risk_acceptance.standing_acceptance` + the exception link + the control's current assessment (in scope, not implemented). Everything reads it — API, posture (next task), reports.
- Assessment responses gain `exception: {risk_ref, until, approved_by, state: standing|awaiting}`; FE twins `assessments/upsert.ts` `assessmentState` and `current.ts` `isShortfall` stay as they are (excepted is still a shortfall) and the pill is added beside them.
- History lines are derived on read from the risk's revisions and `treatment_plans` audit rows (as `core/assessment_history.py` derives evidence changes) — nothing stored on the assessment.
- Actions: extend `_acceptance_expiries` wording; new source for "no longer excepted", raised by the hourly acceptance-expiry job's outcome, ADR 0055 shape.

**Chain:** on the chain (API).

**Done when:** on staging, approving an acceptance on a risk that's an exception to ACC.8 shows the marker; setting its expiry to yesterday and letting the hourly job run removes it, with the History line and the Action.