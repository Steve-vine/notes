---
id: 01M7Q28QVB4T1FCR1SYQ74T0P3
created: 2026-11-18T10:12:03.563378Z
updated: 2026-11-18T10:12:06.26095Z
type: task
title: 'A flowchart is never cut off in the PDF: a tall one scales or splits, one that fits shows whole, and its picture is ready as soon as the canvas closes'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1936
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: high
task_status: todo
---
Re-check on staging 27151cd9, 2026-11-18 (tester A):
- **Cut off:** a published 8-step top-to-bottom flowchart (converted from a text diagram) exports a PDF where:
  - page 2 has only the heading;
  - the picture on page 3 runs past the bottom of the page, so "Close the incident" never appears;
  - page 4 has only the caption.
  Files: ~/compass-uat/s6y6p7g/COM-1931/re-convert-v2.pdf, re-convert-v2-p2.png … -p4.png
- **Split when it fits:** the wide request flow on its landscape page still splits into 2 parts. There's no lone "End" part any more, but it doesn't show whole as COM-1932 intended for a flowchart that fits (~/compass-uat/s6y6p7g/COM-1931/re-v4.pdf, pages 3–4).
- **"Not yet drawn":** publishing straight after converting a text diagram and pressing Done gave a PDF saying "Not yet drawn". The picture was only saved when the Edit tab was reopened, which left draft changes and needed a second publish.

**Done when**
- A flowchart taller than its page is scaled down to the readable minimum, or else cut between steps into parts, in PDF and Word. Nothing ever runs off the page, and the heading and caption stay with the picture.
- A flowchart that fits its page (portrait or landscape) at a readable size shows whole, on one page.
- Pressing Done on the canvas saves the picture, so publishing straight away gives a PDF and Word file with the picture, never "Not yet drawn".
- Tests cover a tall flow, a wide flow that fits a landscape page, and publish-straight-after-Done.

Independent unless saving on Done needs an API change.