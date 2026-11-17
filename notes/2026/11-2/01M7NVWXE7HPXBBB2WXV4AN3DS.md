---
id: 01M7NVWXE7HPXBBB2WXV4AN3DS
created: 2026-11-17T23:01:30.183967Z
updated: 2026-11-17T23:02:15.542351Z
type: task
title: 'Library reader: a document full screen, with contents, reading progress and export'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1922
sprint: s2q1gxe
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
**Read document** opens the published document full screen, made for reading, as in the design's reader. Built on COM-1921.

**The bar (stays at the top as you scroll)**
- **← Library** back to where you were (the pane stays open on this document), the type icon and title, and once you scroll, the section you're in ("Access Control Policy · Exceptions").
- A thin progress line along the bottom of the bar shows how far through you are.
- **Contents**: a menu of the sections, the current one marked. Picking one scrolls to it.
- **Export**: PDF, Word, Markdown and Print. PDF and Word are the same files Content gives today. Markdown is the published text as plain Markdown. Print opens the browser's print dialogue with the reader's layout.
- **Open in Content** (for people who can see Content's editing screens) opens the document's page in Content to edit, review or publish.
- The light/dark switch, as elsewhere in Compass.

**The page**
- A comfortable reading column: type, "Version 7 · Reviewed Mar 2026", the title large, the summary beneath, then **Reviewers**, **Approved by** (whoever published this version) and **Next review**.
- Each section with its number and heading, and the document's text as Compass already shows it in the User Portal: lists, tables, notes, images, diagrams (and flowcharts, once Content Flowcharts is in).
- At the end: **Document control** (Version, Status, Reviewers, Classification, Last reviewed, Linked controls), **Back to top** and **Back to the Library**.

**Other kinds of document**
- An **uploaded PDF** shows in the reader page by page. An **uploaded Word or Excel file** shows its details and **Download**, since it can't be shown in the page. A **link** or **SharePoint** document shows its details and **Open document**, which opens it in a new tab.
- A **decision** reads like a document: its status and dates at the top, its text in sections.

**Done when**
- A templated document reads full screen with sticky bar, current section, progress, Contents, all four exports and Open in Content.
- Uploaded PDF, uploaded Word, link, SharePoint and decision each behave as above.
- Esc closes menus, then the reader. The reader has its own address, so a link to it opens it.
- Phone width: the column fits, the bar wraps or folds its buttons into a menu, no sideways scroll.

On the chain: a new Markdown export of a published document.