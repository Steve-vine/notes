---
id: 01KY70S5MDT60Z4AYNJ48EEKZX
created: 2026-07-23T08:16:57.485557Z
updated: 2026-07-23T09:16:53.497776Z
type: task
title: Dragging cards to offscreen collumns
assignee: steve
label: null
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 168
comments:
- id: 01KY70SAWZ4ZAMTWQ8XGESCNQF
  author: Steve Vine
  at: 2026-07-23T08:17:02.879161Z
  text: |-
    Steve Vine · 2026-07-04:

    Done as agreed — a board-level `dragover` listener in `KanbanBoard.svelte` feeds a `requestAnimationFrame` loop that scrolls the board when the pointer is within 60px of its left/right edge, speed scaled by proximity (max 14px/frame). Works for card drags and column-reorder drags alike (dragover bubbles from the columns).

    **Decisions on the fly:** the loop self-terminates when the drag state clears (drop or dragend), with explicit stops on `dragend` and component destroy — belt and braces against a runaway scroll after a cancelled drag.

    **Problems encountered:** none. Frontend check/tests green; full gate green on push.

    Worth a hands-on test: drag a card to the far edge of a board with off-screen columns, and also try dropping on a newly revealed column. Tuning knobs are `SCROLL_EDGE` (60px) and `SCROLL_MAX_SPEED` (14px/frame) if it feels too eager or too slow.

    PR: https://github.com/Steve-vine/notuvia/pull/152
sprint: ssy6aak
---
It's not possible to drag a card to a column that isn't visible.  When dragging a card, when the mouse pointer gets to the far left or right side of the kanban board it should scroll to bring off-screen columns into view

## Agreed work (planned 2026-07-04)

* `KanbanBoard.svelte`: the `.board` div (the horizontal scroll container) gets a board-level `dragover` listener (dragover bubbles from the columns, so one listener covers card and column drags).
* When the pointer is within ~60px of the board's left/right edge during a drag, a `requestAnimationFrame` loop nudges `scrollLeft`, speed scaled by edge proximity (up to ~14px/frame).
* The loop stops when the pointer leaves the edge zone, on drop/dragend, or when no drag is active.
* Pure frontend; no component tests exist — manual verification.

---

Linear DEV-810 · Kanban board Improvements · created 2026-07-04 · done 2026-07-04