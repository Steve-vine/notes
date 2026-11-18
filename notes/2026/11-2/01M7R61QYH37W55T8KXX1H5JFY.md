---
id: 01M7R61QYH37W55T8KXX1H5JFY
created: 2026-11-18T20:37:23.02594Z
updated: 2026-11-18T21:17:46.378517Z
type: task
title: 'Flowcharts in dark: lane names line up on a standalone flowchart''s reading view, and canvas lines are easy to see'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1978
sprint: s6y6p7g
comments:
- id: 01M7R8BNENN6Q50TN0X4YSWX74
  author: Steve Vine
  at: 2026-11-18T21:17:45.301604Z
  text: |-
    Done — PR #1957, merged 4a5cf5ba.
    - In Compass's dark colour scheme, a laned flowchart's lane names (and their borders) now sit exactly on the picture's lanes in the Read tab of a standalone flowchart and in a document, at every zoom. The light frame round the picture no longer pushes them up and left. The same goes for the clickable spots over linked steps. Light was already right and is unchanged.
    - On the canvas, a pinned lane name now covers the whole of the lane's heading still on screen, so no end of the real name shows beside it. A heading made Transparent pins on the canvas background.
    - On the canvas, lines, arrowheads and free Lines without a colour of their own are now drawn in the same blue as the shape borders, as the finished picture draws them. On the dark canvas that's a light blue on the dark background (well over 3:1); before it was dark grey on near-black. A line given its own colour keeps it, and a selected line shows in the selection colour.
    Assumptions: lines without a colour of their own are also blue on the light canvas (before they were a pale grey), matching the picture; a selected line shows in the selection colour, as a selected shape does.
    To check on staging, in dark:
    - a laned standalone flowchart's Read tab, zoomed in and out: no doubled heading borders
    - the canvas zoomed in and panned so the lane names pin: no tail of the real name
    - the dark canvas lines and arrowheads are clearly visible
assignee: steve
label:
- bug
priority: high
task_status: review
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