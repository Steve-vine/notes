---
id: 01M6M8D96N2CHZVM1SKR864VMJ
created: 2026-11-04T21:45:58.741277Z
updated: 2026-11-04T21:46:02.357807Z
type: task
title: A gap can be raised against any assessed control, Implemented included
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1588
sprint: srkxswe
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Today a gap can only be raised against a control assessed **Not implemented** or **Partial**. So a control that's Implemented but at low maturity can't have an improvement item. Steve found this testing Initiatives.

The rule dates from COM-621, when a gap meant "falls short of implemented". It's enforced only on screen. Compass's own checks and audit findings already raise gaps against Implemented controls, and the server accepts them.

**Steve (2026-11-04): allow a gap against any assessed, in-scope control, Implemented included.** A gap is now "something to improve", whether that's implementation or maturity. No maturity threshold.

**Wanted behaviour:**
- A control that's been assessed and is in scope can have a gap raised against it, whatever its status, from:
  - the control's Gaps box
  - the Gaps register's **Raise a gap** window
  - an initiative's Controls tab
- Unassessed controls and out-of-scope (Not applicable) controls still can't have a gap.
- Wording that says "falling short" changes to fit. For example, the Raise a gap control picker's placeholder "A control assessed as falling short" and its empty message "No control is assessed as falling short."

**Done when:** in E2E Test Company, a control assessed Implemented at maturity 1 offers Raise a gap on its control page, in the Gaps register's picker and on an initiative's Controls tab. A gap raised there appears on the control and in the register. An unassessed or Not applicable control still offers no Raise a gap.

**Implementation:** the rule lives in three places on staging:
- `isShortfall` in `assessments/current.ts:42` (the Gaps box): `['not_implemented','partial']`
- `gaps/RaiseGapModal.tsx:~109` (the picker's choices and copy)
- `gapRaisable` in `initiatives/ControlsTab.tsx:210`

Replace them with one shared predicate (assessed, in scope, not `not_applicable`), probably renamed from `isShortfall`. Check whether anything else uses `isShortfall` to mean an actual shortfall (e.g. the Assessments queue or compliance shortfalls) and leave those alone. Check that Polaris's `posture_raise_gap` tool doesn't carry its own copy of the rule (`assistant/tools/`). Also check the MCP instructions/text for "short of implemented". Update the screen tests that pin the old rule.

**Independent:** no API change, the server already allows it.

Found by Steve while testing Initiatives (2026-11-04).