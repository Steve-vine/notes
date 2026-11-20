---
id: 01M7TNRTWV1411Q9GPE1CA5T93
created: 2026-11-19T19:50:37.211011Z
updated: 2026-11-20T14:05:05.108886Z
type: task
title: Move a connection's end to any of several points on its shape, or to another shape
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1996
sprint: s6y6p7g
comments:
- id: 01M7TYQJXMJA1EP9AMC8HKZC7R
  author: Steve Vine
  at: 2026-11-19T22:27:13.460721Z
  text: |-
    Done — PR #1997, merged 0bdfb906.
    Every side of a shape now has connection points on its own outline: three per side, more on a long side, up to seven.
    Select a connection and a handle shows on each end. Drag one and the shape under the pointer shows its points, with the nearest one highlighted. Drop it there to fix that end, on the same shape or on another one (that reconnects it, keeping its label, look and arrows). It's one Undo step. Dropped on empty canvas, a Note, Text, a Group or its own other shape, it goes back and nothing changes.
    A fixed end stays on its point when shapes are moved or tidied up, and keeps its place along the side when a shape is resized. The connection's panel has "Leaves from" and "Arrives at" (a side and a point along it, or "Choose point automatically"), plus "Choose both points automatically", so it all works from the keyboard.
    A new connection drawn from or to one of a shape's points keeps that point. The canvas, reading view, downloads and PDF/Word all draw from the chosen points. Compare says "now leads to …" when an end moves to another shape. Polaris can read and set the points, and draw.io imports keep their exit and entry points.
    Assumptions: a new connection drawn from or to a side's middle handle is still left for Compass to choose, as before (fix the middle from the panel, or by dragging the end). Dropping on a shape's body uses its nearest point. Lucidchart's CSV doesn't record exit or entry points and Compass has no Visio import, so only draw.io keeps them.
    To check on staging: select a connection, drag its arrow end to a corner-ish point and then onto another shape; resize and Tidy up; check the reading view and PDF match; try the panel's Leaves from / Arrives at.
