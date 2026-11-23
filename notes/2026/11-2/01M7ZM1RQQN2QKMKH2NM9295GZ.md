---
id: 01M7ZM1RQQN2QKMKH2NM9295GZ
created: 2026-11-21T17:56:44.91962Z
updated: 2026-11-23T00:37:34.095482Z
type: task
title: Any register as it stood on a date, and export to CSV, Excel or PDF — what an auditor asks for
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2082
sprint: s64t54m
blocked_by:
- 01M7ZM01R4WXTDT5YZ3SBHSXF7
comments:
- id: 01M81J4VBYNQBT3CN76KV5RF9T
  author: Steve Vine
  at: 2026-11-22T12:01:57.63021Z
  text: |-
    Done — merged in PR #2077. No migration.

    What changed for people:
    - The Entries tab has an As at date, today by default. A past day shows the register as it stood at the end of that day: only the entries that existed then, with their values then; entries archived by then under Archived with their reason; and fields removed since as columns with the values they held.
    - A banner reads "Showing the register as it stood on 31 March 2026 · Back to today". The list is read-only then (no Add entry or Import), but filters, search, sort and columns still work. The day is in the address, so the view can be shared.
    - Export offers CSV, Excel and PDF, each with "Columns on screen" or "All columns", following the as-at day, filters, search and order. One row per entry, ID first; Archived and its reason are added when archived entries are shown.
    - CSV is UTF-8 with a BOM. Excel keeps dates and numbers as such and has a second "Register" sheet with the register's details.
    - The PDF cover has the name, description, owner, editors, Shared or per company, the company (per-company registers), the controls it's kept for, the last review (from COM-2083) and "As at …". Every page carries "Exported by … on …" and "Page n of N". Long text wraps.
    - Files are named like "OBL legal and regulatory obligations as at 2026-03-31.xlsx". Anyone who can see the register can export it, and each export is in the activity log.
    - Browser smoke journey 12 shows a register on a past day and exports it.

    My calls (yours to overturn):
    - End of day is on the viewer's own clock: Compass keeps time zones per person, not per company (ADR 0121 §3).
    - Fields added after the chosen day are hidden in the as-at view. Fields removed since show under their plain name, with no "removed" mark.
    - "Incomplete" in the as-at view uses today's required-field rules.
    - Opening an entry from the as-at list shows the entry as it is now.
    - The CSV has no details block above the rows, so it stays one row per entry; Excel and the PDF carry the details.
    - Dates in the CSV and PDF follow the exporter's date format (UK "31 Mar 2026" by default).

    Worth knowing: an entry's links aren't shown as at a date (ADR 0167 replays them later). Exports are built while you wait, so a PDF of thousands of long rows could take a while.
- id: 01M82XCD8F9B7FRN1Q0FJWM862
  author: Steve Vine
  at: 2026-11-23T00:37:34.095235Z
  text: |-
    Pre-UAT on staging f73af7daf: Partly. One defect, raised as COM-2101.

    Method: I set the values on 22 Nov, changed them after midnight, then viewed 22 Nov.

    - A past date shows exactly what existed at the end of that day, including archived entries and removed fields, read-only: Passed. As at 22 Nov: ZMA-1 had its old Source and Amount 10 (999 today), ZMA-2 was not yet archived, ZMA-3 was under Archived with its reason, ZMA-10 was absent, and the removed Web page column showed its value. No Add entry or Import. COM-2082/as-at-22-nov.png, as-at-archived.png
    - CSV, Excel and PDF follow the date, filters and columns, and the PDF has the register's details on its cover and the exporter on every page: Partly. All three held the 22 Nov values. A filtered PDF held only the two "Not met" entries. The CSV starts with a byte-order mark, and Excel has a second Register sheet. Every PDF page carries the exporter and page number. The cover and the Excel details left out the last review (COM-2101). Files are in COM-2082/.

    Screenshots and exports are under ~/compass-uat/s64t54m/.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint "Registers" (ADR in COM-2076). Builds on COM-2078.

## What people see

**As at a date**
- The Entries tab has an **As at** date picker, defaulting to today.
- Choosing a past date shows the register as it stood at the end of that day:
  - the entries that existed then, with their values then
  - entries added later are left out
  - entries archived by then show as archived
  - fields removed since show, with the values they had
- A banner reads "Showing the register as it stood on 31 March 2026 · Back to today".
- The list is read-only while a past date is chosen. Sorting, filters, search and columns still work.
- The date is part of the address, so the view can be shared.

**Export**
- **Export** offers CSV, Excel and PDF. It exports what's on screen: the as-at date, the filters, and the chosen columns (or **All columns**).
- **CSV and Excel:** one row per entry. The entry ID comes first, then the fields, then "Archived" and its reason when archived entries are included. Excel adds a second sheet with the register's details.
- **PDF:**
  - A cover with the register's name, description, owner, editors, Shared or per company, the controls it's kept for, the last review (once COM-2083 lands), and "As at 31 March 2026". For a per-company register, the company.
  - Then a table of entries.
  - A footer on every page: exported by, exported on, page n of N.
  - Long text wraps; it isn't cut off.
- The file name says what it is: `OBL legal and regulatory obligations as at 2026-03-31.xlsx`.
- Anyone who can see the register can export it. The export is recorded in the activity log.

## Implementation notes (technical)

- As at: for each entry, take the latest revision at or before the end of the chosen day in the company's time zone (ADR 0121). Field names come from the current definitions, removed fields included.
- PDF through the same rendering path as the other Compass exports (WeasyPrint). Remember that importing weasyprint.pdf clobbers XML namespaces; keep the import local.
- Excel via openpyxl. CSV in UTF-8 with BOM, so Excel opens it cleanly.

## Done when
- Choosing a past date shows exactly the entries and values that existed at the end of that day, including archived entries and removed fields, and the view is read-only.
- CSV, Excel and PDF exports reflect the as-at date, filters and columns, and the PDF carries the register's details on its cover and the exporter on every page.

On the chain: API.