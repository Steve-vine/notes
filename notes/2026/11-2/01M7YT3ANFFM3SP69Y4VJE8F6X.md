---
id: 01M7YT3ANFFM3SP69Y4VJE8F6X
created: 2026-11-21T10:23:13.071481Z
updated: 2026-11-21T13:33:37.308102Z
type: task
title: 'Assessment screen: the assessment box never moves when the main content scrolls (today it slides up a little before it sticks)'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2063
sprint: s9hexqn
comments:
- id: 01M7YYWT391G97B0E86TJS0V8V
  author: Steve Vine
  at: 2026-11-21T11:47:02.377302Z
  text: |-
    Done and merged to main (PR #2053). This changes the screen only.

    What changes:
    - On a wide screen, the assessment box stays exactly where it is while the Overview or History scrolls, from the first pixel, like the list on the left. Only the middle column scrolls.
    - A box taller than the window still scrolls inside itself, with Save always in reach.
    - Narrow screens are unchanged.

    Checked in headless Chromium, measuring the box's top edge while scrolling to the bottom. Before, it slid 24px up and then stuck. Now it doesn't move at all, at 1440×900 and 1280×720. Both tabs still scroll fully to the bottom, and the narrow layout measured the same as before.

    Call for you to overturn: the middle column now has its own scrollbar, in the gap between the text and the box. Where scrollbars always show (Windows, or a Mac with a mouse), the box sits 15px further right than before. The text column is unchanged.
- id: 01M7Z4ZZ4WRY2HNRSBSYGPVAWW
  author: Steve Vine
  at: 2026-11-21T13:33:37.307828Z
  text: |-
    Pre-UAT (staging 12bd442a5, E2E Test Company): Passed.
    Steps: Opened INS.10 at 1440×900 and scrolled the Overview and History tabs to the bottom, in small steps (1, 5, 10, 24, 50px) and with the mouse wheel. Repeated at 1280×720.
    Seen:
    - The box's top edge stayed at exactly 146px at every step, on both tabs and both sizes. Both tabs reach the bottom.
    - At 720 tall the box scrolls inside itself, and Save stays visible.
    Screenshots: ~/compass-uat/s9hexqn/COM-2063/
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Raised by Steve while testing sprint 120 (2026-11-21).

**What Steve saw.** On the Assessment screen, the assessment box on the right is meant to stay put while the control's Overview and History scroll. It does stay put eventually, but it first moves up a little as you start scrolling, until it reaches the top, and only then holds. The list of controls on the left never moves at all.

**Why** (checked in the code). The box sits *inside* the area that scrolls and is held by "stick when you reach the top". That area has a margin of about 24 px above the box, so the box travels those 24 px before it sticks. The left-hand list sits outside the scrolling area, which is why it never moves.

**What people see after this**
- On a wide screen, the assessment box never moves when the main content scrolls, exactly like the list on the left. Only the middle column scrolls.
- If the box itself is taller than the window, it scrolls on its own, inside its own column, as it does today when content overflows its maximum height. It never moves with the middle column.
- On a narrow screen nothing changes: the box stacks with the content and scrolls with the page, as now.
- The gaps around the box and the middle column look the same as now.

**Implementation notes**
- `pages/AssessmentsQueuePage.tsx`, the focus panel:
  - the scrollport is the `data-panel="body"` box (`overflowY: auto`);
  - inside it, a flex row with `padding: 24px …` holds the main column and the `aside` (`position: sticky; top: 0`).
- The 24 px top padding is the travel. Don't paper over it with `top: -24px`. On a wide screen, move the `aside` out of the scrollport:
  - two columns side by side in the frame;
  - only the main column has `overflowY: auto`;
  - the aside keeps its own `maxHeight` and inner scroll.

  Keep the COM-623 note in mind: a plain box as the scrollport, not a flex column. The narrow layout (`column-reverse`, static aside) stays as it is.
- Check the History tab and the Overview's longest controls scroll fully to the bottom, and that keyboard focus and scrolling into view still work in both columns.
- Frontend only. Independent: no migration or API change.

**Done when**
- On a wide screen, scrolling the Overview or History from top to bottom leaves the assessment box exactly where it started, from the first pixel.
- A long assessment box still scrolls within itself.
- The narrow layout behaves as before.