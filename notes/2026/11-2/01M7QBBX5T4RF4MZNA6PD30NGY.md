---
id: 01M7QBBX5T4RF4MZNA6PD30NGY
created: 2026-11-18T12:51:04.506174Z
updated: 2026-11-18T16:01:09.699986Z
type: task
title: Moving a flowchart shape leaves other shapes' lines where they are
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1945
sprint: s6y6p7g
comments:
- id: 01M7QP7X44BJ9D91P92PE8545D
  author: Steve Vine
  at: 2026-11-18T16:01:07.715927Z
  text: |-
    Done — PR #1939, merged 4f6c79ba.
    Moving, nudging or resizing a shape now re-draws only its own lines, plus any line the shape now sits on. Every other line keeps exactly the same path, side and arrowhead point.
    A line pushed aside by a shape goes back the way it went once the shape is moved off it again (also through undo/redo).
    If a moved shape's new line would end where another line runs, it leaves by another side of its shape first; only if there's no free side does the other line make room.
    Tidy up, and switching Top to bottom / Left to right, still re-route every line from scratch.
    The reading view, PDF, Word and downloads draw the same lines as the canvas, and they stay the same after Done, publishing and reopening (each connection now remembers its line).
    Assumption: a line that already went round a shape before you opened the chart doesn't tighten up when that shape moves away (only lines the move itself pushed aside go back). Tidy up tidies everything.
    To check on staging: open an existing flowchart, drag one shape around and watch that lines between other shapes stay put; drag a shape across a line and away again.
assignee: steve
label:
- bug
priority: high
task_status: review
---
Steve, testing on staging, 2026-11-18: moving a shape sometimes makes a line on an unrelated shape above it move as well.

(Likely cause, from COM-1931/1935: every line is re-routed whenever anything moves, so a line between other shapes can jump to a different path.)

**What the author sees**
- Moving a shape re-draws only the lines that start or end at it.
- Every other line stays exactly where it was, unless the moved shape now sits on that line's path. Then only that line changes, just enough to go around the shape, and it goes back if the shape is moved away again.
- Lines between untouched shapes never jump, flip side or swap arrowhead points because something else moved.
- Tidy up still re-routes everything, as now. That's the one action that lays out the whole flowchart.

**Done when**
- Dragging, nudging (COM-1943) or resizing (COM-1940) a shape changes only its own lines, plus any line it now blocks.
- The routing guarantees still hold: no line through a step, no shared line or arrowhead.
- The picture, PDF and Word match the canvas.
- A test moves one shape and checks that every line not touching it, and not blocked by it, keeps exactly the same path.

Independent: frontend.