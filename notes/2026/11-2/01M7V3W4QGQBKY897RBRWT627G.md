---
id: 01M7V3W4QGQBKY897RBRWT627G
created: 2026-11-19T23:57:05.648624Z
updated: 2026-11-20T00:52:23.108419Z
type: task
title: A selected connection's end handles can be grabbed and dragged
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2013
sprint: s6y6p7g
comments:
- id: 01M7V719Q0S09Y6G1S6XYE8D6J
  author: Steve Vine
  at: 2026-11-20T00:52:20.32032Z
  text: |-
    Done — PR #2010, merged 3335dab9.
    With a connection selected, its two round end handles now sit above everything on the canvas: shapes, labels, other lines and the shapes' own connection points. A press anywhere on a handle grabs it, and dragging moves that end to another point or another shape.
    Zoomed out, the handles stay full size on screen so they're still easy to press. Zoomed in, they grow with the canvas as before.
    With nothing selected, pressing a shape's own connection point still starts a new connection.
    Tested with real hit-testing in a browser, at zoom 0.5, 1 and 2 on light and dark canvases, where each handle sits right on top of a shape's connection point: the handle is what's under the pointer, and the drag lands. Before the fix, the same test found the shape's point on top. The Browser smoke now also selects a connection in the flowchart journey, checks both handles are on top and drags an end.
    Assumption: zoomed out, the handles keep a fixed size on screen rather than shrinking.
    To check on staging: select a connection, drag either end to another point on the same shape, then to another shape, at a couple of zoom levels and in the dark canvas.
assignee: steve
label:
- bug
priority: high
task_status: review
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