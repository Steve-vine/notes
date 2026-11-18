---
id: 01M7R73V0X4RHCAPG5PA27WTD2
created: 2026-11-18T20:56:00.285095Z
updated: 2026-11-18T21:56:29.392352Z
type: task
title: 'A free flowchart Line: a curved one only catches clicks on the line itself, and one can be drawn starting inside a Group'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1981
sprint: s6y6p7g
comments:
- id: 01M7RAJHEE1WZGAG72WJTCHAZZ
  author: Steve Vine
  at: 2026-11-18T21:56:27.726133Z
  text: |-
    Done — PR #1959, merged d6c281fe.
    - A free Line, whatever its route, is now picked only by a click on the line itself (within a few pixels of it), on its label or on its handles. Shapes sitting inside the area a curved Line encloses can be clicked and selected as normal. The Line's label now picks the Line; it didn't before.
    - After pressing Line, a drag that starts anywhere draws the Line: inside a Group, over a shape or on the empty canvas. The Group or shape under the press no longer moves. A Line drawn inside a Group belongs to it and moves with it.
    - Checked in a real browser: on the old build every point inside the curve's box picked the Line. Now only a narrow band along the line does, and a Line drawn from inside a Group left the Group where it was.
    Assumption: while drawing, a press on the Line's own end or bend handle still reshapes that Line rather than starting a new one.
    To check on staging: make a Line Curved and bend it over a step, then click the step. Press Line and drag from inside a Group, then move the Group: the Line goes with it.
assignee: steve
label:
- bug
priority: high
task_status: review
---
Pre-UAT round 2 (tester B, staging cbacf0c2), COM-1955:
- **Curved Line blocks clicks:** make a Line Curved and bend it over shapes; clicking the middle of a shape inside the area it encloses selects the Line. The line's path takes pointer events across its whole filled area. Screenshot: ~/compass-uat/s6y6p7g/COM-1955/r2-10-click-on-text-selects-line.png
- **Can't draw inside a Group:** click Line, then drag starting inside a Group: the Group moves instead of a Line being drawn. Only the short click-added Line can be put in a Group. Screenshot: COM-1955/r2-05a-after-second-draw.png

**Done when**
- A Line (any route) is picked only by a click on or within a few pixels of its stroke, its handles or its label; shapes under its curve are clickable.
- After pressing Line, a drag starting anywhere, including inside a Group or over a shape, draws the Line (and a Line drawn inside a Group moves with it).
- Tests cover clicking a shape under a curved Line and drawing a Line from inside a Group.

Independent: frontend canvas.