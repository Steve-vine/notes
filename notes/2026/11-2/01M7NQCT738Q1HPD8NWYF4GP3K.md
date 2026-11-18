---
id: 01M7NQCT738Q1HPD8NWYF4GP3K
created: 2026-11-17T21:42:48.291201Z
updated: 2026-11-18T08:12:12.941823Z
type: task
title: 'A flowchart on its own: a new kind of Content with its own page, versions and reviews'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1907
sprint: s6y6p7g
blocked_by:
- 01M7NQCFPN3J6MAF8T53B8BTZ6
comments:
- id: 01M7PGDMXDB5W69VBP2H46XK0R
  author: Steve Vine
  at: 2026-11-18T05:00:10.029791Z
  text: |-
    Done — PR #1907, merged e250d420.
    New content ▸ Flowchart makes a flowchart of its own: a title, content type, owner, domain and review cycle, like any document.
    Its page shows it large (zoom, pan, full screen), then its description and its steps in words. The Edit tab opens the same canvas a document's flowchart uses, plus a Description box.
    Draft, Publish, versions, Revert, review and Mark as reviewed all work as for any document. Compare versions says what changed in words: steps added, removed, reworded, moved lane, links changed.
    It reads "Flowchart" in the Content list and its Kind filter. Search finds it by its step labels, lane names and description. PDF, Word and plain text come out in its type's house style.
    A step's document link, and a Hand-off, can point at a standalone flowchart (the picker marks them, and a Hand-off lists them first). A control lists the standalone flowcharts whose steps link to it.
    Assumption: the export captions the picture with the flowchart's title.
    To check on staging: the standalone page's Download (PNG/SVG), Page: Portrait/Landscape setting and Import from… come with COM-1908's PR, because COM-1910 and COM-1911 landed after this one.
- id: 01M7PVD9RD7MP7M1YXYG3ESD5Y
  author: Steve Vine
  at: 2026-11-18T08:12:12.941591Z
  text: |-
    Pre-UAT on staging faf46f33 — Passed
    All as E2E Admin A, in E2E Test Company.
    - Create, edit, publish, revert, review: New content ▸ Kind "Flowchart — drawn here on a canvas" made "E2E pre-UAT COM-1907 Service request handling" (Procedure, Incident Management). Drew Start/End → Step → Decision → Step with a Yes label, added a description, published v1. Its page showed it large with zoom, full screen and download, then the description and the steps in words. Changed it (reworded a step, added a No branch, a lane "Front desk", a link to IMA.4) and published v2. Mark as reviewed recorded a review of v2. Revert on v1 brought v1 back as the draft (canvas and description); published as v3. Passed.
    - Compare versions in words: v1 → v2 listed "Lane added", each "moved lane: no lane → Front desk", "Step reworded", "now links to Control IMA.4", "Step added", "Connection added (No)", "Its description changed". Passed.
    - Content lists and Kind filter: Kind has Flowchart; filtered list shows it with a FLOWCHART badge. Passed.
    - Search: found by a step label ("Close the request"), by a lane name ("Front desk", on the Lucidchart-imported flowchart) and by its description. Search reads the draft, so v2-only words stopped matching after the revert. Passed.
    - Attestations: a business role's Add content offers it once published (a flowchart that's in draft isn't offered, same as a document). Passed.
    - Activity log: created / updated / version entries for each flowchart. Passed.
    - Exports: PDF (portrait title page + the flowchart page), Word (two sections, the picture) and plain text (its steps) all download. With links, PDF and Word carry a Links list. Passed.
    - A step in another flowchart can link to it: in "…Document C (own flowchart) flowchart", Link a document and a Hand-off both picked it (marked "(flowchart)", listed first). Its Read page and PDF Links list show both links. Passed.
    - On its page (from COM-1908): Download PNG and SVG work, Page: Portrait/Landscape works, and Import from… works. One problem with Page is reported on COM-1908.
    Observations: the Links list words a standalone flowchart link as "Document …"; the Hand-off picker also offers the flowchart itself; after Revert the item reads "Draft" everywhere, even though v2 was published.
    Screenshots: ~/compass-uat/s6y6p7g/COM-1907/
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Builds on COM-1906. Steve, 2026-11-17: a flowchart can be a piece of Content in its own right, as well as part of a document (ADR 0160, COM-1903).

**What people see**
- **Create ▸ Flowchart** in Content, next to the existing kinds of document. A flowchart has a title, a content type (e.g. Process or Procedure, whatever types the organisation uses), an owner, a domain and a review cycle, as any document does.
- **Its page** shows the flowchart large, with zoom, pan and full screen, using the same canvas for editing (COM-1904/1905/1906: shapes, lanes, links). Under it, a short description and the plain-text steps.
- **Same lifecycle as any document:** draft, Publish, versions with Compare versions, Revert, review cycle and Mark as reviewed (ADR 0149: a review is always of a published version), linked controls, attestations (people can be asked to read and accept it), the activity log, and the Content lists and filters. A flowchart reads "Flowchart" wherever a document's kind is shown.
- **Search** finds a flowchart by its title, step labels, lane names and descriptions.
- **Export:** PDF and Word give the flowchart on its own, with the house style's title page and its Links list (COM-1906). Plain text gives its steps.
- **Links into it:** a step's Links (COM-1906) and a Hand-off can now point at a standalone flowchart.
- **Deleting:** a flowchart that's never been published can be deleted as any draft can. Rules for a flowchart that a document shows arrive with COM-1908.

**Done when**
- An author can create, edit, publish, revert and review a standalone flowchart, and compare its versions in words (steps added, removed, reworded, moved lane, links changed).
- It shows in the Content lists, search, attestations and the activity log like any document, and its PDF, Word and plain-text exports work.
- A step in another flowchart can link to it.

On the chain: a new kind of Content (a migration) and API changes.