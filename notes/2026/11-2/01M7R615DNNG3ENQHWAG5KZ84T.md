---
id: 01M7R615DNNG3ENQHWAG5KZ84T
created: 2026-11-18T20:37:04.053804Z
updated: 2026-11-19T18:45:29.42114Z
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
- id: 01M7RCSMRHN2JNBGH0T07YVVQN
  author: Steve Vine
  at: 2026-11-18T22:35:17.649126Z
  text: |-
    Pre-UAT on staging d6c281fe — Passed
    As E2E Admin A on "E2E pre-UAT COM-1945 canvas round 2", switched to Left to right and tidied up (9 connections). I recorded every line's path before and after each change.
    - A line blocked by a moved, nudged, resized or dropped shape goes round it, even in a tight spot: Passed.
      - Moved: the Note dragged into the gap between "Request form" and "Approved?" (twice, the second time right up against Request form). The Submit line went round it each time, leaving by another side of Request form where it had to. Moved away, the line went back exactly (r2re-06…09).
      - Moved, touching the end shape: the "Escalate?" decision dragged onto the "Archive the record → Done" line, touching Archive the record. The line went round it. Moved away, it went back exactly (r2re-10).
      - Dropped: a new Note dropped from the bar onto that line, touching Archive the record: the line went round it (r2re-14).
      - Nudged: that Note nudged right 8 times with the arrow keys: the line kept clear at every step and went back to its old path once the Note was clear.
      - Resized: Escalate? widened over the Submit line: Submit re-routed into the top of the decision (r2re-15).
    - Its label stays in view: Passed. "Submit" was never under a shape in any of these (checked on screen).
    - Other lines stay where they were: Passed. Each time only the blocked line changed; all other paths were identical.
    - Canvas, picture, PDF and Word match: Passed. Kept the Note in the gap and published v4. The SVG download's line paths are identical to the canvas paths, and the PDF and Word pictures show the same detour (r2re-picture.svg, r2re-v4.pdf / -p2.png, r2re-v4.docx / r2re-v4-word-picture.png). No line overlaps another and no two lines share an arrowhead.
    - Tests: Passed. route.test.ts on main: "goes round a shape that fills the gap between two connected shapes" and "goes round a shape touching the line's end shape" (COM-1976).
    Observations:
    - Your suggested check "drop a Decision right on top of Archive the record". A Decision dropped from the bar onto the middle of the shape (not a line) lands exactly on top of it. It hides "Archive the record", and the lines stay as they were (r2re-11, r2re-12). That matches COM-1977's stated assumption that a drop not onto a line lands where you let go. Steve may still want a drop onto a shape to be moved clear.
    - In one case the Submit detour also went round "Escalate?", which made a long loop (r2re-06/07). It's correct, just roundabout.
    Screenshots: ~/compass-uat/s6y6p7g/COM-1976/ (r2re-*)
assignee: steve
label:
- bug
priority: high
task_status: done
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