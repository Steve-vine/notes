---
id: 01M7V3KQS7HGQRX0VC1RMFYV7W
created: 2026-11-19T23:52:30.247227Z
updated: 2026-11-20T00:22:52.242482Z
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
assignee: steve
label:
- bug
priority: high
task_status: review
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