---
id: 01M7R61DJB3B98707TQVMHKN5D
created: 2026-11-18T20:37:12.395895Z
updated: 2026-11-18T22:35:25.710654Z
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
- id: 01M7RCSWME4DTR47CYKGWAFTAD
  author: Steve Vine
  at: 2026-11-18T22:35:25.710216Z
  text: |-
    Pre-UAT on staging d6c281fe — Passed
    As E2E Admin A on "E2E pre-UAT COM-1945 canvas round 2", Left to right, tidied. After Tidy up the layout differs from round 2, so I recreated the round-2 case: dropping onto a line right beside a neighbouring shape.
    - A shape dropped onto a line lands clear of other shapes, with no line through it: Passed.
      - Document dropped onto the "No" line where it runs up between "Approved?" and "Make the approved change". The line was highlighted on hover. The Document went in between (Approved? → Document, labelled No → Tell requester) and landed clear above Make the approved change. Nothing overlaps and no line runs through it (r2re-hover, r2re-01).
      - Document dropped onto the Submit line just beside and under "Request form", where it would have sat on Request form: it went in between and landed clear to the right of Request form. Nothing overlaps and no line runs through it (r2re-03…05).
      - Decision dropped onto the "Archive the record → Done" line next to Archive the record: it went in between and landed clear (COM-1976 folder r2re-13).
    - Typing straight away after a click-add or a drop: Passed.
      - Nothing selected, click Step, type "Phone the requester": the label opened in place on the canvas with the first letter in. Enter kept it (r2re-06). Undo removed the label, a second Undo removed the step.
      - Right after dropping the Document, typing "Rejection letter" named it in place (r2re-02).
      - Tab after a shape, then typing: named the new step.
      - Escape after typing "Ab" on a fresh click-added step left it with an empty label (r2re-07).
      - A shape that already has a name ignores typing ("Log the request" selected, typed "zz": unchanged).
      - The new hint "A–Z name a shape just added: just start typing" shows under How to build it.
    - Tests: Passed. dropIn.test.tsx on main: "never lands on a shape beside the line, and no line runs through it", "takes what is typed after a click-add, in place", "…after a drop", "keeps the default label when Escape is pressed".
    Observations:
    - In the Request form case the Submit line left before the new Document is very short (about 17px). Its "Submit" label sits partly under the Document's left edge: "Subm" shows, the rest is hidden (r2re-05).
    - A drop onto a shape rather than a line lands right on top of it (see the COM-1976 comment). That's as your assumption says.
    Screenshots: ~/compass-uat/s6y6p7g/COM-1977/ (r2re-*)
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