---
id: 01M7TNRTWV1411Q9GPE1CA5T93
created: 2026-11-19T19:50:37.211011Z
updated: 2026-11-19T22:27:21.449869Z
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
assignee: steve
label:
- improvement
priority: high
task_status: review
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