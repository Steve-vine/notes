---
id: 01M7ZM1RQQN2QKMKH2NM9295GZ
created: 2026-11-21T17:56:44.91962Z
updated: 2026-11-21T17:58:04.205769Z
type: task
title: Any register as it stood on a date, and export to CSV, Excel or PDF — what an auditor asks for
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2082
sprint: s64t54m
blocked_by:
- 01M7ZM01R4WXTDT5YZ3SBHSXF7
assignee: steve
label:
- feature
priority: high
task_status: todo
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