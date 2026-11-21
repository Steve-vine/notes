---
id: 01M7Z50SVW1F4Y3DFGKHNXKPFV
created: 2026-11-21T13:34:04.668042Z
updated: 2026-11-21T14:40:39.765368Z
type: task
title: 'Assessment box at phone width: "Request exception" (and "Renew exception") labels are cut off'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2071
sprint: s9hexqn
comments:
- id: 01M7Z6H866JM4SF6GPXHEH8SF4
  author: Steve Vine
  at: 2026-11-21T14:00:32.198346Z
  text: |-
    Done. Merged to main as PR #2064; it isn't on staging yet and goes out with the next deploy.

    What changes for people
    - On a phone (375 and 390 wide), "Request exception" in the assessment box is no longer cut off. A label too long for its half of the box wraps onto a second line, and the button beside it grows to the same height.
    - "Renew exception" fits on one line at both widths.
    - On a desktop nothing changes: four equal buttons in a 2×2.

    Call Steve might overturn: the long label wraps, rather than the buttons stacking into one column on phones. That keeps the box compact, but "Request exception" reads as two lines in a taller second row.
    Checked: measured in headless Chromium at 1440, 1280, 390 and 375 wide. Before, the label was clipped (106px of text in 85–92px). After, it wraps with nothing clipped. The desktop layout is unchanged.
- id: 01M7Z8TQAN9RA8K3422R2E2X4H
  author: Steve Vine
  at: 2026-11-21T14:40:39.765156Z
  text: |-
    Pre-UAT recheck (staging 095141ab4, E2E Test Company): Passed.
    Steps: As Admin A, opened the Assessment screen ▸ RIM.9 at 1440, 390×844 and 375×812, and measured each button in the box. There are no exceptions in the test company, so to try "Renew exception" I put those words into the button for a moment and measured.
    Seen:
    - 1440: 2×2 with four equal 162px buttons, as before.
    - 390 and 375: every label reads in full. "Request exception" wraps onto two lines, its row grows to 40px with Add to SAP matching it, and the page has no sideways scroll.
    - At 375 "Renew exception" also wraps to two lines (the Done comment said one), but nothing is clipped.
    Screenshots: ~/compass-uat/s9hexqn/COM-2071/r6-*.png
assignee: steve
label:
- bug
priority: medium
task_status: review
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