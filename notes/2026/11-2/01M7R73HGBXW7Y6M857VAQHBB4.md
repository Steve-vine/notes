---
id: 01M7R73HGBXW7Y6M857VAQHBB4
created: 2026-11-18T20:55:50.53972Z
updated: 2026-11-18T22:32:18.31766Z
type: task
title: 'Flowchart font options apply everywhere: free Lines, Group titles and lane names, drawn the same on canvas, reading view and picture'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1980
sprint: s6y6p7g
comments:
- id: 01M7R9BKDQ4EKNWGWEMTY8GZQP
  author: Steve Vine
  at: 2026-11-18T21:35:11.799692Z
  text: |-
    Done — PR #1960, merged 02bd2e7e.
    - A free Line's label now takes Bold, Italic, Underline and Strikethrough, from the Style panel buttons (which light up) and from Ctrl+B / I / U.
    - A Group's title is drawn in its own size, weight, italic, underline/strikethrough, colour and alignment, the same on the canvas and in the picture/PDF/Word. Its title band grows to fit. The Style panel offers Align for a Group but not Vertical, because the title always runs along the top.
    - A lane's name is drawn at its own size and alignment on the canvas, and in the reading view's lane-name boxes, where it scales with the picture at every zoom. It matches the picture.
    - Words aligned to a side now keep clear of a Start/End's rounded end, a Decision's corners, an Input/Output's slant, a Hand-off's point, a Note's folded corner and a Document's wave. Centred words haven't moved. The canvas places words exactly where the picture does.
    - Compare versions now names a Line's style changes. It says "No differences." only when nothing changed; under a list of flowchart changes it says "No changes to the text." instead.
    Assumptions: the reading view's lane names follow the picture's scale exactly (they sit over its own names), so in a narrow column they are as small as the picture's. A connection's or Line's label on the canvas is now the picture's 12 px at Normal; it was 11.
    To check on staging: the Engineer lane at Size L, Align Left, on the canvas, the reading view (zoom in and out) and the PDF; a Group titled Bold, Underline, Size L; Bold on a free Line's label; Start set Left/Top and Hand-off set Right/Bottom; Compare versions after a style-only change.
