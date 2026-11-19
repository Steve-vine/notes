---
id: 01M7R73V0X4RHCAPG5PA27WTD2
created: 2026-11-18T20:56:00.285095Z
updated: 2026-11-19T18:45:29.608512Z
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
- id: 01M7RCMD5M64MWCE3W5P5PZ5AJ
  author: Steve Vine
  at: 2026-11-18T22:32:26.036367Z
  text: |-
    Pre-UAT on staging d6c281fe — Passed
    Flowchart: "E2E pre-UAT COM-1954 COM-1955 COM-1956 group line text" (now v5). As E2E Admin A in E2E Test Company, in my own headless Chromium.
    - A Line is picked only on or near its stroke, its label or its handles, and shapes under its curve are clickable: Passed.
      - The Curved, dashed Line "Check this one" bends over the Group, so "Work the oldest ticket" and the Text sit inside the area its curve encloses.
      - Clicking the middle of each selected that shape, not the Line (r2re-02).
      - On the curve itself, and 4px off it, the click selected the Line. 15px off it, the click selected nothing.
      - A click on its label "Check this one" selected the Line.
    - After pressing Line, a drag that starts inside a Group draws the Line, and the Line moves with the Group: Passed.
      - I pressed Line, then dragged from an empty spot in the Group's pink area. That spot is on the Group itself, beside "Update the requester".
      - A new Line was drawn from there, and the Group didn't move (r2re-03).
      - Dragging the Group down by its title moved the new Line and the Group's existing Line ("Oldest first") by the same 44px. The outside Line stayed put (r2re-04).
      - After Done and publishing, the reading view draws the new Line inside the Group (r2re-05-read-v5).
    - Tests: lineHits.test.tsx covers clicking a shape under a curved Line and drawing a Line from inside a Group.
    Observation: pressing Line and drawing inside the Group made the Group 4px taller at the top. While it was that tall, the connection from "Raise the incident" into the Group detoured round to the Group's left side. It went back to the top once the Group was moved (r2re-03 vs r2re-04).
    Screenshots: ~/compass-uat/s6y6p7g/COM-1981/
assignee: steve
label:
- bug
priority: high
task_status: done
---
Pre-UAT round 2 (tester B, staging cbacf0c2), COM-1955:
- **Curved Line blocks clicks:** make a Line Curved and bend it over shapes; clicking the middle of a shape inside the area it encloses selects the Line. The line's path takes pointer events across its whole filled area. Screenshot: ~/compass-uat/s6y6p7g/COM-1955/r2-10-click-on-text-selects-line.png
- **Can't draw inside a Group:** click Line, then drag starting inside a Group: the Group moves instead of a Line being drawn. Only the short click-added Line can be put in a Group. Screenshot: COM-1955/r2-05a-after-second-draw.png

**Done when**
- A Line (any route) is picked only by a click on or within a few pixels of its stroke, its handles or its label; shapes under its curve are clickable.
- After pressing Line, a drag starting anywhere, including inside a Group or over a shape, draws the Line (and a Line drawn inside a Group moves with it).
- Tests cover clicking a shape under a curved Line and drawing a Line from inside a Group.

Independent: frontend canvas.