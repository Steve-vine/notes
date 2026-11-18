---
id: 01M7R615DNNG3ENQHWAG5KZ84T
created: 2026-11-18T20:37:04.053804Z
updated: 2026-11-18T20:38:04.784796Z
type: task
title: A flowchart line never runs through a shape that was moved onto it, even in a tight spot
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1976
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: high
task_status: active
---
Pre-UAT round 2 (tester A, staging cbacf0c2), COM-1945: moving a shape redraws only its own lines, but a shape moved onto another line where there's no clear way round leaves that line running straight through it, and the line's label can be hidden.

Seen:
- A Note dragged into the gap between "Request form" and "Approved?" — the Submit line stayed straight through the Note and its label was hidden.
- A Decision dragged onto the "Archive the record → Done" line, touching "Archive the record" — the line runs through the Decision.
Screenshots: ~/compass-uat/s6y6p7g/COM-1945/r2-02-DEFECT-note-on-line-not-rerouted.png, r2-07-DEFECT-line-through-decision.png

**Done when**
- A line blocked by a moved, nudged, resized or dropped shape always goes round it, leaving or entering by another side of its own shapes if it has to, even when the shape fills the gap or touches one of the line's ends.
- Its label stays in view.
- Other lines still stay where they were (COM-1945).
- The canvas, picture, PDF and Word match.
- Tests cover a shape filling the gap between two connected shapes and a shape touching a line's end shape.

Independent: frontend routing.