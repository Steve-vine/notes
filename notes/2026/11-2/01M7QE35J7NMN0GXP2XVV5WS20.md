---
id: 01M7QE35J7NMN0GXP2XVV5WS20
created: 2026-11-18T13:38:43.911323Z
updated: 2026-11-19T18:45:29.338555Z
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
- id: 01M7R5Y2TB9JG4PKW9H69HXAR2
  author: Steve Vine
  at: 2026-11-18T20:35:23.083434Z
  text: |-
    Pre-UAT round 2 on staging cbacf0c2 — Passed
    As E2E Admin A on "E2E pre-UAT COM-1945 canvas round 2". I set one line to Thin and one to Thick, and left the rest Normal.
    - Canvas arrowheads the same size as the picture's at 100%: Passed. On the canvas each arrowhead is 8 line-widths long: Thin 1px gives 8, Normal 1.5px gives 12, Thick 2.5px gives 20. The downloaded SVG uses the same arrowhead at 8 × the line width, and the same line widths (1 / 1.5 / 2.5).
    - Arrowheads scale with zoom: Passed. They are drawn in canvas units, so they zoom with the shapes; checked at about 0.8× and at 2×.
    - Arrowheads scale with line weight, the same on canvas and picture: Passed. The thick line has a visibly bigger arrowhead on the canvas, in the reading view and in the PDF. Selecting a line thickens the line, but its arrowhead stays the same size.
    - Picture, reading view, PDF, Word and downloads unchanged: Passed. Arrowheads look as before in the PDF and Word exports (r2-v1.pdf, r2-v1.docx in COM-1945/).
    - Tests: Passed. arrows.test.tsx on main (COM-1958).
    Screenshots: ~/compass-uat/s6y6p7g/COM-1958/ (r2-*)
assignee: steve
label:
- bug
priority: medium
task_status: done
---
Steve, testing on staging, 2026-11-18: arrowheads are very small on the canvas (edit view). On the finished diagram (reading view, PDF, Word, downloads) their size is fine.

**Done when**
- At 100% zoom, arrowheads on the canvas are the same size, relative to the shapes and lines, as on the finished picture. Editing matches what readers will see.
- They scale with zoom like everything else on the canvas.
- They scale with line weight too (COM-1944: thin, normal, thick), the same way on the canvas and in the picture.
- The finished picture, reading view, PDF, Word and downloads stay exactly as they are now.
- A test checks the canvas arrowhead size matches the picture's for each line weight.

Independent: frontend.