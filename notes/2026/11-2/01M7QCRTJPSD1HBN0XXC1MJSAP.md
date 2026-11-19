---
id: 01M7QCRTJPSD1HBN0XXC1MJSAP
created: 2026-11-18T13:15:36.406103Z
updated: 2026-11-19T18:45:29.14413Z
type: task
title: 'A free-floating Line: drawn anywhere to point at something, without connecting to shapes'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1955
sprint: s6y6p7g
comments:
- id: 01M7R256W80X9YEPGD1QVEF8JK
  author: Steve Vine
  at: 2026-11-18T19:29:22.312743Z
  text: |-
    Done — PR #1951, merged b52d4de1.
    - Line joins the bar. Clicking it puts a short Line in the middle of the view, selected; a drag on the canvas straight after draws it from where the drag starts to where it ends (Escape keeps the short one).
    - Selected, it has a handle at each end, plus one to move a Right-angled Line's bend or to bend a Curved one. Drag the line itself to move it; the arrow keys nudge it; copy, paste and Delete work as for connections. Its ends never attach: one dropped on a shape stays where it fell, and moving shapes never moves a Line.
    - The Style panel's line options apply (Straight with an arrow at the end by default, plus route, arrows, pattern, weight, colour and label font). The label is set in its panel.
    - It sits on no lane. One drawn inside a Group moves with that Group, and Tidy up leaves every Line where it is.
    - Reading view, PDF, Word and downloads draw it with its style and label. The plain-text steps never change; its label is read with the notes, so search finds it. Compare versions names Lines added, removed or relabelled.
    - Polaris keeps a flowchart's Lines when it changes the flowchart, and can add Lines pointing at a step, or remove them. Loose lines from draw.io come in as Lines where they were drawn; from Lucidchart (which has no positions), as Lines pointing at their shape.
    Assumptions: the label is edited in the Line's panel, not by double-click on the canvas. Polaris places a new Line beside the step it points at, since it has no positions to work with.
    To check on staging: draw a Line onto a step, switch it to Curved and drag its bend, then move the step (the Line stays put). Draw one inside a Group and move the Group. Check the PDF and the plain-text export.
- id: 01M7R710JV55T9RCGWFDJR7Y1T
  author: Steve Vine
  at: 2026-11-18T20:54:27.675076Z
  text: |-
    Pre-UAT on staging cbacf0c2 — Failed
    Flowchart: "E2E pre-UAT COM-1954 COM-1955 COM-1956 group line text". Also a Lucidchart import of my own small CSV into "E2E pre-UAT COM-1955 Lucidchart loose line import". As E2E Admin A in E2E Test Company.
    - Drawn by dragging, moved, ends and bend reshaped, styled, labelled, deleted: Passed, with one defect.
      - Drawing: clicking Line put a short selected Line in view, and a drag on blank canvas straight after drew it from a free point onto "Close the incident". It defaults to Straight with an End arrow.
      - Styling: I made it Curved, Dashed, Thick and Primary, labelled "Check this one" in its panel.
      - Reshaping: dragging the bend handle bent it. Dragging its start handle onto "Start" moved that end.
      - Moving and deleting: two ArrowLeft presses nudged it 20px. Delete removed it and Undo brought it back. Copy and paste duplicated it.
      - Defect: after clicking Line, a drag that starts inside a Group moves the Group instead of drawing the Line (r2-05a-after-second-draw.png). The only way to get a Line into a Group was the click-added short Line.
    - Never attaches; moving shapes never moves it: Passed. With an end dropped inside "Close the incident" and another on "Start", moving either step left the Line where it was (r2-03-step-moved-line-stays.png). A Line inside the Group ("Oldest first", both arrows, dotted) moved with the Group, and the outside Line didn't.
    - Curved Line blocks clicks: Failed. A Curved Line catches clicks across the whole area between its curve and the straight line joining its ends. Clicking the middle of the Text, or of "Work the oldest ticket", under that area selects the Line, not the shape (r2-10-click-on-text-selects-line.png). Steps: draw a Line, make it Curved, bend it over a shape, then click the shape. Technical: .fc-line-path has pointer-events: all.
    - Canvas, reading view, PDF, Word and downloads, and the steps unchanged: Passed (r2-14-read-light.png and r2-group-v3-p2.png in COM-1954, r2-dl-…). The numbered steps are unchanged. The labels are listed after them as "Note: Check this one" and "Note: Oldest first", and site search finds both.
    - Loose lines from draw.io and Lucidchart come in as Lines: Passed. draw.io: "look here" came in where it was drawn, and the summary says "Lines with a loose end, brought in as Lines…" (COM-1954/r2-18/19). Lucidchart: a line with no destination came in as a Line "see this" pointing at its shape (r2-11/12).
    Observations: a bent Line's label can sit right on top of a step's words (r2-04-line-bent.png). In the picture the Line's label has no white background, unlike connection labels. Compare names Lines added, but not a later change to a Line label's style.
    Screenshots: ~/compass-uat/s6y6p7g/COM-1955/
