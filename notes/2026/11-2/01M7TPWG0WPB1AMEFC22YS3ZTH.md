---
id: 01M7TPWG0WPB1AMEFC22YS3ZTH
created: 2026-11-19T20:10:05.72418Z
updated: 2026-11-20T14:05:05.116697Z
type: task
title: A picture or diagram's resize handle sits on its bottom-right corner and follows it as it resizes
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1997
sprint: s6y6p7g
comments:
- id: 01M7TVACCGMMA51RMNNY1XS9D9
  author: Steve Vine
  at: 2026-11-19T21:27:35.0563Z
  text: |-
    Done — PR #1988, merged 58a6acc5.
    A selected picture now has its round resize handle on its own bottom-right corner, on the picture itself, never by the caption or the settings under it. It stays on that corner while you drag, growing or shrinking, and afterwards.
    Dragging keeps the picture's proportions (dragging down works as well as across) and the cursor is the diagonal one. A centred picture grows on both sides, so the corner follows the pointer.
    This is one handle for every kind: uploaded images, drawings and text diagrams now; flowcharts use the same one when COM-1998 adds it. A text diagram can now be resized at all: while selected it shows its picture at its size, with the handle.
    The size is saved exactly as before, so the Read tab, PDF and Word show it as before.
    Assumptions: a Full width picture dragged smaller becomes centred at that size; a picture dragged to the column's whole width becomes Full width.
    To check on staging: resize an image, a drawing and a text diagram, each with a caption, aligned left, centre, right and full width, and with "Show as on paper" on.
- id: 01M7V3H0GDAR16YKV2BCX8Z4YN
  author: Steve Vine
  at: 2026-11-19T23:51:00.87723Z
  text: |-
    Pre-UAT on staging 7ea67f64 — Passed
    Tested as E2E Admin A, E2E Test Company, in my own document "E2E pre-UAT COM-2004 every kind of picture" (images, drawing, text diagrams, the document's own flowchart and a standalone flowchart shown in it). Headless Chromium, 1440 px window, sizes measured in pixels.
    - Handle on the picture's bottom-right corner, not on the caption/settings: Passed. For every kind with a caption, the handle's centre is exactly on the picture's corner (0 px off in both directions); the caption starts below it.
    - Stays on the corner during and after a drag, growing and shrinking: Passed. Measured at 4 points during each drag and after: 0 px off every time, for every kind and every alignment.
    - Resizes keeping proportions, diagonal cursor: Passed. Width:height stayed the same throughout (image 2.0, drawing 1.0, diagram 4.16, flowcharts 0.56/0.41). A downward-only drag resized it too (680 → 340 px wide). Cursor is nwse-resize.
    - Every kind, every alignment, with/without caption: Passed. Image, drawing, text diagram, own flowchart and standalone flowchart × Left/Centre/Right/Full width: 20 combinations. The standalone flowchart has no caption; a fresh image without a caption was also checked.
    - Size saved as before and the same in the Read tab, PDF and Word: Passed. A 50% image is 340.2×170.1 px in the editor, on the Read tab, in Word, and in the PDF (90 mm). A 40% drawing is 272 px in all of them. A 20% standalone flowchart is 136 px in the editor and on the Read tab.
    - Tests: Passed. pictureResize.test.tsx has "sits on the picture's corner, not its caption, before, during and after a drag".
    Observation (it belongs to COM-1998/2004): a flowchart can be dragged bigger than its own size. The larger share is saved (e.g. 60%), but the picture stays at its own size. The handle stays on the picture's real corner.
    Screenshots: ~/compass-uat/s6y6p7g/COM-1997/ (r3-image-caption-mid-drag.png, r3-*-centre-after-drag.png)
assignee: steve
label:
- bug
priority: high
task_status: done
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