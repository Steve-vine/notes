---
id: 01M7WXCEQSQMYJ04Z274S0NT5N
created: 2026-11-20T16:42:09.017598Z
updated: 2026-11-20T17:22:30.003003Z
type: task
title: Adding a lane keeps a flowchart's connections on their shapes
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2029
sprint: s6y6p7g
comments:
- id: 01M7WZP6JHJJ6RYY99ZT0XAACR
  author: Steve Vine
  at: 2026-11-20T17:22:25.489007Z
  text: |-
    Done — PR #2025, merged a1d2ce3a.
    Adding the first lane moves the shapes into it, and the connections now move with them. Every line meets its shapes at the same points as before, on the canvas and in the picture, PDF and Word.
    Resizing, reordering or removing a lane does the same. A line whose shapes moved together keeps its route. A line whose shapes moved apart, from one lane into another, is drawn again between them.
    A connection end fixed to a point on a shape stays on that point.
    Undo puts the lane, the shapes and the lines back together, in one step.
    Assumption: flowcharts already saved with off-centre lines keep them until a shape is moved or Tidy up is used. Nothing is changed when a flowchart is opened.
    To check on staging: draw Start → Step → Step, add a lane, and check the lines still meet the middles of the shapes. Then publish and look at the picture.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Found in Claude's pre-UAT round 4 (staging b65d7ed8, tester A). This is probably older than this round.

Adding a lane to a flowchart that already has connections moves the shapes about 20 px into the lane, but leaves the connections where they were. The lines then end off-centre on their shapes. This is saved, so it shows in the picture and the PDF: the saved connection is at x=80 while the shape's centre is at 100.

Screenshots: ~/compass-uat/s6y6p7g/COM-2026/r4-03-lane-header-custom5.png, r4-picture.png, r4-docA-v2-pdf-p2.png

**Done when**
- After a lane is added (or removed, or resized) to a flowchart with connections, every connection still meets its shapes at the same connection points, on the canvas and in the picture, PDF and Word.
- A connection end fixed to a point on a shape (COM-1996) stays on that point.
- Undo puts the lane, the shapes and the connections back together.
- A test covers adding a lane to a flowchart with connections.