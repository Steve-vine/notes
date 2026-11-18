---
id: 01M7QCRTJPSD1HBN0XXC1MJSAP
created: 2026-11-18T13:15:36.406103Z
updated: 2026-11-18T13:15:39.709407Z
type: task
title: 'A free-floating Line: drawn anywhere to point at something, without connecting to shapes'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1955
sprint: s6y6p7g
assignee: steve
label:
- feature
priority: medium
task_status: todo
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