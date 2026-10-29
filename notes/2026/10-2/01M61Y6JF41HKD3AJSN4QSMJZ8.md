---
id: 01M61Y6JF41HKD3AJSN4QSMJZ8
created: 2026-10-28T19:01:13.316808Z
updated: 2026-10-29T08:13:36.569455Z
type: task
title: The control shows "Excepted until" beside its real status while an approved acceptance stands — and it goes, with a line in History and an Action, the day the acceptance stops
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1400
sprint: s81z16q
blocked_by:
- 01M61Y62XPN7S8R9VHANYWRPDS
comments:
- id: 01M62GRBQM47VVJZR1Q3YR60F7
  author: Steve Vine
  at: 2026-10-29T00:25:30.612363Z
  text: |-
    Done — PR #1418 merged.

    What's in it:
    - An excepted control reads e.g. "Partial · Excepted until 3 Mar 2027" on the control page, the Assessments panel, the Assessments queue and the Gaps register. On the control page and the panel, hovering the pill says who accepted it, who approved it, why, and links to the risk. On rows that are themselves links (queue, Gaps) it is the plain pill only.
    - The panel's Status buttons are unchanged. Under them: "Excepted until 3 Mar 2027 by R-14 — the status stays what it really is".
    - "Exception awaiting approval" (outlined, grey) while one waits; it still counts as not met.
    - The Assessments queue has an "Excepted" switch.
    - History (control page and panel) shows "Excepted until 3 Mar 2027 — R-14 approved by Jo Bloggs" and "Exception R-14 ended — ran out on 3 Mar 2027" / "…the acceptance was closed" / "…no longer an exception to ACC.8". Nothing is stored on the assessment; it's read from the risk.
    - Actions: "Exception to ACC.8 (R-14) runs out on 3 March" replaces "Acceptance of R-14…" when the risk is an exception. Once it lapses, "ACC.8 is no longer excepted — fix it or renew the exception" goes to the control's owner, or the risk owner if the control has none. It clears when renewed, met or taken out of scope, or after 30 days.
    - The risk's Exception to card notes "No longer needed — ACC.8 is met" / "ACC.8 is now out of scope — this exception isn't needed".

    My calls / deviations:
    - SAP's linked-controls card doesn't show the marker: it reads a status the SAP API gives it, not the assessment. The incident review card shows no control status, so nothing changed there.
    - The "no longer excepted" reminder stops after 30 days rather than staying for ever.
    - A closed risk never excepts a control, even if its accept plan is still open.
    - The ends that follow from a state rather than an event (over appetite, met, out of scope) remove the marker at once but leave no dated History line.
assignee: steve
label:
- feature
priority: high
task_status: done
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