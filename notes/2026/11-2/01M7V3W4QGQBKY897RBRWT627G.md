---
id: 01M7V3W4QGQBKY897RBRWT627G
created: 2026-11-19T23:57:05.648624Z
updated: 2026-11-20T02:24:38.810699Z
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
- id: 01M7VCAACTVZ4WE31XD3ZVTBAE
  author: Steve Vine
  at: 2026-11-20T02:24:38.810365Z
  text: |-
    Pre-UAT on staging d8749c62 — Passed
    - With a connection selected, both end handles sit above everything and can be pressed anywhere on them: Passed. As E2E Admin A, on "E2E pre-UAT COM-2016 new standalone", I tested every pixel of each round handle in the browser. The handle was the thing under the pointer in every case (81 of 81 points at zoom 1). That includes where the handle sits right on a shape's connection point, on a Decision's top and on a Data cylinder's bottom.
    - Dragging a handle moves that end, per COM-1996: Passed.
      - Dragging the arrow end from the Decision's top showed the diamond's points, with the nearest one filled in. Dropping it fixed "Arrives at: Left side, Middle" (r3re-02, r3re-03).
      - Dragging it onto the Records cylinder reconnected it ("Start → Records"), and one Ctrl+Z undid it (r3re-04, r3re-05).
      - The start end can be dragged too: pressed near its edge at zoom 0.5, it moved to "Leaves from: Left side, Middle" (r3re-09, r3re-10).
    - Pressing a shape's own connection point with nothing selected still starts a new connection: Passed. A drag from Records' bottom point to Check request made a new "Records → Check request" connection (r3re-06).
    - Zoom 0.5, 1 and 2, light and dark canvases, full screen: Passed.
      - Dark canvas: zoom 1, 0.48 and 2. Light canvas: zoom 1.05 and 0.51. At each one the handles were fully on top and a drag moved the end to a new point (Right side 25% ↔ Top side 25%).
      - Zoomed out, the handles stay 12px on screen. At zoom 2 they're 24px (r3re-07, r3re-08).
      - Full screen: the editor already fills the window and has no separate full-screen mode, so I checked it there.
    - Tests use real hit-testing: Passed. The Browser smoke's flowchart journey now checks that each handle is what's under the pointer, then drags an end. That smoke passed on this deploy. connectionPoints.test.tsx has small additions.
    Screenshots: ~/compass-uat/s6y6p7g/COM-2013/r3re-*
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