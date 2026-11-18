---
id: 01M7R735HKSP8C7J6QD46SPF7E
created: 2026-11-18T20:55:38.291985Z
updated: 2026-11-18T21:17:55.525838Z
type: task
title: 'Flowchart lane colour picker: Escape just closes it; words on a Transparent shape stay readable on the dark canvas'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1979
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: high
task_status: active
---
Pre-UAT round 2 (tester B, staging cbacf0c2), COM-1952 and COM-1942:
- **Escape:** in the editor with nothing selected, open a lane's paint-brush, then Background ▸ any colour, press Escape: the picker closes but "Leave without keeping your changes?" also appears. Escape in the shape Style panel is fine. Screenshot: ~/compass-uat/s6y6p7g/COM-1952/r2-02-escape-in-lane-picker.png
- **Transparent on dark:** give a lane a pale background (#fff3bf), make a step in it Transparent, switch the canvas to dark: the step's light words almost vanish on the pale yellow. In the picture they turn dark, as they should. Screenshot: COM-1952/r2-01-canvas-lane-colours.png

**Done when**
- Escape in any flowchart colour picker (lane header/background/name, shape, line, text) closes only the picker, never the canvas, and never asks to leave.
- Automatic word colour on a Transparent shape (and on Text) contrasts with what is actually behind it: the lane's own colour if it has one, otherwise the canvas background (light or dark). The canvas and the picture agree.
- Tests cover Escape in the lane picker and a Transparent step on a pale lane on the dark canvas.

Independent: frontend. Builds on COM-1978 (dark canvas colours).