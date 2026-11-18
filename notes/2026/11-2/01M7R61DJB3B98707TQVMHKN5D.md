---
id: 01M7R61DJB3B98707TQVMHKN5D
created: 2026-11-18T20:37:12.395895Z
updated: 2026-11-18T20:37:14.426689Z
type: task
title: A flowchart shape dropped onto a line lands clear of other shapes, and a click-added shape takes typing at once
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1977
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: high
task_status: todo
---
Pre-UAT round 2 (tester A, staging cbacf0c2), COM-1946:
- **Overlap:** on a left-to-right chart, dragging Document from the bar onto the "No" line just under "Request form" inserted it correctly, but it overlaps "Request form" by 80×20 and the Submit line now runs through it. Screenshot: ~/compass-uat/s6y6p7g/COM-1946/r2-06-DEFECT-dropped-shape-on-top-of-request-form.png
- **Typing:** after a click-add, typing does nothing until Enter or F2, though COM-1946 says you can type the new shape's label straight away.

**Done when**
- A shape dropped onto a line is placed (and the shapes after it moved along) so that it overlaps no other shape and no line runs through it.
- After a click-add or a drop, typing straight away replaces the new shape's label in place (COM-1941's editor); Escape keeps the default label.
- Tests cover a drop beside a neighbouring shape and typing after a click-add.

Independent: frontend canvas.