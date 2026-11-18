---
id: 01M7QS74JTC4SCDDKNXEG47D8B
created: 2026-11-18T16:53:08.314174Z
updated: 2026-11-18T21:21:43.033677Z
type: task
title: The Library doesn't show layout markers such as "Page break" and "Landscape page"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1963
sprint: s2q1gxe
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Steve, testing the Library on staging (18 Nov): layout markers show in documents read in the Library. They're there for writers, to mark where the printed page breaks or turns landscape, and mean nothing to someone reading on screen. Seen on staging: Access Control Policy in the reader shows "Page break" before "12 Controls" and before "13 Document Review".

**Done when**
- In the Library reader and the reading pane, no layout marker shows: no "Page break", no "Landscape page" (start or end), and no other marker that exists only to shape the printed page.
- The text either side of a removed marker joins up normally, with no empty gap or stray rule where it was.
- A landscape section's contents read like the rest of the document, at the reader's width.
- The document itself is unchanged. Content's editor still shows the markers to writers.
- Printing from the reader and Export to PDF and Word still honour page breaks and landscape pages.
- The Markdown export carries no layout markers either. Check it, and fix it if it does.
- A test opens a document holding a page break and a landscape section in the reader, and finds neither marker's label.

Independent: frontend reader rendering (libraryFolders/ReaderPage.tsx and reader.css, or the shared document body's read-only mode).