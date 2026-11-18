---
id: 01M7NVWXE7HPXBBB2WXV4AN3DS
created: 2026-11-17T23:01:30.183967Z
updated: 2026-11-18T13:00:19.165969Z
type: task
title: 'Library reader: a document full screen, with contents, reading progress and export'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1922
sprint: s2q1gxe
blocked_by:
- 01M7NVWGKPG8VCS53VSXD35S43
comments:
- id: 01M7Q77FPH5Q0P63AC5K8EHP2F
  author: Steve Vine
  at: 2026-11-18T11:38:45.329093Z
  text: |-
    Done: merged as PR #1931 (2f6d4bda). All PR checks passed. No migration.

    What a person can now do:
    - **Read document** in the reading pane opens the published document full screen, at its own address. A link to it opens it.
    - **The bar stays at the top:**
      - **← Library** goes back with the pane still open.
      - The type icon and title, then the section you're in once you scroll.
      - A thin progress line shows how far through you are.
      - **Contents** marks the current section; picking one scrolls to it.
      - **Export**: PDF and Word (the published version, as Content gives), **Markdown** (new, `<slug>-v<N>.md`) and **Print** (only the reading column prints).
      - **Open in Content** for people who can edit Content (Open in Decisions for a decision).
      - The light/dark switch.
    - **The page:**
      - type · version · last reviewed, the title, the summary;
      - Reviewers, Approved by (whoever published this version) and Next review;
      - the text as the User Portal shows it, each section numbered;
      - at the end, Document control, Back to top and Back to the Library.
    - **Other kinds:**
      - An uploaded PDF shows in the page.
      - An uploaded Word or Excel file shows what it is and Download.
      - A link or SharePoint document shows Open document in a new tab.
      - A decision reads like a document, with its sections taken from its headings, and can also be exported as Markdown.
    - **Esc** closes a menu first, then the reader.
    - **On a phone** the column fits, and Export, Open in Content and the colour switch fold into one More menu. No sideways scroll.
    - **Pick up where you left off:** opening a document in the reader puts it at the front.
    - **Browser smoke:** now opens the reader from the pane and comes back with Esc.

    Choices made, for Steve to overturn:
    1. The reader covers the whole window, including Compass's top bar, and carries its own way back. It's marked as a full-screen exception to the screen conventions.
    2. Section numbers follow the document's house style: a house style that doesn't number headings shows none. Decisions are always numbered.
    3. Pictures in the Markdown link to Compass, which needs a sign-in to open them.
    4. Print is offered only for documents whose text shows in the page, not for files, links or SharePoint.
    5. A SharePoint document's PDF is whatever SharePoint makes now, not a fixed published version.

    Not yet checked in a browser: a real house style, an uploaded PDF in the page, and real flowcharts. Those are for the pre-UAT pass on staging.
- id: 01M7QBWTTX8QKY34RKS00MT0C0
  author: Steve Vine
  at: 2026-11-18T13:00:19.165735Z
  text: |-
    Pre-UAT (staging build c15afb4d, E2E Test Company, E2E Admin A and E2E Viewer): **Passed**, with some document kinds **Couldn't check**. One cosmetic defect was raised as a new task: section headings are dimmer than the text in dark mode.

    Steps and what was seen:
    - **Opening:** Read document opens full screen at its own address (/library/read/content/<slug>?folder=…).
    - **The bar:**
      - ← Library and the title, then the current section once scrolled ("Access Control Policy · 5.4 Leavers").
      - The progress line.
      - Contents, which jumps to a section.
      - Export, Open in Content and the light/dark switch.
    - **The page:**
      - "Policy · Version 5 · Reviewed Nov 2026", the title, Reviewers, Approved by and Next review.
      - Numbered sections, with 5.1–5.4 nested.
      - At the end, Document control, Back to top and Back to the Library.
    - **Export:**
      - PDF opens the published PDF.
      - Word downloads access-control-policy-v5.docx.
      - Markdown downloads access-control-policy-v5.md.
      - Print is in the menu, and with print styling the bar is hidden.
      - Through the API, the Markdown has proper headings, lists and tables. A document with unpublished changes exports its published version. A never-published document is refused.
    - **Esc:** the first closes an open menu, the second returns to the Library with the pane still open.
    - **Decision (DEC-6):** reads like a document (Context, Decision, Consequences, Document control). Export offers Markdown and Print, and the bar has Open in Decisions.
    - **Flowcharts:** render in the reader (the COM-1904 flowchart document's three flowcharts load).
    - **Viewer:** no Open in Content.
    - **Phone (390px):** the column fits. The bar folds into Contents plus a More menu (Export, Open in Content, Colour scheme).

    Defect: in dark mode the section headings are a fixed mid-grey, dimmer than the body text. In light mode they're near-black. Screenshots: COM-1922/06, 10.

    Couldn't check an uploaded PDF in the page, an uploaded Word/Excel file's Download, or a link/SharePoint document's Open document: staging has none published. **Steve:** read one of each on data that has them.

    Note for Steve: a flowchart document in the reader shows its "Landscape page" and "Page break" markers, and one lane label is clipped ("ustome" for Customer). Both look like Flowcharts-sprint matters.

    Screenshots and the Word and Markdown files: ~/compass-uat/library/COM-1922/01–13.
assignee: steve
label:
- feature
priority: medium
task_status: review
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