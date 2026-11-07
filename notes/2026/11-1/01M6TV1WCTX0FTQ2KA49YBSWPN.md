---
id: 01M6TV1WCTX0FTQ2KA49YBSWPN
created: 2026-11-07T11:07:14.714398Z
updated: 2026-11-07T11:07:16.655672Z
type: task
title: 'Assessment: Raise gap moves into the assessment box, below the file upload'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1638
sprint: sp69tt3
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
On the Assessment screen, **Raise gap** sits on the Gaps section in the main column. Steve (2026-11-07): move it into the right-hand assessment box, below the file upload, so every action is in the box and the main screen is information only.

**Wanted behaviour:**
- The assessment box shows **Raise gap** directly below the evidence file upload, styled like the box's other controls.
- It opens the same Raise gap window as today, for this control, and the new gap appears in the Gaps section straight away.
- It follows today's rules: shown to people who can raise gaps, available only on an assessed, in-scope control. Where it can't be used, it's disabled with the reason, rather than hidden, so assessors know where to find it.
- The Gaps section on the Assessment screen loses its Raise gap button and just lists the gaps.
- The Playbook control page's Gaps tab is not changed and keeps its Raise gap.
- Raising a gap doesn't touch unsaved changes on the card.

**Done when:** in E2E Test Company, on an assessed control the box shows Raise gap below the upload; raising one adds it to the Gaps section; the Gaps section has no button; an unassessed control shows it disabled with the reason; the Playbook control page still has Raise gap on its Gaps tab.

**Implementation:** the button and modal are in `ControlGapsCard.tsx` (~lines 130–160), shown via the `Section` `action`. Add a prop (e.g. `canRaise={false}` / no action) for the assessment view, and render the button + `RaiseGapModal` in `AssessmentPanel` under `EvidenceFiles`/`PendingEvidenceFile`, using the shared raisable rule from COM-1588. The footer comment says Raise gap was moved out of the card by COM-621; update that comment. Touches the same files as the Evidence section and History tab tasks: merge one at a time.

**Independent:** no migration, no API change.