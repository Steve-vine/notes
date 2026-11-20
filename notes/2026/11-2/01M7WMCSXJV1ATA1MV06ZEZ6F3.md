---
id: 01M7WMCSXJV1ATA1MV06ZEZ6F3
created: 2026-11-20T14:05:03.282699Z
updated: 2026-11-20T14:53:25.166468Z
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