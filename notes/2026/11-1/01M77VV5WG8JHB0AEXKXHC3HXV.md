---
id: 01M77VV5WG8JHB0AEXKXHC3HXV
created: 2026-11-12T12:31:11.248696Z
updated: 2026-11-12T13:11:30.533125Z
type: task
title: 'SAP Timeline: entry names sit in their own column, which can be dragged wider, so names aren''t cut short'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1751
sprint: spsp226
comments:
- id: 01M77Y4ZMFEKA7VXMHK4JZQ88Z
  author: Steve Vine
  at: 2026-11-12T13:11:29.678876Z
  text: |-
    Built: PR #1746 (auto-merge set, frontend only).

    What you'll see on the SAP Timeline (quarter or year):
    - Names sit in their own column headed "Entry", with the reference first ("SAP-12 External penetration test…"); a name that still doesn't fit is cut with "…" and shows in full on hover.
    - Drag the column's right edge to widen or narrow it: a line and small grip in the heading, accent colour and resize cursor on hover/focus/drag. From the keyboard: Tab to the edge, ← → move 16px (Shift 64px), Home/End jump to the limits.
    - Limits: 160px to half the timeline. Starts at 300px (was 220) and is remembered in this browser.
    - Compass's other reviews use the same column. At phone width the timeline still scrolls sideways inside its card.

    Checked in a headless browser at 1280px: header, month headings, bars and handle line up at 300, dragged to 420, held at the max (623 = half) and min (160), and 240 from the keyboard; 240 survived a reload; dark mode, Year view and 390px phone width fine; no console errors.

    Choices to know about:
    - A series row (several entries on one line) shows the reference of the entry whose name it already uses (the latest in the period).
    - The saved width is a preference: if the window narrows, the column gives way to half the timeline and comes back when it widens.
    - At phone width, 300px fills most of the card before you scroll (it can be dragged narrower); a narrower phone start is an option if you'd like it.
    - Small extra fix: the icon on other-review rows no longer shrinks in a narrow column.

    Checks: lint, types, format clean; 7 new tests (keyboard, both limits, drag, saved width, blocked/unusable saved value); SAP and screen-conventions tests pass; full suite green apart from load-timeouts in unrelated files that pass alone.
assignee: steve
label:
- improvement
priority: low
task_status: review
---
Steve, testing on staging (2026-11-12).

**Today:** in the SAP **Timeline** view (quarter or year), each row's name sits in a fixed narrow strip on the left (220 px). Most entry names are cut off with "…" so far that they're hard to read. The full name shows only in the browser's hover tip.

**What it should do:**
- The names sit in their own column with a heading ("Entry"), separate from the bars.
- The column can be resized by dragging its right edge, with a visible handle and a resize cursor. It's also reachable from the keyboard: focus the handle, then ← and → change the width.
- It has sensible limits: at least about 160 px, and at most about half the timeline's width, so the bars always keep room.
- The width chosen is remembered in this browser for the SAP Timeline, and it starts wider than today (about 300 px).
- A name that still doesn't fit is cut with "…" and shows in full on hover, as today. The reference (e.g. SAP-12) is part of what's shown.
- Rows for Compass's other reviews (shown beside the plan) use the same column.
- At phone width the timeline still scrolls sideways inside its card, not the page.

**Done when:**
- dragging the column's edge widens and narrows it, and the bars and month headings line up with the new width;
- the width survives a reload;
- the column can't be dragged past its limits;
- the handle works from the keyboard;
- light and dark mode and phone width are checked;
- there are no errors in the browser console.

Frontend only: `sap/SapTimeline.tsx` (grid `220px 1fr`, `TimelineRow` / `labelCell`). Independent of the chain.