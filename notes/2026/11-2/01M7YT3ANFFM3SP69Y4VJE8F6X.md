---
id: 01M7YT3ANFFM3SP69Y4VJE8F6X
created: 2026-11-21T10:23:13.071481Z
updated: 2026-11-21T10:23:15.867822Z
type: task
title: 'Assessment screen: the assessment box never moves when the main content scrolls (today it slides up a little before it sticks)'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2063
sprint: s9hexqn
assignee: steve
label:
- bug
priority: medium
task_status: todo
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