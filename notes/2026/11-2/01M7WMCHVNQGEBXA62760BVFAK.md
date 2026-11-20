---
id: 01M7WMCHVNQGEBXA62760BVFAK
created: 2026-11-20T14:04:55.029608Z
updated: 2026-11-20T16:41:06.983012Z
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
- id: 01M7WXAJ573J0ZP25EK1ECWCY9
  author: Steve Vine
  at: 2026-11-20T16:41:06.982818Z
  text: |-
    Pre-UAT on staging b65d7ed8 — Passed (judged against the builder's recorded deviation on line ends)
    All checks were done as E2E Admin A in E2E Test Company, in the document "E2E pre-UAT COM-2026 Document B, COM-2021 and COM-2025".
    - Drag Line onto the canvas; it lands at the drop point at the default length, with end handles: Passed. I dropped a Line at three places, and each landed centred where I let go, snapped to the grid (dropped at 850,250, landed at 844,249). Each was the same length as a clicked Line, level, and selected with its start and end handles showing. Holding Alt dropped it exactly at the pointer, with no snap. (r4-02, r4-04)
    - A line's end attaches to a nearby shape: judged against the deviation. The builder recorded that Lines are free drawings and never attach; connections are drawn from a shape's points. I dragged a dropped Line's start onto a Step's right-hand point. It moved there and made no connection (still one connection on the canvas), which is the same as a clicked Line. A Line dropped on the middle of an existing connection didn't split it or join it. (r4-06, r4-08)
    - Clicking Line still works: Passed. Clicking it adds a Line in the middle of the canvas, selected, with "Drag on the canvas to draw it…", as before. (r4-05)
    - One drop is one Undo: Passed. I made four drops in a row (Line, Decision, Line, Step). Each Undo took back exactly the latest one, and Redo brought all four back.
    - The drag preview looks like the other shapes' previews: Passed. A headless browser can't show the drag picture, so I recorded the picture the app hands the browser. For a Line it is a faint dashed outline of the line (grey stroke, dashes 4 3, faint fill). For a Step it is the same style in the Step's outline. (r4-drag-images.txt)
    - Kept after Done: Passed. After pressing Done, the saved flowchart has all five Lines where they were dropped, and the Read tab draws them. (r4-09)
    - Tests: Passed. PR #2017 adds lineDrop.test.tsx.
    Screenshots: ~/compass-uat/s6y6p7g/COM-2021/
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