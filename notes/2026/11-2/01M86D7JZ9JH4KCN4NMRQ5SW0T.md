---
id: 01M86D7JZ9JH4KCN4NMRQ5SW0T
created: 2026-11-24T09:12:16.617249Z
updated: 2026-11-24T14:14:12.247072Z
type: task
title: 'Portal vendor list: a Department column and a Department filter'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2135
sprint: sectbn9
blocked_by:
- 01M86D6PYBFKFKDPT119X18TKV
comments:
- id: 01M86YGD1M09RDWRKGQB89JDJ2
  author: Steve Vine
  at: 2026-11-24T14:14:11.25249Z
  text: |-
    Built and merged to main: PR #2131 (f06eec21f). No migration. The API gains a Department filter on the vendor lists.

    What people see:
    - Portal → Vendors and My Vendors have a new sortable Department column: the departments of the vendor's live (proposed or active) engagements, each once, in the company's department order. "Not recorded" when its live engagements have none; blank when it has no live engagement.
    - Each engagement sub-row shows its own department ("Finance (Retired)" for a retired one, or "Not recorded").
    - A Department filter in the filter bar lists the company's departments (retired ones marked) plus "Not recorded". Several can be chosen; a vendor matches if any live engagement is in any of them.
    - The filter is kept in the page address by department, not name, so a link still works after a rename or retirement.
    - Ended engagements count for neither the column nor the filter: ending a vendor's only Finance engagement takes it out of the Finance filter.
    - The server applies the filter, so counts and paging are right. The same filter is ready on the Compass vendor list (used by COM-2136).
    - Polaris's "list vendors" takes departments by name (or "Not recorded") and shows each vendor's departments.

    Tested: backend integration for both lists, several departments, Not recorded, a mixed vendor, a vendor with no engagement, ending an engagement, rename and retire, and counts. A Polaris test too. Vitest covers the column, sub-rows, filter choices, the repeated filter values sent, and the filter read back from the address. CI green.

    For Steve to decide:
    1. A vendor is under "Not recorded" only when none of its live engagements has a department. A vendor with one Finance engagement and one older engagement without one shows "Finance" and filters under Finance only.
    2. A vendor with no live engagements shows a blank and isn't under "Not recorded".
    3. Sorting goes by the vendor's first department in the company's order. "Not recorded" comes after every department, and blanks come last.

    Not checked yet: seen in a browser (staging pre-UAT).
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Sprint "Vendor Departments" (Steve, 24 Nov 2026). Follows COM-2133.

## Why
Steve: the department shows as a new column in the vendor list in the user portal, with a filter, so people can find their department's vendors.

## What people see
- Portal → Vendors (and My Vendors): a new **Department** column.
  - A vendor's row lists the departments of its live (proposed or active) engagements, each once, in the company's department order.
  - Each engagement sub-row under the vendor shows its own department.
  - A vendor whose live engagements have none recorded reads "Not recorded".
  - The column can be sorted.
- A **Department** filter sits in the filter bar with the others. Its list holds the company's departments (retired ones included, marked) and **Not recorded**. Choosing one or more shows vendors with a live engagement in any of the chosen departments.
- The filter is kept in the page address like the other filters, so a filtered list can be bookmarked or shared, and it survives going into a vendor and back.
- Ended engagements don't count towards the column or the filter, matching how the other engagement-based filters work.

## Done when
- In E2E Test Company, with vendors whose engagements are in Finance, IT and none: the column shows the right departments, filtering by Finance shows only vendors with a live Finance engagement, and filtering by Not recorded shows those without.
- A vendor with engagements in two departments appears under either filter and shows both names in the column.
- Ending a vendor's only Finance engagement takes it out of the Finance filter.
- Renaming a department changes the column and the filter's label. The filter in the address keeps working after a rename, because it holds the department, not its name.
- The filter is applied by the server (counts and paging are right), not only on screen.

## For the build
- Server: a `department` query param (repeatable, plus a `none` value for Not recorded) on `GET /portal/vendors` (portal.py L233) and on the admin `GET /vendors` / counts so the shared helper stays one. Add it in `core/vendor_reads._other_filter_clauses` (L403) as an EXISTS over live engagements, the same shape as the `access` filter (~L420–436).
- Department names per vendor: from `VendorEngagementSummaryOut` (gains department in COM-2133), via `live_engagements_by_vendor`.
- UI: `pages/PortalVendorsPage.tsx` `PortalRegister` (columns L244–267, sub-rows ~L322–345, `SortColumns` L126). Add `useQueryState('department')` beside the others (L106–112), a `FilterButton` in the `FilterBar` (L186–220), and pass it through `VendorFilters` / the `useVendors` queryKey (`vendors/hooks.ts` ~L83/L104).
- New table column: follow screen conventions (`SortableTh`, pills don't truncate; `screen-conventions.test.ts`).
- Polaris: add the same filter to `vendors_list_vendors` (`assistant/tools/vendors_register.py` L144) so "which of Finance's vendors…" works.
- Not in scope unless Steve asks: the same column and filter on the Compass (admin) vendor register, and a Department column in the vendor register report.
- Probably **on the chain**: API change (new filter param).