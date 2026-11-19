---
id: 01M7QAEN6TWW61SXNAT9D2KD7X
created: 2026-11-18T12:35:06.074155Z
updated: 2026-11-19T18:45:28.818617Z
type: task
title: Flowchart shapes can be resized, and a shape's text is never hidden
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1940
sprint: s6y6p7g
comments:
- id: 01M7QY1VC36WN10Z9SCE5H16MT
  author: Steve Vine
  at: 2026-11-18T18:17:37.923695Z
  text: |-
    Done — PR #1948, merged fe4369d6.
    A selected shape now has handles on its corners and edges: drag to make it wider, narrower, taller or shorter, and hold Shift to keep its proportions.
    A shape won't go smaller than the size that still shows its whole label, wrapped, in its own text size.
    Typing a longer label grows the shape. A shape at its first size may widen first, as Tidy up does. A shape you've resized keeps its width and grows taller.
    Lines re-route around the new size, and only the lines that need to (COM-1945). A lane grows to hold a bigger shape, and the lanes after it move along.
    Tidy up keeps a size you chose. Each resize is one Undo.
    The canvas now draws a shape's words exactly as the finished picture does, so nothing is hidden while editing, in the reading view, PDF, Word or downloads.
    Assumptions: "resized by you" means the shape is no longer its first width (nothing extra is stored). Lanes grow to hold a shape but don't shrink back when it's made smaller. Groups keep their own resizing (COM-1954).
    To check on staging: resize every shape kind from a corner and an edge; type a long label into a resized shape; resize a shape inside a lane until the lane grows.
- id: 01M7R5Y9M5JXN133ZFZRRPJ79E
  author: Steve Vine
  at: 2026-11-18T20:35:30.053178Z
  text: |-
    Pre-UAT round 2 on staging cbacf0c2 — Passed
    As E2E Admin A on "E2E pre-UAT COM-1945 canvas round 2".
    - Every shape can be resized by dragging, and the size is kept: Passed.
      - A selected shape shows 4 corner handles and 4 edge handles.
      - Start/End, Step, Decision, Document, Input/Output, Hand-off and Note all resized from an edge, and each resize was one Undo.
      - Shift keeps proportions: 70×40 grew to 120×69.
      - Sizes were kept after Done, publishing (v1, v2) and reopening, and after Tidy up (Log the request stayed 120×69, the decision 140×214).
    - Minimum size: Passed. Dragging "Log the request" far inwards stopped at 70×40, with the label wrapped onto 2 lines inside the shape.
    - No label hidden: Passed.
      - Typing a long label into the decision ("Approved by the change advisory board and the service owner?") grew it from 90 to 214 tall while typing, with every word inside.
      - The multi-line step label and all others are whole on the canvas, after Tidy up, in the reading view, the PDF, Word, and the PNG/SVG downloads.
    - Lines and lanes adjust: Passed. Resizing re-routed only the shape's own lines. Making a step 280 tall grew the Change board lane from 360 to 420, and Undo put both back.
    - Tests: Passed. size.test.tsx on main (COM-1940).
    Observations (not defects):
    - Holding Shift BEFORE pressing on a corner handle starts a box-selection instead: the shape is deselected and nothing resizes. Shift only keeps proportions when pressed after the drag has started.
    - Widening a shape until it touches its neighbour leaves its connection as a tiny hook back through the shape, and that connection's label disappears. Nothing pushes the neighbour along (r2-02-widened.png).
    Screenshots: ~/compass-uat/s6y6p7g/COM-1940/ (r2-*)
assignee: steve
label:
- improvement
priority: high
task_status: done
---
Steve, testing on staging, 2026-11-18: shapes on the flowchart canvas can't be resized, so once a label no longer fits its shape the text becomes invisible.

**What the author sees**
- A selected shape shows resize handles on its corners and edges. Dragging them makes it wider, narrower, taller or shorter. Hold Shift to keep its proportions.
- A shape can't be made too small for its label: it stops at the size that still shows the whole label, wrapped.
- Typing a longer label grows the shape to fit, so text is never cut off or hidden. A shape the author has resized keeps its width, and grows taller instead.
- Connections and lanes follow the new size: lines re-route around it, and a lane grows to hold a larger shape.
- Tidy up keeps a size the author chose, rather than resetting it.
- Resizing is one undoable change.

**What a reader sees**
- The reading view, PDF, Word and downloaded pictures show each shape at its size with its whole label.

**Done when**
- Every shape (Start/End, Step, Decision, Document, Input/Output, Hand-off, Note) can be resized by dragging, and the size is kept after Done, publishing and reopening.
- No label is ever hidden or cut off: not while typing, after resizing, after Tidy up, or in the reading view, PDF, Word or downloads.
- Lines and lanes adjust to the new size.
- Tests cover resizing, the minimum size and a label that outgrows its shape.

Independent: frontend (the chart already stores each shape's size).