- id: 01M7V3TRE523P1YZK4NMT832V4
  author: Steve Vine
  at: 2026-11-19T23:56:20.293496Z
  text: |-
    Pre-UAT on staging 7ea67f64 — Failed
    Two defects:
    (1) A connection's end handles can't be grabbed with the mouse.
    (2) A connection fixed to a Manual input's top crashes the whole flowchart page, for good.
    Everything below the first point was checked by putting the handles on top of the page from the browser (a test-only change, never saved). That's how the rest of the logic was checked.
    - Selecting a connection shows a handle on each end: Passed. Two round handles, "The connection's start" and "The connection's end".
    - Dragging an end shows the points of the shape under the pointer and highlights the nearest; dropping fixes it there: Failed. As E2E Admin A, on the standalone flowchart, pressing the visible handle grabs whatever sits on top of it instead: the shape's own connection point, the line itself, or the shape's label. Not one pixel of either handle can be pressed. So the drag starts a new connection from the shape, and on release nothing changes and the shape gets selected (r3-03, r3-04, r3-06).
      - Why (technical): the handles are drawn in React Flow's edge-label layer, which sits below the selected connection (lifted when selected) and below the shapes.
      - With the handles lifted above everything: the shape showed its points, the nearest one filled in, and dropping fixed the end ("Arrives at: Right side, 75% from the top") (r3-07, r3-08).
    - Dropping on the same shape at another point moves it; the line re-routes and the label stays in view: Passed (with the handles lifted).
    - Dropping on another shape reconnects it, keeping label, style and arrows; one Undo step: Passed (with the handles lifted). "Wait until morning → Log the request", labelled "next day" and dashed, became "→ Run the triage flow", still labelled and dashed. One Ctrl+Z put it back; Ctrl+Y redid it.
    - Several connections on different points of one side: Passed. Two connections arrive at "Run the triage flow"'s top, at 25% and the middle, side by side (r3-11).
    - Dropping on empty canvas, its own other shape, a Note, Text, a free Line or a Group changes nothing: Passed. All six tried; the connection stayed exactly as it was.
    - A fixed end stays on its point through a move and Tidy up, and keeps its place along the side through a resize; "Choose point automatically" puts it back: Passed. A 25% end stayed at 25% after six arrow-key moves, a resize from 59px to 117px wide, and Tidy up. "Choose both points automatically" reset both ends, and Undo restored them.
    - Connections nobody has moved stay automatic; older flowcharts unchanged: Passed.
    - A new connection drawn from and to points keeps them: Passed. Drawn from Set up the room's left 75% point to Request form's right 25% point, it kept both.
    - Canvas, reading view, PNG/SVG, PDF and Word draw from the chosen points: Passed for every path that didn't crash (r3-picture.png, r3-export-v2-flowchart-page.png, r3-export-v2-docx-picture.png).
      - Failed for a connection fixed to a Manual input's top: pressing Done crashes the page with "This part of the page couldn't be shown". Read and Edit both crash on every visit after that, so the flowchart can't be opened, fixed or deleted from its own page.
      - Reproduced three ways: an ordinary edit (Data's bottom 17% point → Manual input, "Arrives at: Top side, Middle" from the panel, then Done); a draw.io import of a Step joined to a Manual input's top middle; and the same import with a Data shape.
      - A Data → Subprocess connection on fixed side points was fine.
      - Console: "RangeError: Map maximum size exceeded" in the route grid's claim(). Why (technical): a stretch of route that isn't straight across or down makes claim() step diagonally and never reach its end.
      - Both broken flowcharts are kept for reproduction.
    - Reconnecting updates the plain text and Compare ("now leads to …"): Passed. v1 → v2 reads "Connection “Wait until morning” → “Log the request” now leads to “Run the triage flow”". The plain text shows "Wait until morning … → 12" (Run the triage flow).
    - Polaris reads and sets points; draw.io keeps exit and entry points: Read Passed: read_flowchart lists from_port and to_port, e.g. {"side":"left","at":0.75}. Set: not tried. draw.io: Passed: exitX=1/exitY=0.25 came in as "Right side, 25% from the top", and entryX=0/entryY=0.75 as "Left side, 75% from the top". 0.25 along a 5-point side snapped to 17%.
    - Works from the keyboard via the panel: Passed. "Leaves from" / "Arrives at" offer each side plus "Choose point automatically", and a second list sets the point along the side (13%…88% on a long side). Each is named, e.g. "Arrives at: point along the side".
    - Points on a non-box shape sit on its outline: Passed. Cylinder, Start/End, Decision and hexagon points sit on the outline itself; the cylinder's long sides have 7 points.
    - Tests: connectionPoints.test.tsx and backend tests were added. They run without a real browser layout, so they couldn't catch defect 1 (the handles are covered), and nothing covers a fixed point on a sloped outline (defect 2).
    Kept for reproduction: "E2E pre-UAT COM-1992 crash isolate e1" (crash made by ordinary editing) and "E2E pre-UAT COM-1996 crash isolate manual input" (two shapes, one connection). Both crash on open.
    Screenshots: ~/compass-uat/s6y6p7g/COM-1996/ (console log: r3-crash-console.log)
- id: 01M7VCBCK5SPAZD17SKEMNJWYS
  author: Steve Vine
  at: 2026-11-20T02:25:13.828784Z
  text: |-
    Re-check on staging d8749c62: both failed points now Passed.
    - Dragging an end shows the shape's points, highlights the nearest, and dropping fixes it: now Passed with the mouse alone, with nothing lifted in the browser.
      - As E2E Admin A, the handles are on top everywhere I pressed. The diamond's points showed with the nearest filled in, and dropping fixed "Arrives at: Left side, Middle". Dropping on another shape reconnected the line, and Ctrl+Z undid it.
      - I tried this at zoom 0.5, 1 and 2, on dark and light canvases (see COM-2013).
    - Canvas, reading view, PDF and Word draw from the chosen points, including a connection fixed to a Manual input's top: now Passed.
      - Both crash drafts open on the Read and Edit tabs.
      - Setting "Arrives at: Top side, Middle" from Data's bottom 17% point and pressing Done no longer crashes. The Read tab and the fresh PDF draw the line from the fixed points.
      - The draw.io import of a Step joined to a Manual input's top middle imports, saves and reopens (see COM-2012).
      - Tidy up on a new chart kept the fixed points, and the Read tab picture matched the canvas.
    Screenshots: ~/compass-uat/s6y6p7g/COM-2012/r3re-*, COM-2013/r3re-*
assignee: steve
label:
- improvement
priority: high
task_status: done
---
Steve's smoke test of round 2: let people move a connection between connection points. Today Compass picks which side of a shape each connection leaves and arrives at, and the person can't change it. They should be able to drag either end of a connection to a different point on the same shape, or onto another shape. Each shape should have several connection points, not just one per side.

**Connection points**
- Every side of a shape has several connection points spread evenly along it: the middle, plus points a quarter and three-quarters of the way along. That makes three per side and twelve per shape.
- A long side gets more points, roughly one per grid step of its length, up to seven per side.
- On shapes whose outline isn't a box, the points sit on the outline itself, e.g. a Decision's diamond, a Start/End's rounded ends and the new shapes from COM-1992 such as the Data cylinder and Delay.

**Done when**
- Selecting a connection shows a handle on each of its ends.
- Dragging an end shows the connection points of the shape under the pointer, and the one nearest the pointer is highlighted. Dropping fixes that end on that point.
- Dropping an end on the same shape at a different point moves it there. The line re-routes from there and its label stays in view.
- Dropping an end on another shape reconnects it to that shape, at the point it was dropped on, or the best point if dropped on the shape's body. The connection keeps its label, style and arrows. It's one Undo step.
- Several connections can use different points on the same side, so lines into a busy shape don't sit on top of one another.
- Dropping an end on empty canvas, on itself or on a Text, Note, free Line or Group puts it back where it was and changes nothing. A connection never ends up loose, joined to nothing.
- A fixed end stays on its chosen point when either shape is moved or tidied up. When a shape is resized, the end keeps its place along the side, e.g. a quarter of the way along stays a quarter of the way along. A "Choose point automatically" choice in the connection's panel puts it back to Compass picking.
- Connections nobody has moved keep choosing their point automatically, as now. Older flowcharts are unchanged.
- Drawing a new connection from a shape can also start from, and end on, any of these points.
- The canvas, reading view, PNG/SVG, PDF and Word all draw the line from the chosen points.
- Reconnecting to another shape updates the plain-text version and Compare ("now leads to …").
- Polaris can read and set the point a connection leaves and arrives at. Imports from draw.io, Visio and Lucidchart keep their exit and entry points, to the nearest point.
- It works from the keyboard too: with a connection selected, its panel can set each end's side and position along it.
- Tests cover:
  - moving an end along a side and to another side;
  - reconnecting to another shape;
  - an invalid drop;
  - points kept through a move, resize and tidy up;
  - points on a non-box shape;
  - the picture matching.

On the chain: the flowchart keeps each end's point (side and position along it), which the server checks and the assistant's tools describe.