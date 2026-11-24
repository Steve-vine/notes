---
id: 01M86HPF3RR0MGQAEW9M9PG28Y
created: 2026-11-24T10:30:18.488638Z
updated: 2026-11-24T15:17:47.927397Z
type: task
title: The vendor register report gains a Departments column
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2137
sprint: sectbn9
blocked_by:
- 01M86D6PYBFKFKDPT119X18TKV
comments:
- id: 01M86V7BMN7WXC8G6HFFYNT5MH
  author: Steve Vine
  at: 2026-11-24T13:16:49.172992Z
  text: |-
    Built and merged to main: PR #2129 (ec1f62fee). No migration, no API change.

    What people see:
    - Reports → Vendor register (CSV and PDF) has a new Departments column after the existing eight, which keep their names and order.
    - It lists the departments of each vendor's live (proposed or active) engagements, each once, in the company's department order, comma-separated. An ended engagement's department isn't listed, and the cell is blank when there are none.
    - The PDF's column widths were rebalanced so all nine fit on landscape A4. Long names, emails and a four-department list wrap cleanly in a rendered sample.
    - Polaris's vendor register overview returns each vendor's departments, and its summary counts vendors per department.
    - The Vendor register card on Reports now mentions departments.

    Tested: backend integration covers two departments (with a repeat and an ended engagement in a third), one department, none, and order by the company's arrangement. The register test pins the nine columns, and the Polaris report test checks the rows and per-department counts. CI green.

    For Steve to decide: a retired department still shows under its name when a live engagement has it, matching the engagement card.

    Not checked yet: the report downloaded from the app on staging (the PDF was checked from a locally rendered sample).
- id: 01M8724W8Q79F16AFZ5RZ52DVK
  author: Steve Vine
  at: 2026-11-24T15:17:47.927187Z
  text: |-
    Pre-UAT on staging (0234a65f3), E2E Test Company: **Passed**.
    - CSV: nine columns. The original eight are unchanged in name and order, with Departments last. Vendor A "Finance, Operations, IT"; Vendor B "IT" (its ended Finance engagement isn't listed); E2E Test Vendor blank.
    - PDF: landscape A4, one page, nine columns with Departments last.
    - Polaris's vendor register overview returns Departments per row, and per-department counts.
    - Couldn't check: the PDF's look by eye (no PDF viewer on the test machine; its text and page size were checked). Steve, please open one.
    Files: ~/compass-uat/sectbn9/COM-2137/vendor-register.csv and .pdf
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Sprint "Vendor Departments" (Steve, 24 Nov 2026). Follows COM-2133. Steve asked for it after the sprint was planned.

## What people see
- Reports → **Vendor register**, as a spreadsheet (CSV) or PDF, has a new **Departments** column: the departments of each vendor's live (proposed or active) engagements, each once, in the company's department order, separated by commas. Blank when none is recorded, like the report's other empty cells.
- It's added **after the existing columns**, so a spreadsheet built on the current file keeps working. The report puts new columns at the end for this reason (the risk register did the same).
- The PDF fits the extra column without the other columns becoming unreadable.
- Polaris's vendor register overview (which reads the same report) shows each vendor's departments.

## Done when
- In E2E Test Company, the CSV and PDF both show the right departments for a vendor with two departments, one with one, and one with none.
- An ended engagement's department isn't listed.
- The existing eight columns are unchanged in name and order.
- Polaris's `overview_vendor_register` returns the departments.

## For the build
- `api/v1/reports.py` `vendor_register` (~L214): append "Departments" to `header` and to each row, and add a width to the PDF column-width list (currently `[56, 26, 28, 22, 50, 42, 22, 22]`; rebalance if the PDF overflows). Load departments for all vendors in one query (live engagements joined to departments), not per vendor.
- `assistant/tools/reports.py` `overview_vendor_register` (~L375) parses the CSV: pick up the new column there.
- Update `pages/ReportsPage.test.tsx` and the report's backend tests if they pin the columns.
- **Independent**: no migration and no change to the API's shape (it's the file's contents). Branch from main once COM-2133 has merged.