---
id: 01M7V3WFDRRN2MF3FPAE7NXXB9
created: 2026-11-19T23:57:16.600963Z
updated: 2026-11-20T00:09:13.878031Z
type: task
title: A shape added from the left bar always lands in view
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2015
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: medium
task_status: active
---
Found in pre-UAT of round 3, by Tester A on staging 7ea67f64, after COM-1993. Round 2's COM-1946 promised that a clicked shape lands in view.

**Steps:** select a shape near the bottom of the view, then click a shape on the left bar.

**Seen:** the new shape is added below the selected one, and the view doesn't follow when it lands off screen.

**Done when**
- A shape added by clicking the bar, or by Tab ("add a step after"), always ends up in view. If it lands off screen, the view pans just enough to show it, and it is selected, ready to type its label.
- Dragging from the bar is unchanged.
- Tests cover a click-add after a shape at the bottom edge of the view, ending in view.

Independent: frontend only.