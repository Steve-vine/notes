---
id: 01M7WMCHVNQGEBXA62760BVFAK
created: 2026-11-20T14:04:55.029608Z
updated: 2026-11-20T14:48:04.975483Z
type: task
title: Drag the Line onto the flowchart canvas, like every other shape
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2021
sprint: s6y6p7g
comments:
- id: 01M7WPVGPY169J267TG0V4VH50
  author: Steve Vine
  at: 2026-11-20T14:48:02.526209Z
  text: |-
    Done — PR #2017, merged b1eecf67.
    - You can now drag Line from the flowchart editor's left-hand bar onto the canvas, like every shape. It lands where you let go: level, the same length a clicked Line has, and on the grid unless you hold Alt.
    - Once dropped it's selected with its end handles showing, ready to move. One Undo takes it back.
    - While you drag, a faint dashed outline of the line follows the pointer, in the same look as a shape's outline.
    - A Line dropped on a connection never goes into it. Only shapes do that.
    - Clicking Line still works as before: it adds one to draw by dragging on the canvas.
    Assumption: the task says a Line's end should attach to a shape when dropped near one, "as when a line is drawn now". But Lines never attach today: a Line is a free drawing, and connections are drawn from a shape's connection points (COM-1955). So a dragged-in Line behaves exactly like one added by clicking, and its ends move freely. Making Line ends attach would turn Lines into connections; if you want that, it needs its own task.
    To check on staging: drag Line from the left-hand bar onto the canvas, then press Undo.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Steve (testing round 3): every shape in the left-hand bar can be dragged onto the canvas except the Line, which has to be clicked. Make the Line draggable too.

**Done when**
- Dragging Line from the left-hand bar and dropping it on the canvas puts a line where it was dropped, at a sensible default length, with both ends ready to attach to shapes.
- Dropping a line's end on or near a shape's connection point attaches it, as when a line is drawn now.
- Clicking Line still works as it does today.
- One drop is one Undo step.
- The drag preview looks the same as the other shapes' previews.
- Tests cover dragging a Line onto the canvas.