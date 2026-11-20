---
id: 01M7WMCSXJV1ATA1MV06ZEZ6F3
created: 2026-11-20T14:05:03.282699Z
updated: 2026-11-20T14:11:24.798051Z
type: task
title: Each document shows its own house style's colours, not the previous document's, until the page is refreshed
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2023
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: high
task_status: active
---
Steve (testing round 3): the content viewer and editor seem to remember the colour scheme of the last document viewed. Steve made two house styles with different colour palettes and mapped them to different content types. Opening a document whose type uses the non-standard palette shows that palette, as expected. Going back to a document that uses the normal palette still shows the other palette until the screen is refreshed.

**Done when**
- Moving between documents with different house styles shows each document in its own house style's colours straight away, in both directions, with no refresh. This holds whether moving by link, the Library, search or the browser's Back button.
- This covers the Read and Edit tabs, print preview, and everything coloured by the house style: headings, tables, callouts, text diagrams, flowcharts and their pictures.
- Leaving a document doesn't leave its colours on other screens.
- Tests cover opening a document with one house style and then a document with another.