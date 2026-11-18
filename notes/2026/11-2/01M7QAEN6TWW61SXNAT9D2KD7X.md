---
id: 01M7QAEN6TWW61SXNAT9D2KD7X
created: 2026-11-18T12:35:06.074155Z
updated: 2026-11-18T12:35:08.321025Z
type: task
title: Flowchart shapes can be resized, and a shape's text is never hidden
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1940
sprint: s6y6p7g
assignee: steve
label:
- improvement
priority: high
task_status: todo
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