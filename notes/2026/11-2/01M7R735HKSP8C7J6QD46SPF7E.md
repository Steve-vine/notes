---
id: 01M7R735HKSP8C7J6QD46SPF7E
created: 2026-11-18T20:55:38.291985Z
updated: 2026-11-18T22:31:52.369723Z
type: task
title: 'Flowchart lane colour picker: Escape just closes it; words on a Transparent shape stay readable on the dark canvas'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1979
sprint: s6y6p7g
comments:
- id: 01M7R9JTX4EXY3TSAJJRGZEY1R
  author: Steve Vine
  at: 2026-11-18T21:39:08.835948Z
  text: |-
    Done — PR #1962, merged 59c666c8.
    - Escape in any flowchart colour picker now closes just the picker: lane header, background and name colour, a shape's fill and border, a line, and words. The canvas stays open and "Leave without keeping your changes?" no longer appears. With no picker open, Escape still offers to leave, as before.
    - On the canvas, the automatic word colour on a Transparent shape (and on Text) is now read against what is actually behind it. On a lane with its own background colour, the words turn light or dark to read on that colour, as they do in the picture. With no lane colour, they take the canvas's own word colour: light on the dark canvas, dark on the light one. A chosen word colour is kept.
    - A lane whose background is set to Transparent counts as having no lane colour, in the picture too.
    Assumption: a Group with a Transparent fill keeps today's behaviour; this task names shapes and Text only.
    To check on staging:
    - nothing selected, a lane's paint-brush ▸ Background ▸ any colour, then Escape: only the picker closes
    - a pale lane (#fff3bf) with a Transparent step and a Text in it, on the dark canvas: the words are dark and easy to read, matching the picture
- id: 01M7RCKC9HN705BPV1N4BQ9G3F
  author: Steve Vine
  at: 2026-11-18T22:31:52.369538Z
  text: |-
    Pre-UAT on staging d6c281fe — Passed
    Flowcharts: "E2E pre-UAT COM-1952 lane colours" (now v5) and "E2E pre-UAT COM-1954 COM-1955 COM-1956 group line text" (free Lines). As E2E Admin A in E2E Test Company. Driven in my own headless Chromium.
    - Escape in any colour picker closes only the picker: Passed. With nothing selected, I opened Service Desk's paint-brush and opened Header, Background and Name colour ▸ any colour, then pressed Escape, once with focus on the picker and once in the Hex code box. Each time only the picker closed. The canvas stayed open and "Leave without keeping your changes?" never appeared (r2re-01/02). The same happened for a step's Fill, Border and Text colour, a connection's Line and Text colour, and a free Line's Line and Text colour (10 more pickers, both ways). Escape with no picker open and unsaved changes still offers to leave, as before (r2re-06).
    - Automatic words on a Transparent shape and on Text read against what's behind: Passed. On the dark canvas, the Transparent "Log the call" and a new Text, "Pale lane words", in the #fff3bf Service Desk lane have dark words (#212529) and are easy to read (r2re-03). A Transparent step in the uncoloured Engineer lane gets light words on the dark canvas (r2re-04, then undone). On the light canvas, both have dark words. The picture agrees: in the reading view and the PNG/SVG download, both have #212529 words (r2re-05, r2re-dl-…).
    - Tests: pickerEscape.test.tsx covers Escape in the lane picker and a Transparent step on a pale lane on the dark canvas.
    Screenshots: ~/compass-uat/s6y6p7g/COM-1979/
assignee: steve
label:
- bug
priority: high
task_status: review
---
Pre-UAT round 2 (tester B, staging cbacf0c2), COM-1952 and COM-1942:
- **Escape:** in the editor with nothing selected, open a lane's paint-brush, then Background ▸ any colour, press Escape: the picker closes but "Leave without keeping your changes?" also appears. Escape in the shape Style panel is fine. Screenshot: ~/compass-uat/s6y6p7g/COM-1952/r2-02-escape-in-lane-picker.png
- **Transparent on dark:** give a lane a pale background (#fff3bf), make a step in it Transparent, switch the canvas to dark: the step's light words almost vanish on the pale yellow. In the picture they turn dark, as they should. Screenshot: COM-1952/r2-01-canvas-lane-colours.png

**Done when**
- Escape in any flowchart colour picker (lane header/background/name, shape, line, text) closes only the picker, never the canvas, and never asks to leave.
- Automatic word colour on a Transparent shape (and on Text) contrasts with what is actually behind it: the lane's own colour if it has one, otherwise the canvas background (light or dark). The canvas and the picture agree.
- Tests cover Escape in the lane picker and a Transparent step on a pale lane on the dark canvas.

Independent: frontend. Builds on COM-1978 (dark canvas colours).