- id: 01M7RCMTGTZ8BWRFTT4QK8P57F
  author: Steve Vine
  at: 2026-11-18T22:32:39.706511Z
  text: |-
    Re-check on staging d6c281fe: both failed points now Passed.
    - Shapes under a Curved Line's bend ("Work the oldest ticket", the Text) select on click. Only the line itself (within about 4px), its label and its handles pick the Line.
    - After pressing Line, a drag that starts inside a Group draws the Line, and the Group stays put. Moving the Group then moves that Line with it.
    Also from round 2's observations: Compare versions now names a Line label's style change. Details and screenshots under COM-1981 (~/compass-uat/s6y6p7g/COM-1981/).
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Steve, testing on staging, 2026-11-18: create a new shape called Line. It's the same as a connector, but free-floating and without connection points, so an author can point at something without connecting things.

**What the author sees**
- **Drawing one:** Line joins the shape buttons. Choose it, then drag on the canvas from where the line starts to where it ends. Clicking Line with nothing to drag adds a short line in the middle of the view (COM-1946's rule).
- **Never attached:** a Line's ends don't snap to or attach to shapes. Dropping an end on a shape just leaves it there. Moving a shape never moves a Line, and a Line never moves shapes.
- **Selecting and changing it:**
  - A selected Line shows a handle at each end to drag. The whole line can be dragged, nudged with the arrows or Shift + arrow (COM-1943), copied, pasted and deleted.
  - It takes the connection styles (COM-1944): Straight, Right-angled (one bend, with a handle to move it) or Curved (with a handle to bend it), arrows at either, both or no end, solid, dashed or dotted, weight, and colour (COM-1942).
  - It defaults to straight with an arrow at the end point.
  - It can have an optional label, placed along it and kept readable, edited by double-click (COM-1941).
- **Lanes and groups:** a Line sits on the canvas, not in a lane. If drawn inside a Group (COM-1954), it moves with that Group.
- **Tidy up:** a Line keeps its place relative to the canvas (or its Group), and laid-out lines are never routed around it.

**What a reader sees**
- **Pictures:** the reading view, PDF, Word and downloads show each Line with its style and label.
- **Meaning:** a Line is drawing only. It isn't a step or a connection, and it doesn't appear in the plain-text steps, search or Polaris's reading of the flow, so the steps in words never change because of one. A Line's label is kept with the flowchart's notes, so search can still find its words.
- **Compare versions:** it mentions Lines added or removed.

**Elsewhere**
- **Imports:** a draw.io or Lucidchart line with a loose end, which those imports currently list as "not carried over", now comes in as a Line instead.
- **Polaris** can add or remove a Line when asked.

**Done when**
- A Line can be drawn by dragging, moved, reshaped by its end and bend handles, styled, labelled and deleted.
- It never attaches to shapes, and moving shapes never moves it.
- It shows the same on the canvas, in the reading view, PDF, Word and downloads, and never changes the plain-text steps.
- Loose lines from draw.io and Lucidchart imports come in as Lines.
- Tests cover drawing, the handles, not attaching, the styles, and the plain text staying the same.

On the chain: the stored flowchart gains a new kind of item, which the server checks. Build it after COM-1944 (line styles), which it reuses.