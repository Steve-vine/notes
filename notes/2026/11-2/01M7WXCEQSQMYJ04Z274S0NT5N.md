---
id: 01M7WXCEQSQMYJ04Z274S0NT5N
created: 2026-11-20T16:42:09.017598Z
updated: 2026-11-20T19:17:44.766545Z
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
- id: 01M7X69BNYGT3A4J0BX0FC2HPM
  author: Steve Vine
  at: 2026-11-20T19:17:44.766376Z
  text: |-
    Re-check on staging 514c4649: Passed
    All checks done as E2E Admin A in E2E Test Company, in a new document "E2E pre-UAT COM-2029 lane keeps connections" (Procedure). I measured where each line meets its shapes on the canvas, and in the saved flowchart.
    - Adding the first lane: Passed. First test: Start → Step A → Step B, tidied, then Add lane. The shapes sat in the lane, and both lines still met the middles of the shapes. (r4re-01, r4re-02)
    - The case that used to fail: Passed. In a second flowchart, I moved the last shape 70 px left so the shapes didn't sit where a lane puts them. Adding a lane then moved every shape 60 px right, and the lines moved with them. Every line still starts and ends at the middle of its shapes. Saved: Begin here x=80 w=160, and its line leaves at x=160. (r4re-14, r4re-15)
    - Resizing, reordering and removing a lane: Passed. With a second lane and Step B dragged into it, the line Step A → Step B was redrawn to Step B's top middle. Widening Lane 1 by 80 px moved Step B 80 px, and its line end moved with it. Swapping the lanes kept every line on its shapes. So did removing Lane 2 with "Move them to another lane". One Undo of each brought it all back. (r4re-03 to r4re-07)
    - A connection end fixed to a point (COM-1996): Passed. I dragged the end of Begin here → Fixed end target to a quarter of the way along the target's top. It's saved as to_port top at 0.25. After adding a lane it was still at that point: saved x=120 = 80 + 0.25×160. (r4re-11, r4re-15)
    - Undo: Passed. One Undo after adding the first lane removed the lane and put the shapes and lines back exactly where they were (same paths). Redo brought them back. (r4re-13, r4re-16)
    - Picture, PDF and Word: Passed. After Done, the PDF (pages 2 and 3) and the Word file's pictures show every line meeting its shapes. Both show the fixed end at the quarter point. (r4re-doc.pdf, r4re-doc-pdf-p2/p3.png, r4re-doc.docx, r4re-docx-img2/3.png)
    - Test: Passed. laneLines.test.ts covers adding the first lane, a fixed end, resizing, moving and removing lanes, and a one-step Undo.
    Observation (not this task): a shape dropped so that it overhangs a lane's edge keeps that overhang when lanes are resized, swapped or removed. Step B stayed 20 px over the lane boundary, which shows in the PDF. It's how I dropped it, not something the fix did.
    Screenshots: ~/compass-uat/s6y6p7g/COM-2029/ (r4re-*)
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