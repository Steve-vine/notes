---
id: 01M7WMCZCH2N0BB6K8QMX4CX19
created: 2026-11-20T14:05:08.881922Z
updated: 2026-11-20T19:25:18.265042Z
type: task
title: 'A flowchart''s colours always come from one house style: its document''s, or for a standalone flowchart, its own type''s'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2024
sprint: s6y6p7g
comments:
- id: 01M7WRWEWC3BHRMM21NW7GEXYG
  author: Steve Vine
  at: 2026-11-20T15:23:30.572231Z
  text: |-
    Done — PR #2020, merged f8529974 (building on COM-2023, PR #2018, merged 4f52e136).
    A standalone flowchart now shows in its own content type's house style in every document it's added to, on the Read and Edit tabs. That covers its picture, full screen and PNG/SVG download. The document's own text keeps the document's colours.
    Edit flowchart, from any document or from its own page, opens its own page, and the canvas there is always in its own type's house style. Before, it took the house style of the document you came from.
    In PDF and Word, every document prints the picture kept with the flowchart's version, which is drawn in its own colours.
    A document's own flowchart always shows and edits in its document's house style.
    The flowchart is no longer marked as having unpublished changes just from being opened from another document. That happened when its page re-saved the picture in the other document's colours, and it can't now.
    Assumption: in PDF and Word a flowchart's words print in the document's font, as every flowchart's do (COM-1982), so it reads like the text around it. Its colours are its own.
    Assumption: a flowchart whose picture was saved in the wrong colours before this fix (only during testing on staging) is put right the next time it's edited and published.
    To check on staging: add one standalone flowchart to two documents whose types have different house styles. Check it's in its own type's colours in both. Edit it from each and check the canvas colours. Then print both.
- id: 01M7WZGWKQW809JH50GSXQA25D
  author: Steve Vine
  at: 2026-11-20T17:19:31.44729Z
  text: |-
    Pre-UAT on staging b65d7ed8 — Failed

    Setup: the standalone flowchart "E2E pre-UAT COM-2024 standalone flowchart (Runbook type)" (two lanes, a decision; house style "Runbooks", red) is added to two published documents. "E2E pre-UAT COM-2023 Procedure document (A4-Policy-External style)" is grey/black. "E2E pre-UAT COM-2023 Runbook document (Runbooks style)" is red. Each document also has a flowchart of its own. I tested as E2E Admin A. No type was remapped.

    - In its own type's colours in every document: Passed. In the grey Procedure document the standalone flowchart is red (Runbooks), while that document's own flowchart and text stay grey. This holds on the Read tab, the Edit tab, the picture, full screen and the SVG/PNG downloads, and in the browser's print view. PDF: in the Procedure PDF, "Standalone step" is drawn red and the document's own "Own step" grey. In the Runbook PDF both are red. Word: the same colours in both files.
    - Editing it from either document, or from its own page, opens the canvas in its own type's colours: Passed. From either document, Edit flowchart opens its own page. Its Edit flowchart button then opens a red canvas with Runbooks swatches in the Style panel, every time. The builder's deviation stands: from a document you land on its page and need one more click to reach the canvas.
    - A document's own flowchart shows and edits in that document's colours: Passed (Procedure grey, Runbook red, canvas and swatches included).
    - Assumption (the document's type changes, so its flowchart follows): Failed. I changed "E2E pre-UAT COM-2023 same own flowchart (Procedure)" from Procedure to Runbook on the Edit tab. The canvas and the document's text turned red, but the flowchart picture on the Edit and Read tabs stayed grey until the flowchart is opened and Done. I set the type back to Procedure afterwards.
    - Not marked as having unpublished changes from being shown or opened from another document: Passed. It's still "no unpublished changes", version 1, after opening it from both documents and cancelling the canvas.
    - Tests: Passed. ownHouseStyle.test.tsx covers one flowchart in two documents.
    - DEFECT, seen with this exact setup (logged in detail on COM-2023): moving inside the app from one of these two documents to the other leaves the page on loading placeholders forever, in both directions, by link, from the Library and from search. Refreshing shows it.
    - Seen once and not again in 4 tries: Edit flowchart from the Runbook document opened the flowchart's page as "Compass couldn't load this — try again" (r4-O1-*.png).
    Screenshots: ~/compass-uat/s6y6p7g/COM-2024/ (r4-*; PDFs, Word files and downloads are there too)
- id: 01M7X6Q6HS66DF2MH7XGXE3SSA
  author: Steve Vine
  at: 2026-11-20T19:25:18.264628Z
  text: |-
    Re-checked after fixes (staging 514c4649): now Passed

    Both round-4 failures are fixed. The type-change point is covered by COM-2034, and the stuck loading between the two documents by COM-2033.
    - Standalone flowchart in its own type's colours in both documents: still Passed. In "Procedure document (A4-Policy-External style)" its picture is red (#fde7ec/#eb0e3d) while the document's own flowchart is grey (#e9e9e9/#212121). In "Runbook document (Runbooks style)" both are red. The same on Read and Edit. PDF: "Standalone step" is red and "Own step" grey in the Procedure PDF, and both are red in the Runbook PDF. The Word files match.
    - Editing from either document: still Passed. Edit flowchart in the settings panel goes to the flowchart's own page, and its Edit flowchart opens a red Runbooks canvas, from both documents.
    - Not marked as having unpublished changes: still Passed. The standalone flowchart is version 1 with no unpublished changes after I opened it from both documents and cancelled.
    - A document's own flowchart follows a type change: now Passed (COM-2034).
    Screenshots: ~/compass-uat/s6y6p7g/COM-2024/r4re-* (PDFs and Word files alongside)
assignee: steve
label:
- bug
priority: high
task_status: review
---
Steve (testing round 3): take two documents with different house styles, create a new standalone flowchart, and add it to both. In each document it shows in the colour scheme it was saved in. Edit it, though, and the editor opens in the colour scheme of whichever document it was opened from.

Steve's rule, which is the simple solution:
- A document's own (embedded) flowchart only ever uses the colour scheme of the document it belongs to.
- A standalone flowchart, wherever it's included, only ever shows in the colour scheme its own content type is mapped to.

**Done when**
- A standalone flowchart shows in its own type's house style in every document it's added to, on the Read and Edit tabs, in print, PDF, Word, its picture and downloads.
- Editing it, from any document or from its own page, opens the canvas in its own type's house style, never the house style of the document it was opened from.
- A document's own flowchart always shows and edits in that document's house style. Assumption: if the document's type, or the house style mapped to it, changes, the flowchart follows the new house style.
- A standalone flowchart in its own house style isn't marked as having unpublished changes just because it's shown inside another document.
- Tests cover one standalone flowchart added to two documents with different house styles, viewed and edited from each.