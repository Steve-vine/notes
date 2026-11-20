---
id: 01M7V3KQS7HGQRX0VC1RMFYV7W
created: 2026-11-19T23:52:30.247227Z
updated: 2026-11-20T14:05:05.252304Z
type: task
title: A picture that has never been resized is the same size in the PDF as in the editor and the Read tab
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2009
sprint: s6y6p7g
comments:
- id: 01M7V5B5R87J9XF6W2Q86RS35Z
  author: Steve Vine
  at: 2026-11-20T00:22:46.791642Z
  text: |-
    Done — PR #2002, merged f971e1705.
    A picture nobody has resized (an image, a drawing or a text diagram) now prints in the PDF and Print preview at the size the editor, the Read tab and Word show it at, not stretched across the page. A text diagram that is 300×72 on screen is 300×72 in the PDF.
    A picture wider than the page is still shrunk to the text width. Resized and Full width pictures are unchanged, and flowcharts already printed at their own size.
    Cached PDFs are made afresh after the deploy, so published documents pick it up without being republished.
    Assumption: "its own size" is the size the browser shows it at. That is the same number Word already uses.
    To check on staging: export the PDF of a document with an unresized text diagram and an unresized drawing, and compare their size with the Read tab and Word.
- id: 01M7VAPBCY0NC4QVD6HK81E2TS
  author: Steve Vine
  at: 2026-11-20T01:56:15.902363Z
  text: |-
    Pre-UAT on staging 0ed475e8 — Passed
    Tested as E2E Admin A, E2E Test Company. I made a new document, "E2E pre-UAT COM-2009 unresized pictures", with nothing resized: a 300×150 image, an 800×400 image (wider than the page), a text diagram, a drawing and the document's own 4-step flowchart. Measured in pixels in the editor (paper on and off) and on the Read tab (paper on and off); PDF via Export ▸ PDF (the same file as Print preview), checked with pymupdf; Word with python-docx.
    - Each never-resized kind prints at its own size: Passed. Editor = Read tab = PDF = Word, for every one:
      - image: 300×150 / 300×150 / 300×150 / 300×150;
      - text diagram: 300×72 everywhere (it was ~640 px across the PDF before);
      - drawing: 182×182 everywhere;
      - flowchart: 192×502 everywhere.
    - A picture wider than the text is still capped: Passed. The 800×400 image is 680.3×340.2 (the text width) in the editor, Read tab, PDF and Word.
    - Resized pictures are unchanged: Passed, in "E2E pre-UAT COM-2004 every kind of picture". PDF and Word match the editor: 30% image 204.1, 50% image 340.2, 50% diagram 340.2×81.7, 40% drawing 272.1, own flowchart 192×342. The 20% standalone flowchart is 136.1 in all three.
    - Cached PDFs of published documents made afresh: Passed. Two published E2E documents exported in round 3 (COM-1960 fit to page, COM-1904 flowchart document) now come back as the new tagged PDFs, so the old cache wasn't reused.
    - Tests: Passed (test_picture_own_size.py covers an unresized text diagram, drawing and image, the cap, and resized/Full width unchanged).
    Files: ~/compass-uat/s6y6p7g/COM-2009/ (r3re-unresized.pdf, r3re-unresized.docx, r3re-unresized-pdf-p2.png, r3re-read.png, r3re-edit-paper-on.png)
assignee: steve
label:
- bug
priority: high
task_status: done
---
Found in pre-UAT of round 3, by Tester B on staging 7ea67f64, against COM-2000.

**Steps:** insert a text diagram, don't resize it, then Export ▸ PDF. This is the same file as Print preview.

**Seen:** it is 300×72 px in the editor, on the Read tab and in Word, but the PDF draws it across the whole text width (about 170 mm). A diagram resized to 50% matches everywhere.

Screenshot: ~/compass-uat/s6y6p7g/COM-2000/r3-export2-pdf-page2.png. Files: ~/compass-uat/s6y6p7g/COM-2000/r3-export2.pdf and r3-export2.docx.

**Done when**
- A picture of any kind that has never been resized (image, drawing, text diagram, flowchart) prints in the PDF at the same size as in the editor, the Read tab and Word, never stretched to the text width. Check each kind.
- A picture larger than the text width is still capped at the text width.
- Resized pictures are unchanged.
- PDFs already cached for published documents are made afresh, if the renderer's cache needs a version bump.
- Tests cover an unresized text diagram and an unresized drawing in the PDF at their own size.

Independent: backend PDF render (core/render).