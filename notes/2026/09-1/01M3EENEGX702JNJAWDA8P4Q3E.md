---
id: 01M3EENEGX702JNJAWDA8P4Q3E
created: 2026-09-26T08:52:45.725515Z
updated: 2026-09-26T08:52:48.533183Z
type: task
title: The Shared mailboxes tab is laid out like Users, Devices and Groups — titled filters, page size and "Showing x of y" top right, a fixed paging bar at the bottom
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 757
sprint: s3nfes0
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Found on staging, 2026-09-26, with the tenant's 270 shared mailboxes loaded. The Shared mailboxes tab doesn't follow the list convention the other Access Control tabs use (Users, Devices, Groups).

**Behaviour wanted, as on those tabs.**
- Each search box and filter has a **title above it**, not just a placeholder.
- **Top right:** the **page size selector** and **Showing x of y**.
- **Bottom:** a **fixed Previous / Next bar** that stays in view while the table scrolls, with **Records x–y of z**.
- Sorting by a column sorts the whole list, not just the page on screen.
- The chosen page size is remembered, the same way the other tabs remember theirs.

**Notes.** `SharedMailboxesPage.tsx` currently fetches up to 500 mailboxes in one request (`useSharedMailboxes`, `limit: 500`) and sorts them in the browser (`useClientSort`). The API (`GET /directory/shared-mailboxes`) already pages and sorts on the server (`limit`/`offset`/`sort`/`direction`). So this is a frontend change to the `DevicesPage.tsx` pattern: `PageSizeControl`, server sort through `SortableTh`/`toggleSort`, the fixed paging bar, the `useLocalStorage` page size, and resetting to page 1 when a filter changes. Keep the existing filters and the row links to the mailbox detail page. Update the page tests to stub the paged route.

Pairs with COM-756 (the "reading…" state lives on this same tab). Whichever lands second rebases onto the first.