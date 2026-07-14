---
id: 01KXGXDES19FHZQFSWRK18HDPT
created: 2026-07-14T18:14:50.401200211Z
updated: 2026-07-14T18:15:04.386403335Z
type: task
title: Export to PDF for Managed content
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 155
sprint: ssdk92z
comments:
- id: 01KXGXDWE2XAJADR0WK7WSGNSM
  author: Steve Vine
  at: 2026-07-14T18:15:04.386066716Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-07-04 09:20 UTC]
    **Discussing first, as asked — this one does have real nuances.**

    **What Graph offers:** nothing. The [`driveItem …/content?format=pdf` endpoint](https://learn.microsoft.com/en-us/graph/api/driveitem-get-content-format) takes exactly one relevant parameter — `format` (`width`/`height` exist only for jpg thumbnails). There are no orientation, scaling, or fit-to options. Microsoft renders the PDF from **the document's own layout settings**:

    - **Word docs** — orientation comes from the document's page setup (Layout → Orientation).
    - **Excel workbooks** — the conversion honours the sheet's **print setup** (Page Layout → Orientation, Width/Height fit-to, print area), which is stored in the workbook and editable in Excel Online.

    **Options if we wanted in-app portrait/landscape + fit controls:**

    1. **Mutate the workbook's print setup via the Graph workbook API before exporting** (`workbook/worksheets/{id}/pageLayout` supports orientation + fitToWidth/fitToHeight). Nuances: it *writes to the shared SharePoint document* — changes everyone's print settings, bumps the SharePoint version history and eTag (cache churn), needs a **write** Sites.Selected grant where export is currently read-only, and it's **Excel-only** (there's no equivalent API for Word docs).
    2. **Bypass Graph and render locally** (download the file, LibreOffice with layout options). That abandons Microsoft's high-fidelity rendering — the whole reason ADR 0034 chose Graph — and reintroduces exactly the conversion-quality problems that led us to remove local conversion for uploads (DEV-817).

    **Recommendation:** don't add export options. Set the layout **in the document itself** — Excel Online: Page Layout → Orientation / fit-to-width; Word: Layout → Orientation — and the export renders exactly as it would print from Office. That's one setting, saved once, honoured by every future export, and it works for both Word and Excel. If useful, I can add a small hint next to the managed Export PDF button ("layout follows the document's print settings — set it in Excel/Word Online") as a cheap follow-up.

    Happy to go with option 1 (Excel-only, write-grant caveats above) if you'd rather have it in-app — say which way and I'll pick it up.
---
When performing an export to PDF from managed content in M365.  Can we add options for portrait or landscape and fit to width or fit to height.

If this is complex or has nuances, discuss first.

---
*Migrated from Linear [DEV-818](https://linear.app/stevevine/issue/DEV-818/export-to-pdf-for-managed-content) · created 2026-07-04 · completed 2026-07-04*  
*Related to (Linear): DEV-817*