- id: 01M7RCM5MDG6M9ZNH4R616JXQ1
  author: Steve Vine
  at: 2026-11-18T22:32:18.317467Z
  text: |-
    Pre-UAT on staging d6c281fe — Failed (one point: italic words lose their slant in the PDF. This is new since the house style "A4-Policy-External" switched to a custom font. Everything this task fixed works.)
    Flowcharts: "E2E pre-UAT COM-1952 lane colours" (v5), "E2E pre-UAT COM-1954 COM-1955 COM-1956 group line text" (v4) and "E2E pre-UAT COM-1942 COM-1951 COM-1944 COM-1957 styles" (v4). As E2E Admin A in E2E Test Company.
    - Engineer lane at Size L, Align Left, the same everywhere: Passed.
      - Canvas: 16px, left, 4px in from the header's edge, where Service Desk is 13px and centred (r2re-01).
      - Reading view: left, and in proportion with the picture (16:13 against the other names) at zoom 1 (12.9px) and zoomed in (25.9px) (r2re-02-read-lanes-zoom1/zoomin).
      - PDF, Word and PNG: large and left (r2re-lanes-v5-p2-crop.png, r2re-lanes-v5-word-crop.png, r2re-dl-png-left.png).
    - Group title Bold + Underline + Size L, drawn on the canvas and in the PDF: Passed. Canvas: 16px, bold, underlined. I set Align Right and the title moved to the right. Align is offered and Vertical isn't. PDF v4: large, bold, underlined and on the right (r2re-04, r2re-group-v4-p2.png).
    - Font options on a free Line's label: Passed. The Bold button lights on "Check this one" and is kept after reselecting. On "Oldest first", Ctrl+I, Ctrl+U, Ctrl+B and the Strikethrough button each light their button, and pressing Strikethrough again turns it off. The canvas draws them, and the PDF draws "Check this one" in bold and "Oldest first" bold and underlined.
    - Words keep a clear inset: Passed. Start (Left/Top) sits about 10px in from its rounded end. "Hand off to change" (Right/Bottom) stays clear of the slant, on the canvas (r2re-06-canvas-n1/n6) and in a newly drawn PDF (r2re-07-pdf-v4-start/handoff). Left/Top on a Decision, Right/Bottom on a Document, Left/Bottom on an Input/Output and Right/Top on a Note were all clear of their outlines on the canvas (r2re-08; not kept). A version published before this fix keeps its old picture in the PDF until it is published again.
    - Compare after a style-only change: Passed. Group v3→v4 lists Group "Repeat every hour", Line "Check this one" and Line "Oldest first" text style changed, then "No changes to the text." (r2re-05). Styles v3→v4: Step "Send the reply" text style changed, then "No changes to the text." "No differences." doesn't appear.
    - Italic in the PDF: Failed.
      - What I saw: italic words are stored, and the canvas, reading view, Word and PNG draw them slanted. In today's PDF they print upright: "Raise the request" (Italic), the bold-italic Text, the Engineer lane name and the "Oldest first" label (r2re-styles-now-italic-crop.png, r2re-lanes-v5-p2-crop-mupdf.png).
      - Cause: the flowchart's words in the PDF are now in a fallback font (DejaVu Sans) rather than the house font. The house style "A4-Policy-External" (now v19) uses a custom font ("custom-outfit2"). The flowchart picture asks for Inter, which the PDF doesn't have under that style. In round 2 (Inter house font) the same flowcharts printed in Inter Italic.
      - Steve: export any of these flowcharts to PDF and look at an italic label. This probably wants its own task: flowchart words in the PDF should follow the house font, or at least keep italic.
    - Tests: fontEverywhere.test.tsx covers Line labels, Group titles, lane names (canvas, picture, reading view zoom), insets per shape, and DiffView.test.tsx covers the Compare wording.
    Screenshots: ~/compass-uat/s6y6p7g/COM-1980/
assignee: steve
label:
- bug
priority: high
task_status: review
---
Pre-UAT round 2 (tester B, staging cbacf0c2), COM-1957 (and COM-1952 for lane names):
1. **Line toggles:** select a free Line, press Bold/Italic/Underline/Strikethrough or Ctrl+B: the button doesn't light and nothing is saved (size and colour work). The toggle code doesn't look at Lines.
2. **Group title:** Bold, Underline and Size L on a Group's title are saved but the canvas and PDF/SVG still show the plain 13px title. Screenshot: ~/compass-uat/s6y6p7g/COM-1957/r2-08-group-title-text-styled.png
3. **Lane names:** Engineer at Size L, Align Left: PDF, Word and PNG show it large and left; the canvas shows it large but centred; the reading view shows it 11px centred. Screenshots: COM-1952/r2-13-canvas-light-adminB.png, r2-09-read-light-rows-tidied.png, r2-lanes-columns-v2-p2.png
4. **Aligned words touch the outline (minor):** a Start set Left/Top has its word against the rounded corner; a Hand-off set Right/Bottom runs into its slanted edge (canvas and picture). Screenshots: COM-1957/r2-03-canvas-all-styles-wide.png, COM-1942/r2-crop-handoff.png
5. **Compare versions:** "No differences." still appears beneath a list of style changes, and a change to a Line label's style isn't mentioned.

**Done when**
- Every font option (size, colour, B/I/U/S, alignment) works and is drawn on shapes, connection labels, free Line labels, Text, Group titles and lane names, identically on the canvas, the reading view (incl. its lane-name boxes, at every zoom) and the picture/PDF/Word.
- Aligned words keep a clear inset inside every shape's outline (rounded, diamond, slanted, document wave).
- Compare names every style change incl. Line labels, and says "No differences." only when there are none.
- Tests cover each of the five points.

Independent: frontend (+ server diff wording if needed).