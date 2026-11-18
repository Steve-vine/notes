---
id: 01M7QBBX5T4RF4MZNA6PD30NGY
created: 2026-11-18T12:51:04.506174Z
updated: 2026-11-18T22:35:40.873436Z
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
- id: 01M7R5XV8ZP09XFXJF1EVPY5DX
  author: Steve Vine
  at: 2026-11-18T20:35:15.359744Z
  text: |-
    Pre-UAT round 2 on staging cbacf0c2 — Failed
    Test flowchart: standalone "E2E pre-UAT COM-1945 canvas round 2" (imported from my own two-lane draw.io file, 9 shapes, 8 connections), as E2E Admin A. I recorded every line's path before and after each change.
    - Drag, nudge or resize changes only that shape's own lines: Passed. Dragging "Make the change" down redrew only its 2 lines; the other 6 kept exactly the same path. Nudging Done (arrows) changed only Done's 2 lines. Widening or heightening the decision changed only the decision's own 3 lines. Every resize and nudge run undid in one step, and the lines came back exactly.
    - A line the moved shape now sits on: Failed when the shape leaves no clear way round.
      - Works: a Note dragged onto the Change record → Done line pushed that one line round it. Nothing else moved, and undo put it back exactly. The same happened when the Note was dropped from the bar onto the "Change record → Archive" line.
      - DEFECT 1: the Note dragged into the gap between "Request form" and "Approved?". The Submit line stayed straight, running through the Note and hiding its "Submit" label.
      - DEFECT 2: a Decision dragged onto the vertical "Archive the record → Done" line, so it touched "Archive the record". The line stayed where it was and runs straight through the middle of the Decision. One nudge later the same happened through the Decision's tip. In both cases the line could have left by another side.
      - Steps: drag any shape onto a line so that it fills the gap or touches the shape at the line's end. Expected: the line goes round, or leaves by another side. Seen: the line runs through the shape. Screenshots: r2-02-DEFECT-note-on-line-not-rerouted.png, r2-07-DEFECT-line-through-decision.png.
    - Routing guarantees: Failed (the 2 cases above). Also seen, not counted as a fail: the decision's "No" line leaves 8px beside the incoming "Submit" line and runs parallel to it for about 130px. The two read almost as one line, on the canvas and in the picture.
    - Picture, PDF and Word match the canvas: Passed. The downloaded SVG's line paths are identical, one for one, to the canvas paths. After Done, publishing (v1) and reopening, every line had exactly the same path (r2-picture.svg, r2-v1.pdf, r2-v1.docx).
    - Tests: Passed. route.test.ts, FlowchartEditor.test.tsx and styles.test.tsx on main reference COM-1945.
    Screenshots: ~/compass-uat/s6y6p7g/COM-1945/ (r2-*)
- id: 01M7RCTBE931MVCMNW3DVQVW9K
  author: Steve Vine
  at: 2026-11-18T22:35:40.873203Z
  text: |-
    Re-check on staging d6c281fe: "a line the moved shape now sits on" and "routing guarantees" now Passed.
    - A Note dragged into the gap between Request form and Approved? (also right up against Request form): Submit goes round it, label in view.
    - Escalate? dragged onto the Archive the record → Done line, touching Archive: the line goes round it.
    - A Note dropped or nudged onto a line, and a shape resized over a line: the line goes round it.
    - Every time only the blocked line changed, and it went back exactly when the shape moved off.
    - No line runs through a shape, overlaps another line or shares an arrowhead; canvas, SVG, PDF and Word (v4) match.
    Details and screenshots in COM-1976 (~/compass-uat/s6y6p7g/COM-1976/r2re-*).
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