---
id: 01M7Q28QVB4T1FCR1SYQ74T0P3
created: 2026-11-18T10:12:03.563378Z
updated: 2026-11-18T12:06:20.060862Z
type: task
title: 'A flowchart is never cut off in the PDF: a tall one scales or splits, one that fits shows whole, and its picture is ready as soon as the canvas closes'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1936
sprint: s6y6p7g
comments:
- id: 01M7Q4AHKVEHSV87MZQYSR350A
  author: Steve Vine
  at: 2026-11-18T10:47:59.867363Z
  text: |-
    Done — PR #1927, merged a182f6be.
    - Tall flowcharts: a flowchart that fits its page at a readable size is now shown at the size that fits the page both ways, in the PDF and Word. A tall top-to-bottom flow no longer runs off the bottom. Its heading and caption stay with it on one page; Word keeps the caption with the picture.
    - Too tall to read whole: it is still cut between steps into parts.
    - Done on the canvas: the picture is kept before the canvas closes, and the section is saved at once. Publishing straight away has the picture, never "Not yet drawn", and leaves no draft changes behind. A standalone flowchart saves its chart and picture together.
    - The wide request flow on its landscape page: it is about 2,000 px wide, so whole on the page its words would be about 4.5 pt, under the readable minimum. It still comes out in two readable parts, which is the rule. A narrower flow that does fit a landscape page at a readable size is shown whole, on one page, and a test pins both.
    Tests cover the tall flow (PDF and Word), the wide flow on a landscape page, and Done saving the picture at once.
    To check on staging: re-export tester A's 8-step converted flowchart. Then convert a text diagram, press Done and publish straight away; the PDF and Word should both have the picture.
- id: 01M7Q5WBYMW6GQW3JYSBXCHRXW
  author: Steve Vine
  at: 2026-11-18T11:15:12.46823Z
  text: |-
    Pre-UAT on staging a182f6be — Failed (one point: a tall flowchart's heading is left behind on its own page)
    As E2E Admin A.
    - A tall flowchart scales or splits, nothing runs off the page, and the heading and caption stay with the picture: Failed on the heading.
      - I re-exported the 8-step converted "Known fix?" flow (v3). The whole picture now fits page 3 with its caption, and "Close the incident" is there. Nothing runs off the page.
      - But page 2 holds only the section heading "1 Fixing a fault", and the rest of the page is blank. The picture starts on the next page, so the heading doesn't stay with it (re2-knownfix-p2-p3.png, re2-knownfix.pdf).
      - In the Word file the picture is 3.1 × 9.2 inches with its caption after it (re2-knownfix.docx). I didn't open it in Word to see where it breaks.
    - A flowchart that fits its page at a readable size shows whole: Passed for what I could check. A 5-shape converted flow sits whole on page 2 with its heading and caption. The wide request flow on its landscape page still comes in 2 parts, which the builder explains is by design. Both parts are readable, and each part names all four lanes (COM-1935/re2-request-p3.png, -p4.png).
    - Done saves the picture, so publishing straight away has it: Passed. In a new document, "E2E pre-UAT COM-1936 convert and publish at once", I converted a Mermaid diagram, opened the canvas, set a caption, pressed Done and published at once. The document shows "Published", with no draft changes left. The PDF has the picture with the heading and caption on page 2, with no "Not yet drawn" anywhere, and the Word file has the picture too (re2-pwreset.pdf, re2-pwreset.docx).
    - Done on a standalone flowchart's canvas: it closes. On "E2E pre-UAT COM-1927 laned standalone flowchart", Done closed the canvas in about 0.16 s, both with no change and after adding a step description. It saved the chart and picture (POST diagrams, PUT flowchart) and left no dialog open (re2-standalone-after-done-*.png). I couldn't reproduce the smoke's "canvas still open after Done".
    Screenshots and files: ~/compass-uat/s6y6p7g/COM-1936/
- id: 01M7Q8SZMW3X0BQ6PNT29BTWHX
  author: Steve Vine
  at: 2026-11-18T12:06:20.060616Z
  text: 'Re-check on staging c15afb4d: the separated heading now Passed (COM-1938). "1 Fixing a fault", the flowchart and its caption are on one PDF page, and in Word the heading keeps with the picture.'
assignee: steve
label:
- bug
priority: high
task_status: review
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