---
id: 01M7RCP4Y8AV64RCHMBZW2AM13
created: 2026-11-18T22:33:23.144305Z
updated: 2026-11-18T23:50:36.96317Z
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
- id: 01M7RH3J53ATJ3SC67REPQZY6H
  author: Steve Vine
  at: 2026-11-18T23:50:36.962949Z
  text: |-
    Pre-UAT on staging 5d1e1459 — Passed (one point checked only indirectly, see below)
    I exported three flowcharts that use the house style "A4-Policy-External" (uploaded Outfit font), as E2E Admin A in E2E Test Company, to PDF and Word: "E2E pre-UAT COM-1942 COM-1951 COM-1944 COM-1957 styles" v4, "E2E pre-UAT COM-1952 lane colours" v5, and "E2E pre-UAT COM-1954 COM-1955 COM-1956 group line text" v5.
    - Words in the house font, with bold, italic, underline and strikethrough as on the canvas: Passed.
      - Fonts: the PDFs embed only compass-custom-outfit2 (Regular, Bold, Oblique, Bold-Oblique), checked in a pdffonts-style listing of each picture page. There's no DejaVu fallback left.
      - Italic: "Raise the request" prints in Outfit Oblique, slanted. The Engineer lane name, the bold-italic Text and "Oldest first" print in Outfit Bold-Oblique, slanted (r2re-01-lanes-crop.png, r2re-02-styles-crop.png, r2re-group-v5-p2.png).
      - Bold: "End", "Send the reply", the XL label, "Repeat every hour" and "Check this one" print in Outfit Bold.
      - Underline and strikethrough are drawn. The default semi-bold lane names look heavier than the step words, as on the canvas (r2re-05).
      - Word gets the same Outfit picture, with italic slanted (r2re-03-word-lanes-crop.png, r2re-04-word-styles-crop.png).
    - Line breaks match and nothing is cut or overflows: Passed. Every multi-line label breaks where the canvas breaks it:
      - "A long / label that / should grow / when made / extra large / and bold";
      - "Urgent requests skip / the queue";
      - "Hand off to / change";
      - "Work the oldest / ticket";
      - the six lines of the group's Text.
      All words sit inside their shapes.
    - A house font change reaches existing flowcharts' PDFs without re-publishing: Passed as far as I could see. All three flowcharts were published before this deploy and weren't re-published, and their PDFs and Word files now come out in Outfit. Before, they came out in DejaVu Sans (COM-1980 r2re-*). I didn't switch the house style's font itself, because that shared style is used by every Procedure on staging. test_a_flowcharts_pdf_follows_its_house_styles_font_without_republishing covers it.
    - Tests: test_flowchart_house_font.py covers an uploaded house font, slanted italic without an italic face, Word matching the PDF, and words staying in their room.
    Observation, minor: an underline or strikethrough is drawn at the width the words had in Inter, so in the narrower Outfit it runs a little past the words. On the right-aligned Group title "Repeat every hour" it starts well to the left of the first word. The same shows on "Oldest first" and "Send the reply" (r2re-group-v5-p2.png, r2re-02-styles-crop.png).
    Screenshots and files: ~/compass-uat/s6y6p7g/COM-1982/
assignee: steve
label:
- bug
priority: high
task_status: review
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