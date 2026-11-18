---
id: 01M7QE35J7NMN0GXP2XVV5WS20
created: 2026-11-18T13:38:43.911323Z
updated: 2026-11-18T17:03:48.362184Z
type: task
title: Arrowheads on the flowchart canvas are as big as on the finished picture
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1958
sprint: s6y6p7g
comments:
- id: 01M7QSTJY38AMD0ABDSSYT5927
  author: Steve Vine
  at: 2026-11-18T17:03:45.603389Z
  text: |-
    Done — PR #1945, merged 68d6d9b9 (plus #1947, e6f14f89, a one-line fix after it crossed with COM-1951).
    Arrowheads on the canvas are now the finished picture's own arrowhead, the same size against their line and the shapes (eight line-widths long).
    They zoom with the canvas, and don't grow when a line is selected.
    They follow a line's weight: a thick line has a bigger arrowhead, the same on the canvas and in the picture (COM-1944 adds the weight choice).
    Canvas lines are now drawn as thick as in the picture.
    The finished picture, reading view, PDF, Word and downloads are unchanged.
    To check on staging: open a flowchart's canvas at 100% and compare an arrowhead with the same one in the reading view.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Steve, testing on staging, 2026-11-18: arrowheads are very small on the canvas (edit view). On the finished diagram (reading view, PDF, Word, downloads) their size is fine.

**Done when**
- At 100% zoom, arrowheads on the canvas are the same size, relative to the shapes and lines, as on the finished picture. Editing matches what readers will see.
- They scale with zoom like everything else on the canvas.
- They scale with line weight too (COM-1944: thin, normal, thick), the same way on the canvas and in the picture.
- The finished picture, reading view, PDF, Word and downloads stay exactly as they are now.
- A test checks the canvas arrowhead size matches the picture's for each line weight.

Independent: frontend.