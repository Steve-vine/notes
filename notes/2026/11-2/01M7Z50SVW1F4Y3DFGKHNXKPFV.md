---
id: 01M7Z50SVW1F4Y3DFGKHNXKPFV
created: 2026-11-21T13:34:04.668042Z
updated: 2026-11-21T13:34:08.133022Z
type: task
title: 'Assessment box at phone width: "Request exception" (and "Renew exception") labels are cut off'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2071
sprint: s9hexqn
assignee: steve
label:
- bug
priority: medium
task_status: active
---
Found in Claude's pre-UAT pass (staging 12bd442a5, 2026-11-21), on COM-2057 / COM-2070.

**Steps:** At 390×844, open the Assessment screen ▸ RIM.9 (or any control) and look at the assessment box's 2×2 buttons.
**Expected:** All four labels are whole, as COM-2057's comment says it checked at 375 wide.
**Seen:** The label reads "Request exceptio". There are 108px of text in a 102px button, so the end is clipped. At 375 wide it would be worse, and "Renew exception" will clip the same way.
**Screenshot:** ~/compass-uat/s9hexqn/COM-2070/390-control-open.png

**Done when**
- At 375 and 390 wide, all four labels in the box (Add evidence, Raise gap, Add to SAP, Request exception, and Renew exception when shown) read in full with nothing clipped. Choose whichever fits best: let a label wrap to two lines, use a smaller icon gap, or stack to one column at phone width.
- Desktop width is unchanged (2×2, equal widths).
- A test or a headless-Chromium measurement covers 375 wide, including Renew exception.

Frontend only. Independent.