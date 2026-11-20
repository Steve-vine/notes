---
id: 01M7V3WFDRRN2MF3FPAE7NXXB9
created: 2026-11-19T23:57:16.600963Z
updated: 2026-11-20T00:32:11.913378Z
type: task
title: A shape added from the left bar always lands in view
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2015
sprint: s6y6p7g
comments:
- id: 01M7V5W6WW99S0WDCHBF9AGCQ3
  author: Steve Vine
  at: 2026-11-20T00:32:05.020082Z
  text: |-
    Done — PR #2006, merged 282ab8fec.
    A shape you click in from the left bar, or a step you add with Tab, now always ends up on screen. If it would land off the edge, the canvas pans just enough to show it, a little way in from the edge and at the same zoom. It is selected and ready for you to type its label.
    A shape that already lands in view leaves the view where it was. Dragging a shape in from the bar works as before.
    Assumption: the pan is instant, not animated, so you can start typing straight away.
    To check on staging: select a shape near the bottom of the canvas and click Step on the left bar, then press Tab. Each time, the new shape should come into view, selected, ready to type.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Found in pre-UAT of round 3, by Tester A on staging 7ea67f64, after COM-1993. Round 2's COM-1946 promised that a clicked shape lands in view.

**Steps:** select a shape near the bottom of the view, then click a shape on the left bar.

**Seen:** the new shape is added below the selected one, and the view doesn't follow when it lands off screen.

**Done when**
- A shape added by clicking the bar, or by Tab ("add a step after"), always ends up in view. If it lands off screen, the view pans just enough to show it, and it is selected, ready to type its label.
- Dragging from the bar is unchanged.
- Tests cover a click-add after a shape at the bottom edge of the view, ending in view.

Independent: frontend only.