---
id: 01M7NQE41410DZD17BQDKVFK3S
created: 2026-11-17T21:43:31.108153Z
updated: 2026-11-17T21:43:31.108153Z
type: task
title: Download a flowchart as a picture (PNG, SVG), and wide flows print well
task_status: todo
assignee: steve
priority: medium
label: feature
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1910
---
Builds on COM-1905 (needs lanes). Steve, 2026-11-17: picture export is in this sprint.

**What people see**
- **Download ▸ PNG** and **Download ▸ SVG** on the canvas toolbar, on a standalone flowchart's page and in a document's reading view (on the flowchart's menu). The file is named after the flowchart (or the document plus "flowchart"), and the date.
- The picture is the published version where there is one, and the draft when downloaded from the editor. It uses the light house style whichever theme the person has on. PNG is high-resolution, so it's sharp in slides.
- **Wide or tall flows in PDF and Word:** a flowchart wider than a portrait page goes on its own landscape page. One too big even for that is shrunk to fit, down to a readable minimum, and is otherwise split across pages with "continued" markers and lane names repeated on each page. Captions and the Links list (COM-1906) stay with it.

**Done when**
- PNG and SVG downloads work from all three places and match what's on screen in the light theme.
- A wide flowchart prints on a landscape page in PDF and Word, and a very large one splits readably across pages with lanes named on each.

Independent: no migration, no API change. Branch from main after COM-1905 lands.