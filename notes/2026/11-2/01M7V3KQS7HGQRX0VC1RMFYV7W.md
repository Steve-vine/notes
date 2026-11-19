---
id: 01M7V3KQS7HGQRX0VC1RMFYV7W
created: 2026-11-19T23:52:30.247227Z
updated: 2026-11-19T23:52:30.247227Z
type: task
title: A picture that has never been resized is the same size in the PDF as in the editor and the Read tab
priority: high
task_status: todo
label: bug
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2009
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