---
id: 01M7QE35J7NMN0GXP2XVV5WS20
created: 2026-11-18T13:38:43.911323Z
updated: 2026-11-18T15:32:47.574238Z
type: task
title: Arrowheads on the flowchart canvas are as big as on the finished picture
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1958
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: medium
task_status: active
---
Steve, testing on staging, 2026-11-18: arrowheads are very small on the canvas (edit view). On the finished diagram (reading view, PDF, Word, downloads) their size is fine.

**Done when**
- At 100% zoom, arrowheads on the canvas are the same size, relative to the shapes and lines, as on the finished picture. Editing matches what readers will see.
- They scale with zoom like everything else on the canvas.
- They scale with line weight too (COM-1944: thin, normal, thick), the same way on the canvas and in the picture.
- The finished picture, reading view, PDF, Word and downloads stay exactly as they are now.
- A test checks the canvas arrowhead size matches the picture's for each line weight.

Independent: frontend.