---
id: 01M7WMCHVNQGEBXA62760BVFAK
created: 2026-11-20T14:04:55.029608Z
updated: 2026-11-20T14:18:57.990917Z
type: task
title: Drag the Line onto the flowchart canvas, like every other shape
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2021
sprint: s6y6p7g
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Steve (testing round 3): every shape in the left-hand bar can be dragged onto the canvas except the Line, which has to be clicked. Make the Line draggable too.

**Done when**
- Dragging Line from the left-hand bar and dropping it on the canvas puts a line where it was dropped, at a sensible default length, with both ends ready to attach to shapes.
- Dropping a line's end on or near a shape's connection point attaches it, as when a line is drawn now.
- Clicking Line still works as it does today.
- One drop is one Undo step.
- The drag preview looks the same as the other shapes' previews.
- Tests cover dragging a Line onto the canvas.