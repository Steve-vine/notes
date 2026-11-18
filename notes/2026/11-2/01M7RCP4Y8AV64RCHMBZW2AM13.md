---
id: 01M7RCP4Y8AV64RCHMBZW2AM13
created: 2026-11-18T22:33:23.144305Z
updated: 2026-11-18T23:14:41.613192Z
type: task
title: Flowchart words in PDF and Word use the house style's font, italic included
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1982
sprint: s6y6p7g
comments:
- id: 01M7RF1SADTEBFTQHN326XF6VZ
  author: Steve Vine
  at: 2026-11-18T23:14:41.613047Z
  text: |-
    Done — PR #1973, merged 5d1e1459.
    A flowchart in a PDF or Word file now prints its words in the document's house-style font, bundled or uploaded, like the text around it. Bold, italic, underline and strikethrough match the canvas.
    If an uploaded font has no italic face, italic words are still printed slanted. If it has no bold face, bold words are still printed heavier.
    Words keep the picture's line breaks. If the house font is wider than the canvas's, the words come down just enough in size to stay inside their shapes.
    Change a house style's font and the next PDF or Word export of an existing flowchart uses the new font. Nothing needs re-publishing, and files cached before this deploy are made afresh.
    Word now gets the picture exactly as the PDF prints it, in the house font, whether or not the reader has that font installed.
    Assumption: the room words had on the canvas is Inter's. A narrower house font keeps the words' size.
    To check on staging: under "A4-Policy-External" (the uploaded Outfit font), download the PDF and Word of "E2E pre-UAT COM-1942 COM-1951 COM-1944 COM-1957 styles". "Raise the request" and the Engineer lane name should be in Outfit and slanted, not upright DejaVu Sans.
assignee: steve
label:
- bug
priority: high
task_status: active
---
Pre-UAT round 2 re-check (tester B, staging d6c281fe), COM-1957/1980: italic flowchart words print upright in the PDF, in a fallback font (DejaVu Sans), e.g. "Raise the request" in "E2E pre-UAT COM-1942 COM-1951 COM-1944 COM-1957 styles" and the Engineer lane name. Canvas, reading view, Word and PNG show italic.

Likely cause: the house style "A4-Policy-External" (now version 19) uses a custom font ("custom-outfit2"), but the flowchart picture always asks for Inter (render.ts:68), which the PDF doesn't have under that style. When the house style used Inter, the same flowcharts printed Inter Italic.
Screenshots: ~/compass-uat/s6y6p7g/COM-1980/r2re-styles-now-italic-crop.png, r2re-lanes-v5-p2-crop-mupdf.png

COM-1957 promised flowcharts use the house-style font so they match their documents.

**Done when**
- A flowchart's words in the PDF and Word use the house style's own font (whatever it is, built-in or custom), with bold, italic, underline and strikethrough as on the canvas. If the house font has no italic face, italic is still shown slanted.
- The canvas, reading view and downloads keep matching the printed picture's line breaks (no words cut or overflowing because the PDF font differs from the one the picture was measured in).
- Changing the house style's font changes existing flowcharts' PDFs (cache) without re-publishing.
- Tests cover a custom house font and italic in the PDF.

Independent: render (frontend picture and/or backend PDF/Word).