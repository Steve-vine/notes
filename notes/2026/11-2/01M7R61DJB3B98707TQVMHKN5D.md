---
id: 01M7R61DJB3B98707TQVMHKN5D
created: 2026-11-18T20:37:12.395895Z
updated: 2026-11-18T21:14:09.724938Z
type: task
title: A flowchart shape dropped onto a line lands clear of other shapes, and a click-added shape takes typing at once
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1977
sprint: s6y6p7g
comments:
- id: 01M7R84Z7HHDC1J6CH8PA15H3H
  author: Steve Vine
  at: 2026-11-18T21:14:05.937459Z
  text: |-
    Done — PR #1958, merged 320c5f34.
    A shape dropped onto a line no longer lands on top of a shape beside the line. If it lands on what the line leads to, that and what follows still move on along the flow, as before. If it lands on any other shape, it goes to the nearest clear place instead, and the lines go round it.
    After clicking a shape in, pressing Tab, or dropping one, you can just start typing: the label opens in place with your first letter in, and you carry on typing. Enter or clicking away keeps it, and Escape leaves the shape with its default (empty) label. Once a shape has a name, typing does nothing; Enter, F2 or double-click edit it as before. A new hint under "How to build it" says so.
    Assumptions: the "default label" is the empty one a new shape starts with. A plain drop that isn't onto a line still lands exactly where it's let go. Space doesn't start typing, because the canvas uses it to pan.
    To check on staging: on a left-to-right chart, drag Document onto the "No" line just under "Request form": it lands clear of Request form and no line runs through it. Click Step in the bar and type straight away. Then Escape on a fresh one.
assignee: steve
label:
- bug
priority: high
task_status: review
---
Pre-UAT round 2 (tester A, staging cbacf0c2), COM-1946:
- **Overlap:** on a left-to-right chart, dragging Document from the bar onto the "No" line just under "Request form" inserted it correctly, but it overlaps "Request form" by 80×20 and the Submit line now runs through it. Screenshot: ~/compass-uat/s6y6p7g/COM-1946/r2-06-DEFECT-dropped-shape-on-top-of-request-form.png
- **Typing:** after a click-add, typing does nothing until Enter or F2, though COM-1946 says you can type the new shape's label straight away.

**Done when**
- A shape dropped onto a line is placed (and the shapes after it moved along) so that it overlaps no other shape and no line runs through it.
- After a click-add or a drop, typing straight away replaces the new shape's label in place (COM-1941's editor); Escape keeps the default label.
- Tests cover a drop beside a neighbouring shape and typing after a click-add.

Independent: frontend canvas.