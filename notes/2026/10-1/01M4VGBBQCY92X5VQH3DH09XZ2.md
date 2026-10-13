---
id: 01M4VGBBQCY92X5VQH3DH09XZ2
created: 2026-10-13T20:48:01.772077Z
updated: 2026-10-13T20:48:02.543168Z
type: task
title: 'Bug: reordering roadmap entries and sprints on a project note is hit or miss'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 545
sprint: sd52non
assignee: steve
label:
- bug
priority: medium
task_status: backlog
tech: null
---
On a project note, dragging a roadmap entry or a sprint row to a new position is unreliable. Moving an item up the list:

- with the cursor directly over the border line between two other rows, the drag badge is a white cross on a green background; releasing there drops the item back where it was;
- hovering just above or below that line, the badge is a white 0 on a red background; releasing there does move the item.

Seen on 1.3.0 (macOS, WebKit).

## Where to look

- `NotePane.svelte`: `rmDragOver`/`rmDrop` (roadmap rows) and `sprintDragOver`/`sprintDrop` (sprint rows) are attached to each `.sprint` row div only. The `hr.rule-fade` separators between rows and the `.insert-line` that renders at the drop position are outside any drop target — once the line appears under the cursor it can intercept the dragover/drop the row was handling. The Editor's dragover only accepts `Files`, so it isn't the green-badge source; check what WebKit shows for `dropEffect = "move"` versus an unhandled dragover, since the badges may read the opposite way from what they suggest.

## Likely shape of the fix

- Handle dragover/drop on the list container (the section) rather than each row, deriving the insertion index from the row rects under `clientY` — the Kanban board's column idiom — so the gaps and separators are inside the drop zone.
- `pointer-events: none` on `.insert-line` (and the separators) so they never take the event.
- Same treatment for both lists; the Roadmap chart's new row reorder (NOT-543) uses the same per-row pattern and should get the same fix.