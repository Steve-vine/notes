---
id: 01M77VV5WG8JHB0AEXKXHC3HXV
created: 2026-11-12T12:31:11.248696Z
updated: 2026-11-12T12:34:50.33951Z
type: task
title: 'SAP Timeline: entry names sit in their own column, which can be dragged wider, so names aren''t cut short'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1751
sprint: spsp226
assignee: steve
label:
- improvement
priority: low
task_status: active
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