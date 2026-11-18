---
id: 01M7QNWP87GSCPXA9XQWER62QJ
created: 2026-11-18T15:55:00.231673Z
updated: 2026-11-18T21:10:46.546501Z
type: task
title: The Library reader's text is as wide as the house style's page, like Content's Read view
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1961
sprint: s2q1gxe
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Steve, testing the Library on staging (a3e70502, 18 Nov): after widening the text by changing the Policies house style's margins, policies read wider in Content, but the Library reader still looked the same.

**Why:** the reader takes most of the house style: fonts, colours, heading sizes and numbering. Its column, though, is a fixed width (700 px, uploaded PDFs 980 px). Content's Read view sizes the text from the house style's page instead: the page's text width between its left and right margins (`--rt-page-text-width`, `--rt-page-margin-left/right` from the house stylesheet, `richtext/paper.ts`). A house style with narrower margins therefore reads wider in Content, but not in the Library.

**Done when**
- The reader's text column is the house style's text width, the same width Content's Read view gives that document. Changing a house style's margins changes both alike.
- A document with no house style uses the built-in style's width.
- On a narrow window or a phone, the column still fits the screen without sideways scroll, as it does now.
- Uploaded PDFs keep their wider viewer.
- The reader's bar, its progress line and "Back to top" line up with the new column.
- A test pins that the column follows the house style's width.

Independent: frontend only (libraryFolders/ReaderPage.tsx, reader.css).