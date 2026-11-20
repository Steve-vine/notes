---
id: 01M7WMCSXJV1ATA1MV06ZEZ6F3
created: 2026-11-20T14:05:03.282699Z
updated: 2026-11-20T17:19:18.526882Z
type: task
title: Each document shows its own house style's colours, not the previous document's, until the page is refreshed
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2023
sprint: s6y6p7g
comments:
- id: 01M7WQ58FKWVYFVPDHBSWS1SG1
  author: Steve Vine
  at: 2026-11-20T14:53:21.779246Z
  text: |-
    Done — PR #2018, merged 4f52e136.
    Moving between documents whose types use different house styles now shows each document in its own house style's colours straight away, in both directions, with no refresh. That holds by link, from the Library, from search and with Back.
    It covers the Read and Edit tabs (rich text and Markdown), "Show as on paper", full screen, the flowchart canvas, its Style panel, kept flowchart pictures and downloads. The portal's documents and the Library reader work the same way.
    A document with no house style shows Compass's own look, with nothing left over from the last document.
    Cause: once loaded, a house style stayed on the page and coloured every document after it. Each house style now colours only the documents that use it.
    Most of COM-2024 comes with this: a standalone flowchart's own page (where you land when you edit it from a document) is always in its own type's house style.
    To check on staging: two content types mapped to two house styles. Open a document of each in turn, then go back. Check headings, tables, callouts and a flowchart's colours, on both tabs.
- id: 01M7WZGFZYSTYV7MXJGBC3MQZ9
  author: Steve Vine
  at: 2026-11-20T17:19:18.526711Z
  text: |-
    Pre-UAT on staging b65d7ed8 — Failed

    Setup: I used two house styles that were already on staging and remapped nothing. "A4-Policy-External" (grey/black headings, pale blue table header) is used by Procedure. "Runbooks" (red headings, purple table header, purple/green callouts) is used by Runbook. Test documents are all named "E2E pre-UAT COM-2023 …". Each has a heading, a table, three callouts, a text diagram and its own flowchart. Some also show the standalone flowchart "E2E pre-UAT COM-2024 standalone flowchart (Runbook type)". I tested as E2E Admin A in headless Chromium and read the colours off the screen in numbers.

    - Moving between documents with different house styles, both ways, with no refresh: Failed in one case (defect below). With the pair "full Procedure (no standalone)" and "full Runbook (no standalone)" it Passed. Each document showed its own colours straight away, in both directions, with no page reload. I checked this by link from the Content list, from the Library ("Not in a folder"), from search (results page) and with Back/Forward.
    - DEFECT: two published documents with different house styles that both show the same standalone flowchart never finish opening when you move from one to the other inside the app. Steps: open "E2E pre-UAT COM-2023 minimal Procedure with standalone". Click Content in the top trail. Click "E2E pre-UAT COM-2023 minimal Runbook with standalone". The grey loading placeholders stay on screen (I waited 60 s). There's no error, no request is waiting and the console shows nothing. It happens in both directions. It also happens from the Library and from search. It happens as Admin B too, in a fresh browser. Refreshing shows the document, and so do Back then Forward. These all open normally: the same pair as drafts; documents where only one of the two shows the flowchart; two documents of the SAME house style showing one standalone flowchart (COM-1908 A/B). This is exactly Steve's COM-2024 setup.
    - Read and Edit tabs and print: Passed. Read tab, Edit tab, the browser's print view and the PDF behind Print preview all switched correctly: heading colour, table header, note/warning/important callouts, text colour, and the document's own flowchart picture (grey for Procedure, red for Runbook). The flowchart canvas, its Style panel swatches and full screen were each in their own document's colours after switching.
    - Text diagrams: nothing carries over, but they never take any house style's colours. They're always Compass blue, in both documents (see report).
    - Leaving a document leaves no colours behind: Passed. After the Runbook document I opened the Content list, the House styles tab and a decision record in the Library. None of them had any Runbooks colour, and no house-style colour was set on the page.
    - Tests: Passed. houseStyleScope.test.tsx opens one house style, then another, and goes back. Being jsdom tests, they can't see the hang above.
    Screenshots: ~/compass-uat/s6y6p7g/COM-2023/ (r4-A*, r4-L*, r4-S*, r4-X*; the hang is r4-D1-stuck-*)
assignee: steve
label:
- bug
priority: high
task_status: review
---
Steve (testing round 3): the content viewer and editor seem to remember the colour scheme of the last document viewed. Steve made two house styles with different colour palettes and mapped them to different content types. Opening a document whose type uses the non-standard palette shows that palette, as expected. Going back to a document that uses the normal palette still shows the other palette until the screen is refreshed.

**Done when**
- Moving between documents with different house styles shows each document in its own house style's colours straight away, in both directions, with no refresh. This holds whether moving by link, the Library, search or the browser's Back button.
- This covers the Read and Edit tabs, print preview, and everything coloured by the house style: headings, tables, callouts, text diagrams, flowcharts and their pictures.
- Leaving a document doesn't leave its colours on other screens.
- Tests cover opening a document with one house style and then a document with another.