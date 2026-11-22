---
id: 01M7X8NRDEP9RTTQ0E9RR143GB
created: 2026-11-20T19:59:28.174168Z
updated: 2026-11-22T08:13:22.191749Z
type: task
title: 'See the evidence itself: a preview beside its properties wherever a piece opens, and in the Add evidence window'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2047
sprint: s9hexqn
blocked_by:
- 01M7X872KVKRZNZYF83SCQQVS1
comments:
- id: 01M7Y4YN28T5WMKSERAX81RM40
  author: Steve Vine
  at: 2026-11-21T04:13:39.784102Z
  text: |-
    Done and merged to main (PR #2039). No migration.

    What changes:
    - Opening any piece of evidence (from the register, Archived or a record's row) shows the file beside its details, "Used in" and EVD ID. There's a Full screen view (Esc comes back), and Download stays.
    - How each kind shows:
      - PDF: every page, scrolling, with zoom, "Fit to width" and "Page 3 of 12".
      - Image: fitted to the space, with zoom.
      - Text: as text, wrapped, in a fixed-width font.
      - CSV: a table with its header row. A big one shows the first 1,000 rows and says so.
      - Web address: the address, its title and Open (new tab), never embedded.
      - Collected evidence: what was captured, as the check's own page shows it.
    - Word, Excel and PowerPoint preview from the PDF copy in COM-2048. The screen already shows "Preparing a preview…" and updates without a reload.
    - In the Add evidence window:
      - Add new: the chosen file previews before upload, between the list and its details (above the details on a phone). Office files say "Preview after upload".
      - Link existing: clicking a row previews it beside the register, while ticking still only picks.
    - Archived evidence previews, marked Archived. Restricted evidence previews only for people who may see it. Files are never shown as a page on Compass's own site: PDFs are drawn by a viewer, text is shown as text, and images only as images.

    Checked in headless Chromium: PDF pages draw, nothing scrolls sideways at phone width, and both tabs of the window lay out from 1024 to 1680 px wide.

    Calls for you to overturn:
    1. Downloads inside the app aren't recorded anywhere today; only the auditor portal records its own. So each preview is written to the server log ("Evidence previewed", with who and which piece), not to the Activity log.
    2. Someone who can see Audit but not collected checks sees the filed PDF of a capture rather than the capture table.
    3. A Library document's preview space says "A document in the library." with "Open in the library".

    Known limit: PDFs relying on fonts they don't embed fall back to system fonts, and some Chinese, Japanese or Korean text, or JPEG 2000 images, may not draw. Typical evidence PDFs show fine.
- id: 01M7YNB83856X4882Q908X4QQ4
  author: Steve Vine
  at: 2026-11-21T09:00:09.704228Z
  text: |-
    Passed (pre-UAT, staging 7e04d3f5e, E2E Admin A, E2E Test Company), with two parts I couldn't check.

    Opening a piece (from the register, or /audit/evidence/EVD-n):
    - PDF: EVD-68 (2 pages) shows "Page 1 of 2", zoom − / + and "Fit to width". On EVD-61, zoom in went 165% → 206% and Fit to width went back to 165%. The details, "Used in" and Classification sit on the right. Download stays.
    - Full screen shows the preview alone, with the name, Download and a close. Esc came back to the page.
    - Image (EVD-62, PNG): shown in an image view at 100% with zoom and Fit.
    - Text (EVD-65): shown as text in a fixed-width font. A long line in EVD-70 wraps.
    - CSV (EVD-63, 1,500 rows): a table with its header row and "Showing 1,000 of 1,500 rows: download for all".
    - Web address (EVD-64): its title, the address, Open and "Opens in a new tab". Nothing is embedded.
    - Archived: EVD-9 and EVD-70 preview their text under the "Archived" banner.
    - At phone width (390 px) the evidence page stacks with the PDF preview full width, and nothing scrolls sideways.

    In the Add evidence window:
    - Add new: the selected file previews between the list and its details. I checked a PDF ("Page 1 of 1"), a PNG, the CSV (with the 1,000-row note), a dropped .txt and the web address (Open). A Word file shows "Preview after upload".
    - Link existing: clicking a row previewed EVD-68 beside the register ("EVD-68 · …", Download, Full screen, Page 1 of 2), and its tick was unchanged. In Mark done on SAP-85 the same preview showed the certificate before I linked it.

    Couldn't check:
    - Collected evidence: E2E Test Company has no Collection integration (none may be added there), so there's no collected capture. Built-in check pieces (EVD-21 to EVD-32) open the check's own page (e.g. CHB-4 "No dormant accounts" with its capture table) rather than the evidence page, so there's no "Used in" or EVD-ID heading for them. Steve: check that this is what you want for a check's line in the register.
    - Restricted evidence previewing only for people who may see it: there's no restricted piece (such as a signed contract) in E2E Test Company to try.

    Screenshots: ~/compass-uat/s9hexqn/COM-2047/
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Built to the ADR in COM-2038, after COM-2042. Steve (2026-11-20): clicking a piece of evidence (in the register, for example) opens its properties, but you can't see the evidence itself. Downloading it just to look is clunky.

**What people see**
- **Wherever a piece of evidence opens** (from the register, or from any record it's on), its window shows **the file beside its properties**. The preview fills most of the window, and the properties, "Used in" (COM-2040) and its EVD ID sit alongside. A **Full screen** button shows the preview alone, and Esc comes back. **Download** stays.
- **By kind of file:**
  - **PDF:** every page, scrolling, with zoom, fit to width, and "page 3 of 12".
  - **Images** (PNG, JPEG, GIF, WebP): fitted to the space, with zoom.
  - **Text:** as text, wrapped, in a fixed-width font.
  - **CSV:** as a table with its header row. A large file shows the first 1,000 rows and says so ("Showing 1,000 of 48,213 rows: download for all").
  - **Word, Excel, PowerPoint:** previewed from the PDF copy Compass makes (COM-2048). Until that's ready, it says "Preparing a preview…", and if it can't be made, "No preview for this file", with Download.
  - **A web address:** the address, its title, and **Open** (new tab). Most sites refuse to be shown inside another page, so there's no embedded view.
  - **Collected evidence and built-in check results:** what was captured (the records and the verdict), as its own view shows it today, in the same space.
- **In the Add evidence window** (COM-2041, COM-2042):
  - **Add new:** the selected file previews before it's uploaded, between the list and its properties (or above the properties on a narrow screen). That makes it easier to choose the type and dates. Office files there show "Preview after upload".
  - **Link existing:** the highlighted row previews beside the register, so you can check it's the right certificate before linking it. Ticking still picks; clicking a row previews it.
- **Archived evidence** previews too, marked Archived. **Restricted evidence** previews only for the people who may see it. A preview is a read, and it's recorded wherever downloads are recorded today.

**Implementation notes**
- Never render an uploaded file as a page on Compass's own origin. Draw PDFs with pdf.js, show text as text (never HTML), parse CSV in the browser, and use images only in an img element. Serve preview bytes with the same permission check as Download, plus nosniff and a restrictive CSP.
- One preview component shared by the evidence window and the Add evidence window. Respect screen conventions; check it at phone width.

**Done when**
- Opening any piece of evidence shows the file beside its properties: PDFs, images, text and CSV as above, web addresses with Open, and collected evidence as captured. There's a full-screen view.
- The Add evidence window previews the selected file (Add new) and the highlighted row (Link existing).
- Restricted evidence previews only for people who may see it.

On the chain: API change.