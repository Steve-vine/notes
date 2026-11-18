---
id: 01M7R615DNNG3ENQHWAG5KZ84T
created: 2026-11-18T20:37:04.053804Z
updated: 2026-11-18T21:00:54.504863Z
type: task
title: A flowchart line never runs through a shape that was moved onto it, even in a tight spot
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1976
sprint: s6y6p7g
comments:
- id: 01M7R7CPSQF9FZ7ZQ5F3QNBTD6
  author: Steve Vine
  at: 2026-11-18T21:00:50.871196Z
  text: |-
    Done — PR #1956, merged 0cc385e4.
    A line that has to make way for a shape moved, nudged, resized or dropped onto it now always goes round it, even when the shape fills the gap next to one of the line's ends or sits right up against the line's own shape: the line leaves (or arrives) by another side of its shape, the side nearest where it's going first.
    Two shapes placed close together are still joined by a short straight line, and every other line stays where it was.
    A label with no clear stretch on its line now sits just beside the line rather than under a shape.
    Canvas, picture, PDF and Word all draw the same kept line, so they match.
    To check on staging: drag a Note into the gap between "Request form" and "Approved?" (the Submit line goes round, its label in view), and drop a Decision right on top of "Archive the record" (its line to Done goes round the Decision). Move the shape away again and the line goes back the way it was.
assignee: steve
label:
- bug
priority: high
task_status: review
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