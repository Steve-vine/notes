---
id: 01M7R73V0X4RHCAPG5PA27WTD2
created: 2026-11-18T20:56:00.285095Z
updated: 2026-11-18T20:56:43.077713Z
type: task
title: 'A free flowchart Line: a curved one only catches clicks on the line itself, and one can be drawn starting inside a Group'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1981
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: high
task_status: active
---
Pre-UAT round 2 (tester B, staging cbacf0c2), COM-1955:
- **Curved Line blocks clicks:** make a Line Curved and bend it over shapes; clicking the middle of a shape inside the area it encloses selects the Line. The line's path takes pointer events across its whole filled area. Screenshot: ~/compass-uat/s6y6p7g/COM-1955/r2-10-click-on-text-selects-line.png
- **Can't draw inside a Group:** click Line, then drag starting inside a Group: the Group moves instead of a Line being drawn. Only the short click-added Line can be put in a Group. Screenshot: COM-1955/r2-05a-after-second-draw.png

**Done when**
- A Line (any route) is picked only by a click on or within a few pixels of its stroke, its handles or its label; shapes under its curve are clickable.
- After pressing Line, a drag starting anywhere, including inside a Group or over a shape, draws the Line (and a Line drawn inside a Group moves with it).
- Tests cover clicking a shape under a curved Line and drawing a Line from inside a Group.

Independent: frontend canvas.