---
id: 01M7R61QYH37W55T8KXX1H5JFY
created: 2026-11-18T20:37:23.02594Z
updated: 2026-11-18T22:35:37.716387Z
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
- id: 01M7RCT8BM8NK02EPRNXES3S5P
  author: Steve Vine
  at: 2026-11-18T22:35:37.716194Z
  text: |-
    Pre-UAT on staging d6c281fe — Passed
    As E2E Admin A, Colour scheme ▸ Dark. I measured each lane-name box's border against the lane lines in the picture underneath.
    - Lane names sit exactly on the picture's lanes in the reading view, light and dark, at every zoom: Passed.
      - "E2E pre-UAT COM-1945 canvas round 2" (v4, Left to right) Read tab in dark. The 4px white frame is still there, and the boxes now allow for it. At fit every edge is within 0.6px of the picture's lines, with no doubled heading border (r2re-01). In round 2 they were about 4px off.
      - Zoomed in 3 steps (up to 1.7×): one line under each heading, no step at the separators (r2re-02…04).
      - "E2E pre-UAT COM-1927 laned standalone flowchart" in dark: within half a pixel at zoom 1 (r2re-07). Zoomed to 7×, each heading shows one border, lined up with the picture (r2re-08).
      - The flowchart shown in "E2E pre-UAT COM-1927 document showing a standalone flowchart", dark: within half a pixel (r2re-14).
      - Light gives the same readings as dark at the same zoom (r2re-06).
    - Pinned lane names hide the real name completely: Passed. Dark canvas, zoomed in, panned in 20px steps from fully pinned until the real heading came back. No end of "Service desk" or "Change board" showed beside the pinned box at any step (r2re-12-pinned-step0…5, montage r2re-13).
    - Dark canvas lines, arrowheads and shape borders have at least 3:1 contrast: Passed. Lines, arrowheads and default shape borders are light blue rgb(139,188,239). That's 8.8:1 on the canvas (rgb 22,24,38) and about 8:1 on the dark lane fill, and clearly visible (r2re-09, r2re-10). The light canvas now draws lines in blue too, by design.
    - Tests: Passed. readFrame.test.tsx, canvasScheme.test.tsx and laneEdges.test.tsx on main (COM-1978).
    Observation, not a defect: at 1.7× zoom a heading's lane-boundary border is drawn 1px thick, while the picture's line beneath is about 1.7px. So the heading line sits on the upper half of the body separator (~1px), in light and dark alike (r2re-04 at 4×). There's no visible doubling at normal sizes.
    Screenshots: ~/compass-uat/s6y6p7g/COM-1978/ (r2re-*)
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