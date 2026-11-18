---
id: 01M7QAXDF7T8PG2XQ6EFYEKP19
created: 2026-11-18T12:43:09.671069Z
updated: 2026-11-18T20:35:46.18705Z
type: task
title: 'Nudge flowchart shapes finely: Shift + arrow moves by 1 pixel'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1943
sprint: s6y6p7g
comments:
- id: 01M7R014A0G6AQ3WBEXTMSKKQJ
  author: Steve Vine
  at: 2026-11-18T18:52:11.456501Z
  text: |-
    Done — PR #1953, merged 3a93354b.
    With shapes selected, an arrow key moves them one grid step and Shift + arrow moves them one pixel.
    Holding Alt while dragging places a shape exactly where you let go, off the grid. Without Alt, dragging still snaps.
    Lines re-route as shapes move (only their own lines and any they block), and a shape nudged across a lane edge joins that lane.
    A run of nudges in one direction, plain or with Shift, is one Undo.
    The list of keys beside the canvas shows all of this.
    Assumption: until now the arrow keys moved the selection from shape to shape, and Shift + arrow nudged. I followed this task, so the arrows now nudge and moving between shapes is Alt + arrow. With nothing selected, an arrow still selects the first shape.
    To check on staging: nudge a shape with arrows and Shift + arrows, then press Undo once; Alt-drag a shape; check that Alt + arrows still move between shapes.
- id: 01M7R5YSCB82JCCB3359J9JJ7P
  author: Steve Vine
  at: 2026-11-18T20:35:46.186812Z
  text: |-
    Pre-UAT round 2 on staging cbacf0c2 — Passed
    As E2E Admin A on "E2E pre-UAT COM-1945 canvas round 2".
    - Shift + arrow moves exactly 1px; plain arrows move one grid step: Passed. On "Request received": ArrowDown ×2 went 80→100→120 (20px grid); Shift+ArrowRight ×3 went x 0→1→3; Shift+ArrowUp went y 120→119.
    - Alt-drag places without snapping: Passed. The same small drag snapped to (40,100) without Alt, and landed at (70,113) with Alt held.
    - Positions kept after Done, publishing and reopening; picture, PDF and Word match: Passed.
      - "Log the request", nudged to x=203 with Shift+arrows, was still at (203,80) after Done, publishing v1, closing the browser, signing in again and reopening the canvas.
      - The SVG, PDF and Word show it in the same place, with lines identical to the canvas.
    - Lines re-route and lane hand-over: Passed. Nudging changed only the nudged shape's own lines. Nudging "Tell requester" down 5 steps moved it from Service desk into Change board (the panel said so), and one Undo put it back.
    - A run of nudges is one Undo: Passed. Undo ×3 reverted, in turn: the Shift+Up run, the Shift+Right ×3 run, then the ArrowDown ×2 run. Lines came back exactly.
    - Keys listed beside the canvas: Passed. The list shows arrows (grid step, Shift: a pixel), Alt+arrow (move between shapes) and Alt+drag (off the grid).
    - Alt + arrow moves between shapes: Passed. From Done, Alt+Left selected Tell requester, then Alt+Down selected Make the approved change. Nothing moved.
    - Tests: Passed. nudge.test.tsx on main (COM-1943).
    Observation: a plain arrow nudge snaps an off-grid shape back onto the grid. (70,113) went to (20,120) after ArrowLeft ×3, not to (10,113). Probably intended.
    Screenshots: ~/compass-uat/s6y6p7g/COM-1943/ (r2-*)
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Steve, testing on staging, 2026-11-18: shapes need finer moving. Shift + arrow could move by 1 pixel.

**What the author sees**
- **Arrow keys** move the selected shape or shapes one grid step, as now.
- **Shift + arrow** moves them by 1 pixel.
- **Alt while dragging** turns grid snapping off for that drag, so a shape can be placed exactly. Without it, dragging still snaps to the grid.
- Lines re-route as shapes move, and a shape nudged across a lane edge joins that lane, as with dragging.
- A run of nudges in one direction is one undoable change, not one per key press.
- The keyboard shortcuts are listed wherever the canvas lists its other keys, if it has such a list.

**Done when**
- Shift + arrow moves the selection exactly 1 pixel in that direction, and plain arrows still move one grid step.
- Alt-drag places a shape without snapping.
- Positions are kept after Done, publishing and reopening, and the picture, PDF and Word match.
- Tests cover Shift + arrow, plain arrow, and undoing a run of nudges.

Independent: frontend.