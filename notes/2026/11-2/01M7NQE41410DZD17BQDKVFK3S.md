---
id: 01M7NQE41410DZD17BQDKVFK3S
created: 2026-11-17T21:43:31.108153Z
updated: 2026-11-19T18:45:28.581981Z
type: task
title: Download a flowchart as a picture (PNG, SVG), and wide flows print well
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1910
sprint: s6y6p7g
blocked_by:
- 01M7NQC2KVK2HH9J55CGGSJ26F
- 01M7NS1HYP196JWKV07JVF596Z
comments:
- id: 01M7PHSBVZ97SXMWQNGTD9SHF8
  author: Steve Vine
  at: 2026-11-18T05:24:02.559487Z
  text: |-
    Done — PR #1906, merged 69d7804f.
    - Download ▸ PNG picture / SVG picture is on the flowchart canvas and on a flowchart in a document's reading view. It's in the house style's paper colours whatever the theme, and the PNG is high-resolution. The file is named after the caption, or the document plus "flowchart", and the date.
    - In the editor, a flowchart too wide to read on a portrait page says "Wide flowchart: put it on a landscape page?". Yes puts a Landscape page before it and a Page break after, and one Undo takes both back. Dismiss is kept with that flowchart.
    - In the PDF and Word file, a flowchart too big for the page it's on is cut between steps into readable parts. Each part repeats the lane names and is headed "Part n of N (continued)". The caption and Links list come after the last part. On a landscape page it needs fewer parts.

    Assumptions:
    - "Readable" means at least 70% of the canvas size; the hint and the PDF/Word cut use the same threshold.
    - The hint only notices a Landscape page earlier in the same section, so a flowchart in a later section of a landscape run can still show it (Dismiss clears it).

    The standalone flowchart page's Download and Page: Portrait / Landscape setting are going into COM-1908 (lane D), not this task.

    To check on staging:
    - Download a PNG and an SVG from the canvas and from the reading view.
    - On a wide flowchart, click Yes, then check the PDF and Word file put it on its own landscape page with portrait pages either side.
    - Check a very wide flowchart prints in parts, with the lanes named on each.
- id: 01M7PVGWFG0E333890RYC0Q5E4
  author: Steve Vine
  at: 2026-11-18T08:14:10.41667Z
  text: |-
    Pre-UAT on staging faf46f33 — Passed (the standalone-page points went to COM-1908, tester B)
    Same document as COM-1904, v3, as E2E Admin A in E2E Test Company.
    - PNG and SVG downloads match the screen in the light theme: Passed from the canvas and from the reading view. From the canvas, Download ▸ PNG picture / SVG picture gave "e2e-pre-uat-very-large-flow-2026-11-18.png/.svg" (a 16000×962 PNG). From the Read tab's flowchart menu they were named after the caption and the date. With Compass switched to Dark, the downloaded PNG is still on white in the light house style (read-download-while-dark.png). The standalone flowchart page's Download moved to COM-1908 (builder's note), so it's tester B's to check.
    - The wide-flowchart hint, and Yes giving it its own landscape page with portrait either side: Passed. The hint "Wide flowchart: put it on a landscape page?" showed on the wide flowchart in the editor (01-editor-hint.png). Yes put a Landscape page before it and a Page break after it, and one Undo took both away. On a third flowchart, Dismiss hid the hint, and it stayed hidden after a reload (04-dismissed-after-reload.png). In v3.pdf the flowchart is on landscape pages 3–5 (842×595) with portrait pages 2 and 6 on either side. Word has a landscape section in the same place, with portrait sections either side. The dismissed flowchart stayed portrait.
    - A very large flowchart (26 shapes, two lanes) splits readably with lanes named on each part: Passed. It went onto landscape pages 7–9, headed "Part 1 of 6" to "Part 6 of 6 (continued)". Every part repeats "Requester" and "Approver", and the caption comes after the last part (v3-p7.png). Word has the same six parts.
    - A standalone flowchart prints in its Page setting's orientation: Couldn't check here. The builder moved it to COM-1908 (tester B). I saw the Page: Portrait / Landscape setting on a new standalone flowchart's Edit tab but didn't print one.
    Screenshots and files: ~/compass-uat/s6y6p7g/COM-1910/
assignee: steve
label:
- feature
priority: medium
task_status: done
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