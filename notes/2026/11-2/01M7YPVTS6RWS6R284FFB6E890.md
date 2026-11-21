---
id: 01M7YPVTS6RWS6R284FFB6E890
created: 2026-11-21T09:26:41.702095Z
updated: 2026-11-21T10:46:36.398666Z
type: task
title: 'Assessment screen: the box''s four buttons sit in a 2×2 block — Add evidence, Raise gap, Add to SAP, Request exception'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2057
sprint: s9hexqn
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Raised by Steve while testing sprint 120 (2026-11-21). Goes with COM-2056 (the box stops listing evidence). Build it after COM-2056 or in the same PR, since both change the same part of the box.

**Today.** The assessment box on the Assessment screen has four buttons in two places:
- **Add evidence** sits under the box's Evidence heading.
- **Raise gap**, **Request an exception** and **Add to the plan** are in a row further down.

**What people see after this**
- The four buttons sit together in one tidy **2×2 block**, each the same width:

  | | |
  |---|---|
  | Add evidence | Raise gap |
  | Add to SAP | Request exception |

- **Renamed:**
  - "Add to the plan" becomes **Add to SAP**. Its confirmation says "{control} added to the SAP" to match.
  - "Request an exception" becomes **Request exception**. This keeps Compass's sentence-case convention for buttons (Steve confirmed, 2026-11-21).
  - When the control already has an exception that is due for renewal, that slot still shows **Renew exception**, unchanged.
- **Buttons behave as they do now.** A disabled button is still disabled, for example Raise gap before the control is assessed or when it's out of scope. The reason lines ("Raise gap: assess it first." and so on) show under the block. The "Not assessed yet" hint also sits under the block.
- **A button someone isn't allowed to use is left out, as now.** The remaining buttons fill the block in the same order without leaving a gap, so someone with only two shows one row.
- **With COM-2056,** the box no longer lists evidence, so its separate Evidence heading goes. The block takes its place.
- **Other screens aren't changed.** Those that show the box without these actions (an initiative's Assess drawer, a control's evidence view) keep Add evidence where it is now.

**Implementation notes**
- Add evidence is rendered in `components/AssessmentPanel.tsx` (the Evidence `Stack`). The other three are in `components/AssessmentActions.tsx` (a `Group`), shown only when the panel's `actions` prop is set (COM-1638, Assessment screen only). When `actions` is set, render all four in one two-column grid with equal-width buttons, with the Add evidence button and its window wired as now.
- Check the screen-conventions test (`screen-conventions.test.ts`) still passes. Update any tests, and the Browser smoke journeys, that find buttons by the old names "Add to the plan" and "Request an exception".
- Frontend only. Independent: no migration or API change.

**Done when**
- On the Assessment screen, as someone with every permission, the four buttons sit in a 2×2 block reading Add evidence, Raise gap / Add to SAP, Request exception, and each still opens what it opened before.
- A control with an exception due for renewal shows Renew exception in that slot.
- With fewer permissions, the block shows only the allowed buttons, without gaps.
- The disabled-reason lines still appear under the block.