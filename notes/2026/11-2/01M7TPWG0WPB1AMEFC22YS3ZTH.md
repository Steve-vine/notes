---
id: 01M7TPWG0WPB1AMEFC22YS3ZTH
created: 2026-11-19T20:10:05.72418Z
updated: 2026-11-19T21:01:19.376541Z
type: task
title: A picture or diagram's resize handle sits on its bottom-right corner and follows it as it resizes
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1997
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: high
task_status: active
---
Steve's smoke test of round 2: in the document editor, images and diagrams have a round handle on the frame for resizing. As you shrink the picture, the handle doesn't move up with it, so it ends up below the now smaller picture.

Likely cause: the handle is placed halfway down the whole frame (richtext.css .rt-picture-resize, top: 50%). The frame is the picture, its caption and the alignment settings below it, not just the picture.

**Done when**
- The resize handle sits on the picture's bottom-right corner, on the image itself, not on the caption or settings below it.
- The handle stays on that corner throughout a drag, growing and shrinking, and afterwards. It never drifts below or away from the picture.
- Dragging the corner resizes the picture and keeps its proportions. The cursor is the diagonal resize cursor.
- This works for every kind: uploaded images, drawings (Excalidraw), text diagrams, and flowcharts once COM-1998 adds their handle. It works with every alignment (left, centre, right, full width) and with or without a caption.
- The size is still saved as before and shows the same in the reading view, PDF and Word.
- Tests cover the handle being at the picture's corner before, during and after a resize, with a caption.

Independent: frontend document editor only.