---
id: 01M7R61QYH37W55T8KXX1H5JFY
created: 2026-11-18T20:37:23.02594Z
updated: 2026-11-18T20:37:26.434299Z
type: task
title: 'Flowcharts in dark: lane names line up on a standalone flowchart''s reading view, and canvas lines are easy to see'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1978
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: high
task_status: todo
---
Pre-UAT round 2 (tester A, staging cbacf0c2), COM-1953/1959/1947:
- **Lane names misaligned (defect):** in Compass's dark colour scheme, a laned standalone flowchart's Read tab gives the picture a 4px white frame, but the lane-name boxes are placed as if it had none: about 4px up and left and slightly too wide (243 vs 241px), so heading borders are doubled and separators offset. Seen on two flowcharts incl. "E2E pre-UAT COM-1927 laned standalone flowchart". A flowchart shown in a document, full screen, and light are fine. Screenshots: ~/compass-uat/s6y6p7g/COM-1959/r2-05-DEFECT-read-dark-misaligned-zoom.png, r2-04-read-dark.png, r2-08-standalone-1927-dark.png
- **Pinned name tail:** with lane names pinned on the canvas, the end of the real name shows beside the pinned box ("k", "rd").
- **Faint dark canvas:** on the dark canvas (COM-1947) lines and arrowheads are #3e3e3e on #141414 (about 1.7:1); the dark full screen's light-blue lines read much better.

**Done when**
- Lane names and their borders sit exactly on the picture's lanes in the reading view of a standalone flowchart and of a document, in light and dark, at every zoom.
- Pinned lane names on the canvas hide the real name underneath completely.
- On the dark canvas, lines, arrowheads and shape borders have at least 3:1 contrast with the background (default-coloured ones; a chosen colour is kept as chosen).
- Tests cover the reading view's lane boxes with the picture's frame, and the dark canvas line colour.

Independent: frontend.