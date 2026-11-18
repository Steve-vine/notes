---
id: 01M7QCRTJPSD1HBN0XXC1MJSAP
created: 2026-11-18T13:15:36.406103Z
updated: 2026-11-18T19:29:26.067155Z
type: task
title: 'A free-floating Line: drawn anywhere to point at something, without connecting to shapes'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1955
sprint: s6y6p7g
comments:
- id: 01M7R256W80X9YEPGD1QVEF8JK
  author: Steve Vine
  at: 2026-11-18T19:29:22.312743Z
  text: |-
    Done — PR #1951, merged b52d4de1.
    - Line joins the bar. Clicking it puts a short Line in the middle of the view, selected; a drag on the canvas straight after draws it from where the drag starts to where it ends (Escape keeps the short one).
    - Selected, it has a handle at each end, plus one to move a Right-angled Line's bend or to bend a Curved one. Drag the line itself to move it; the arrow keys nudge it; copy, paste and Delete work as for connections. Its ends never attach: one dropped on a shape stays where it fell, and moving shapes never moves a Line.
    - The Style panel's line options apply (Straight with an arrow at the end by default, plus route, arrows, pattern, weight, colour and label font). The label is set in its panel.
    - It sits on no lane. One drawn inside a Group moves with that Group, and Tidy up leaves every Line where it is.
    - Reading view, PDF, Word and downloads draw it with its style and label. The plain-text steps never change; its label is read with the notes, so search finds it. Compare versions names Lines added, removed or relabelled.
    - Polaris keeps a flowchart's Lines when it changes the flowchart, and can add Lines pointing at a step, or remove them. Loose lines from draw.io come in as Lines where they were drawn; from Lucidchart (which has no positions), as Lines pointing at their shape.
    Assumptions: the label is edited in the Line's panel, not by double-click on the canvas. Polaris places a new Line beside the step it points at, since it has no positions to work with.
    To check on staging: draw a Line onto a step, switch it to Curved and drag its bend, then move the step (the Line stays put). Draw one inside a Group and move the Group. Check the PDF and the plain-text export.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Steve, testing on staging, 2026-11-18: create a new shape called Line. It's the same as a connector, but free-floating and without connection points, so an author can point at something without connecting things.

**What the author sees**
- **Drawing one:** Line joins the shape buttons. Choose it, then drag on the canvas from where the line starts to where it ends. Clicking Line with nothing to drag adds a short line in the middle of the view (COM-1946's rule).
- **Never attached:** a Line's ends don't snap to or attach to shapes. Dropping an end on a shape just leaves it there. Moving a shape never moves a Line, and a Line never moves shapes.
- **Selecting and changing it:**
  - A selected Line shows a handle at each end to drag. The whole line can be dragged, nudged with the arrows or Shift + arrow (COM-1943), copied, pasted and deleted.
  - It takes the connection styles (COM-1944): Straight, Right-angled (one bend, with a handle to move it) or Curved (with a handle to bend it), arrows at either, both or no end, solid, dashed or dotted, weight, and colour (COM-1942).
  - It defaults to straight with an arrow at the end point.
  - It can have an optional label, placed along it and kept readable, edited by double-click (COM-1941).
- **Lanes and groups:** a Line sits on the canvas, not in a lane. If drawn inside a Group (COM-1954), it moves with that Group.
- **Tidy up:** a Line keeps its place relative to the canvas (or its Group), and laid-out lines are never routed around it.

**What a reader sees**
- **Pictures:** the reading view, PDF, Word and downloads show each Line with its style and label.
- **Meaning:** a Line is drawing only. It isn't a step or a connection, and it doesn't appear in the plain-text steps, search or Polaris's reading of the flow, so the steps in words never change because of one. A Line's label is kept with the flowchart's notes, so search can still find its words.
- **Compare versions:** it mentions Lines added or removed.

**Elsewhere**
- **Imports:** a draw.io or Lucidchart line with a loose end, which those imports currently list as "not carried over", now comes in as a Line instead.
- **Polaris** can add or remove a Line when asked.

**Done when**
- A Line can be drawn by dragging, moved, reshaped by its end and bend handles, styled, labelled and deleted.
- It never attaches to shapes, and moving shapes never moves it.
- It shows the same on the canvas, in the reading view, PDF, Word and downloads, and never changes the plain-text steps.
- Loose lines from draw.io and Lucidchart imports come in as Lines.
- Tests cover drawing, the handles, not attaching, the styles, and the plain text staying the same.

On the chain: the stored flowchart gains a new kind of item, which the server checks. Build it after COM-1944 (line styles), which it reuses.