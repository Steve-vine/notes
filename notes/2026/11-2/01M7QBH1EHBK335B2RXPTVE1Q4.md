---
id: 01M7QBH1EHBK335B2RXPTVE1Q4
created: 2026-11-18T12:53:52.721261Z
updated: 2026-11-18T19:08:51.212478Z
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
assignee: steve
label:
- improvement
priority: medium
task_status: review
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