---
id: 01M7QBH1EHBK335B2RXPTVE1Q4
created: 2026-11-18T12:53:52.721261Z
updated: 2026-11-19T18:45:28.903516Z
type: task
title: Add a flowchart shape by dragging it from the toolbar onto the canvas, and a clicked one lands in view
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1946
sprint: s6y6p7g
comments:
- id: 01M7R0ZJ6RZZ9R4EEAGKW31S1Y
  author: Steve Vine
  at: 2026-11-18T19:08:48.727945Z
  text: |-
    Done — PR #1954, merged 1f9920a8.
    Every shape button can now be dragged onto the canvas. A faint outline of the shape follows the pointer, and the shape lands where you let go, on the grid (Alt for off the grid). It joins the lane it's dropped in and isn't connected to anything.
    Dropping a shape (not a Note or a Group) onto a connection puts it in between. The connection is highlighted while you hover, then runs into the new shape and on from it, keeping its label on the first part. If the new shape needs room, the shapes that follow move along the flow.
    Clicking a shape button with nothing selected puts the new shape in the middle of what's on screen, in the nearest free spot, selected and ready to type into. With a shape selected, a click works as before. Each add is one Undo.
    Assumption: a shape dropped on a line is placed just past the shape the line comes from if it would sit on top of it, and what follows makes room. A drop on empty canvas lands exactly where you let go.
    To check on staging: drag a Decision onto an existing line; drag a Step onto empty space inside a lane; with nothing selected, scroll somewhere and click Step.
- id: 01M7R5Z0YJFYH9V7ZMFKEEWSNR
  author: Steve Vine
  at: 2026-11-18T20:35:53.937997Z
  text: |-
    Pre-UAT round 2 on staging cbacf0c2 — Failed
    As E2E Admin A on "E2E pre-UAT COM-1945 canvas round 2".
    - Drag from the bar to a chosen spot, inside the right lane: Passed.
      - Dragged Decision onto empty space in Change board. It landed centred where I let go, on the grid, unconnected, selected, and the panel said "In the lane Change board". Undo removed it.
      - Couldn't check by eye: the "faint outline" is the browser's own drag picture, which a headless browser's screenshots don't show. The code builds it.
    - Dropping onto a connection inserts the shape: partly Failed.
      - Works: Step dropped onto the "Change record → Done" line. The line was highlighted while hovering, and the new step went in between: Change record → Step → Done. What followed moved along to make room.
      - Works: a Note dropped on a line was not inserted (no highlight). It was placed there and only pushed that line aside.
      - Works: dropping onto the labelled "No" line kept "No" on the first part ("Approved? → Document, labelled No").
      - DEFECT: that Document was placed on top of an unrelated shape, "Request form": the boxes overlap by 80×20. The "Submit" line (Request form → Approved?) now runs through the new Document. The "No" line and the "Submit" line also run side by side into the decision, with their ends 16px apart.
      - Steps: Left-to-right chart; drag Document from the bar onto the "No" line where it runs just under "Request form".
      - Expected: the inserted shape lands clear of other shapes, and no line goes through it.
      - Screenshot: r2-06-DEFECT-dropped-shape-on-top-of-request-form.png.
    - Click-add with nothing selected lands in view: Passed. With the chart panned off to the top-left, clicking Step put the new step in the middle of the visible canvas, selected.
    - Tests: Passed. dropIn.test.tsx on main (COM-1946).
    Observation: after a click-add, typing straight away does nothing. You must press Enter or F2 (or double-click) first, then type. The task text says "selected, so you can type its label straight away".
    Screenshots: ~/compass-uat/s6y6p7g/COM-1946/ (r2-*)
- id: 01M7RCTFHYMY274EB158FH7TPB
  author: Steve Vine
  at: 2026-11-18T22:35:45.086249Z
  text: |-
    Re-check on staging d6c281fe: "dropping onto a connection inserts the shape" now Passed.
    - Document dropped onto the "No" line between Approved? and Make the approved change: inserted (label "No" kept on the first part) and landed clear.
    - Document dropped onto the Submit line right beside Request form: inserted and landed clear of Request form, with no line through it.
    - The round-2 observation is fixed too: after a click-add, Tab-add or drop you can type the label straight away; Escape leaves it empty.
    Details and screenshots in COM-1977 (~/compass-uat/s6y6p7g/COM-1977/r2re-*).
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Steve, testing on staging, 2026-11-18: with nothing selected, clicking a shape button adds the new shape at the bottom of the flowchart. It would help to add a shape by dragging a shape button onto the canvas.

**What the author sees**
- **Drag to place:** drag any shape button (Start/End, Step, Decision, Document, Input/Output, Hand-off, Note) onto the canvas. A faint outline of the shape follows the pointer, and the shape lands where it's dropped, snapped to the grid (Alt for no snapping, as COM-1943). It joins the lane it's dropped in, and isn't connected to anything.
- **Drop onto a line:** dropping a shape (not a Note) onto an existing connection puts it in between. The connection now runs into the new shape and on from it, keeping its label on the first part. A highlight on the line shows this before you let go.
- **Click with nothing selected:** the new shape goes in the middle of what's on screen, in a free spot, not at the bottom (possibly out of view). It's selected, so you can type its label straight away (COM-1941).
- **Click with a shape selected:** unchanged. The new shape goes after the selected one (COM-1933).
- Each add is one undoable change.

**Done when**
- Every shape can be dragged from the toolbar and dropped at a chosen spot, inside the right lane.
- Dropping onto a connection inserts the shape into it.
- A click-added shape with nothing selected appears in view, not at the bottom.
- Tests cover drag-and-drop, dropping onto a line, and click-adding with nothing selected.

Independent: frontend.