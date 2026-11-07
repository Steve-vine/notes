---
id: 01M6TV1WCTX0FTQ2KA49YBSWPN
created: 2026-11-07T11:07:14.714398Z
updated: 2026-11-07T11:11:14.159292Z
type: task
title: 'Assessment: Raise gap, Request an exception and Add to the plan move into the assessment box'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1638
sprint: sp69tt3
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
On the Assessment screen, actions sit in the main column: **Raise gap** on the Gaps section, **Request an exception** (or **Renew**) on the Risks section, and **Add to the plan** in the Evidence of operation box. Steve (2026-11-07): move them into the right-hand assessment box, below the file upload, so every action is in the box and the main screen is information only. (Request an exception added by Steve the same day. Add to the plan follows the same rule, and COM-1635 removes the box it sits in.)

**Wanted behaviour:**
- Below the evidence file upload, the assessment box shows **Raise gap**, **Request an exception** (or **Renew** when the exception ends within 30 days), and **Add to the plan**, styled like the box's other controls.
- Each opens the same window as today for this control: the Raise gap window, the exception request, and the new schedule (SAP) entry already linked to the control. What it creates appears in the main screen straight away (Gaps, Risks, Evidence).
- Today's rules still apply:
  - Raise gap: for people who can raise gaps, on an assessed, in-scope control.
  - Request an exception: for people who manage risks, on an in-scope control that isn't Implemented and has no exception yet. Renew replaces it when the exception ends within 30 days.
  - Add to the plan: for people who can plan.
  - A button the user is allowed to use but which doesn't apply to this control is disabled, with the reason, rather than hidden, so assessors know where to find it. A button the user isn't allowed to use isn't shown.
- On the Assessment screen, the Gaps and Risks sections lose their buttons and only list.
- The Playbook control page is not changed: its Gaps and Risks tabs keep their buttons.
- Using any of these doesn't touch unsaved changes on the card.
- Still on the main screen: "Run now" beside each check. It acts on one check row, so it stays (agreed with Steve 2026-11-07).

**Done when:** in E2E Test Company, on a Partial control the box shows Raise gap, Request an exception and Add to the plan below the upload; each one works and its result appears on the main screen; the Gaps and Risks sections have no buttons; an unassessed control shows Raise gap disabled with the reason; the Playbook control page still has its buttons.

**Implementation:**
- Raise gap's button and modal are in `ControlGapsCard.tsx` (~lines 130–160), passed through `Section`'s `action`.
- Request an exception and Renew are in `ControlRisksCard.tsx` (the `action` + `ExceptionDialog`).
- Add to the plan is in `EvidenceOfOperationCard.tsx` (`SapEntryModal` with `linkControlIds`).
- Give the two cards a way to drop their action in the section frame. Render all three in `AssessmentPanel` under `EvidenceFiles`/`PendingEvidenceFile`, reusing the raisable rule from COM-1588 and the exception rule from ControlRisksCard; export that rule rather than copying it.
- The footer comment says COM-621 moved Raise gap out of the card. Update it.
- This touches the same files as COM-1635 and COM-1636. Merge one at a time.

**Independent:** no migration, no API change.