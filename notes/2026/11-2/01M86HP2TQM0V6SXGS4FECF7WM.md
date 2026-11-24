---
id: 01M86HP2TQM0V6SXGS4FECF7WM
created: 2026-11-24T10:30:05.911877Z
updated: 2026-11-24T14:36:50.516651Z
type: task
title: 'Compass vendor register: a Department column and a Department filter'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2136
sprint: sectbn9
blocked_by:
- 01M86D7JZ9JH4KCN4NMRQ5SW0T
comments:
- id: 01M86ZSVQ6TJZEA5CCQRDTKVVJ
  author: Steve Vine
  at: 2026-11-24T14:36:49.766806Z
  text: |-
    Built and merged to main: PR #2132 (4a29a087b). No migration. Screen only: COM-2135 had already added the filter to the Compass vendor list and counts.

    What people see (Vendors → Register in Compass):
    - A new Department column between Certified and Flags: the departments of the vendor's live (proposed or active) engagements, each once, in the company's department order. "Not recorded" when none has one; blank when the vendor has no live engagement.
    - The column sorts by the company's department order, then Not recorded, then blanks.
    - A Department filter under More filters (next to Access and Flag): every department (retired ones marked) plus Not recorded. Several can be picked.
    - The filter is kept in the page address by department, so a rename changes the label but a bookmark still works. Like the other filters, it shows whenever it's set.
    - The counts (quick-filter chips and the Register tab count) follow the filter.
    - It uses the same server filter and the same column code as the portal list, so the answers match.

    Tested: Vitest for the column (order, Not recorded, blank), sorting both ways, the filter's choices and two picked (list and counts both carry them, the address keeps them), and the filter read back from the address. Existing register tests updated. CI green.

    For Steve to decide:
    1. The Compass register has no engagement sub-rows (the portal list does), so "each engagement sub-row shows its department" has nothing to attach to here. I didn't add sub-rows, which would redesign the register's rows.
    2. The filter sits behind More filters rather than on the first row.
    3. On narrow screens the column is hidden, as Criticality, Certified, Flags and Owner already are.

    Not checked yet: seen in a browser (staging pre-UAT).
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Sprint "Vendor Departments" (Steve, 24 Nov 2026). Follows COM-2135. Steve asked for it after the sprint was planned: the same column and filter as the portal, on the vendor register inside Compass.

## What people see
- Vendors (the register in Compass): a new **Department** column. It works exactly as on the portal list (COM-2135):
  - the departments of the vendor's live (proposed or active) engagements, each once, in the company's department order;
  - each engagement sub-row shows its own department;
  - "Not recorded" when none of its live engagements has one;
  - the column can be sorted.
- A **Department** filter in the register's filter bar: the company's departments (retired ones included, marked) plus **Not recorded**. Choosing one or more shows vendors with a live engagement in any of them.
- The filter is kept in the page address like the register's other filters, and the register's counts follow it.

## Done when
- In E2E Test Company, the register's column and filter give the same vendors as the portal list for the same department.
- Filtering by Not recorded shows vendors whose live engagements have no department.
- Renaming a department changes the column and the filter's label, and a bookmarked filter still works.
- The counts shown with the register match the filtered list.

## For the build
- The server filter (`department` param, EXISTS over live engagements in `core/vendor_reads._other_filter_clauses`) arrives on the admin `GET /vendors` and the counts route in COM-2135. Check it's there, and add it if COM-2135 only touched the portal route.
- UI: `pages/VendorsPage.tsx`. Add `useQueryState('department')` beside the others (~L135–141), a `FilterButton` in its `FilterBar`, the column, and the sub-row label. Reuse whatever COM-2135 built for the portal (department filter options, the column cell) rather than writing it twice.
- Screen conventions: `SortableTh` for the new column (`screen-conventions.test.ts`).
- **Independent** if COM-2135 already added the admin filter (UI only). Otherwise on the chain (API change).