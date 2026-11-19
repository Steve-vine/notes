---
id: 01M7V3W4QGQBKY897RBRWT627G
created: 2026-11-19T23:57:05.648624Z
updated: 2026-11-19T23:57:22.434215Z
type: task
title: A selected connection's end handles can be grabbed and dragged
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2013
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: high
task_status: todo
---
Found in pre-UAT of round 3, by Tester A on staging 7ea67f64, against COM-1996.

**Steps:** open any flowchart in the editor, click a connection, then press and drag either of its round end handles.

**Seen:**
- The press lands on whatever sits on top of the handle: the shape's own connection point, the line, or the shape's label. Not one pixel of either handle can be pressed.
- So the drag starts a new connection. On release nothing changes and the shape gets selected.
- Cause: the handles are in React Flow's edge-label layer, below the selected connection and below the shapes.

Screenshots: ~/compass-uat/s6y6p7g/COM-1996/r3-03-dragging-end.png, r3-04-dropped-same-shape.png, r3-06-handle-covered.png

When the handles were made reachable, the rest of COM-1996 worked.

**Done when**
- With a connection selected, its two end handles sit above everything else on the canvas and can be pressed anywhere on them:
  - above shapes, labels and other lines;
  - above shapes' own connection points.
- Dragging a handle moves that end, per COM-1996's Done-when list.
- Pressing a shape's own connection point where no handle is shown still starts a new connection, as today.
- It works at zoom 0.5, 1 and 2, on light and dark canvases, and in full screen.
- Tests cover pressing each handle where it overlaps a shape and a shape's connection point, using real hit-testing in a browser-like test or the layout harness, not just a direct event on the handle.

Independent: frontend only.