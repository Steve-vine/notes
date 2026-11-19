---
id: 01M7TNRTWV1411Q9GPE1CA5T93
created: 2026-11-19T19:50:37.211011Z
updated: 2026-11-19T19:50:39.411269Z
type: task
title: Move a connection's end to another point on its shape, or to another shape
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1996
sprint: s6y6p7g
assignee: steve
label:
- improvement
priority: high
task_status: todo
---
Steve's smoke test of round 2: let people move a connection between connection points. Today Compass picks which side of a shape each connection leaves and arrives at, and the person can't change it. They should be able to drag either end of a connection to a different point on the same shape, or onto another shape.

**Done when**
- Selecting a connection shows a handle on each of its ends.
- Dragging an end highlights the connection points of the shape under the pointer, the middle of each of its four sides. Dropping on a point fixes that end there.
- Dropping an end on the same shape at a different point moves it to that side. The line re-routes from there and its label stays in view.
- Dropping an end on another shape reconnects it to that shape, at the point it was dropped on, or the best side if dropped on the shape's body. The connection keeps its label, style and arrows. It's one Undo step.
- Dropping an end on empty canvas, on itself or on a Text, Note, free Line or Group puts it back where it was and changes nothing. A connection never ends up loose, joined to nothing.
- A fixed end stays on its chosen side when either shape is moved, resized or tidied up. A "Choose side automatically" choice in the connection's panel puts it back to Compass picking the side.
- Connections nobody has moved keep choosing their side automatically, as now. Older flowcharts are unchanged.
- The canvas, reading view, PNG/SVG, PDF and Word all draw the line from the chosen sides.
- Reconnecting to another shape updates the plain-text version and Compare ("now leads to …").
- Polaris can read and set which side a connection leaves and arrives at. Imports from draw.io, Visio and Lucidchart keep their exit and entry sides where the file has them.
- It works from the keyboard too: with a connection selected, the connection's panel can set each end's side.
- Tests cover moving an end to another side, reconnecting to another shape, an invalid drop, sides kept through a move and tidy up, and the picture matching.

Assumption (Claude): four connection points per shape (the middle of each side) is enough. More points per side, or free placement anywhere on the outline, is left out.

On the chain: the flowchart keeps each end's side, which the server checks and the assistant's tools describe.