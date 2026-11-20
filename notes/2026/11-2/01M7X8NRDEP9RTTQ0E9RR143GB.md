---
id: 01M7X8NRDEP9RTTQ0E9RR143GB
created: 2026-11-20T19:59:28.174168Z
updated: 2026-11-20T19:59:46.643622Z
type: task
title: 'See the evidence itself: a preview beside its properties wherever a piece opens, and in the Add evidence window'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2047
sprint: s9hexqn
blocked_by:
- 01M7X872KVKRZNZYF83SCQQVS1
assignee: steve
label:
- feature
priority: medium
task_status: todo
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