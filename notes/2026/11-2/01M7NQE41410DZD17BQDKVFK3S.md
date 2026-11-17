---
id: 01M7NQE41410DZD17BQDKVFK3S
created: 2026-11-17T21:43:31.108153Z
updated: 2026-11-17T22:11:54.203292Z
type: task
title: Download a flowchart as a picture (PNG, SVG), and wide flows print well
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1910
sprint: s6y6p7g
blocked_by:
- 01M7NQC2KVK2HH9J55CGGSJ26F
- 01M7NS1HYP196JWKV07JVF596Z
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Builds on COM-1905 (needs lanes) and COM-1914 (Landscape page). Steve, 2026-11-17: picture export is in this sprint, and an author puts a wide flowchart on a landscape page themselves (COM-1914), so nothing turns landscape automatically inside a document.

**What people see**
- **Download ▸ PNG** and **Download ▸ SVG** on the canvas toolbar, on a standalone flowchart's page and in a document's reading view (on the flowchart's menu). The file is named after the flowchart (or the document plus "flowchart"), and the date.
- The picture is the published version where there is one, and the draft when downloaded from the editor. It uses the light house style whichever theme the person has on. PNG is high-resolution, so it's sharp in slides.

**Wide flowcharts in a document's PDF and Word**
- A flowchart is scaled to the width of the page it's on, portrait or landscape.
- If a flowchart in a document would be shrunk below a readable size on a portrait page, the editor shows a hint on it: "Wide flowchart: put it on a landscape page?" **Yes** inserts a Landscape page before it and a Page break after it (COM-1914). The author can undo that, or dismiss the hint, which stays dismissed for that flowchart.
- If a flowchart is too big even for the page it's on, it's split across pages with "continued" markers and lane names repeated on each page. Captions and the Links list (COM-1906) stay with it.

**A standalone flowchart's own PDF and Word** (COM-1907)
- There's no document editor to put a marker in, so the flowchart has a **Page: Portrait / Landscape** setting. A new flowchart starts with whichever suits its shape (wider than tall → Landscape), and the author can change it. The title page stays portrait.

**Done when**
- PNG and SVG downloads work from all three places and match what's on screen in the light theme.
- The wide-flowchart hint appears in the editor, and Yes produces a PDF and Word file with that flowchart on its own landscape page and portrait either side.
- A very large flowchart splits readably across pages, with lanes named on each.
- A standalone flowchart prints in the orientation its Page setting says.

Independent: no migration, no API change. Branch from main after COM-1905 and COM-1914 land. If COM-1907 (the standalone flowchart's page) hasn't landed yet, whichever of the two lands second adds Download and the Page setting to that page.