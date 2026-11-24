---
id: 01M86HPF3RR0MGQAEW9M9PG28Y
created: 2026-11-24T10:30:18.488638Z
updated: 2026-11-24T10:30:23.489842Z
type: task
title: The vendor register report gains a Departments column
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2137
sprint: sectbn9
blocked_by:
- 01M86D6PYBFKFKDPT119X18TKV
assignee: steve
label:
- feature
priority: medium
task_status: todo
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