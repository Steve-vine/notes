---
id: 01M3EFZR83MC4SMFZVXQWE4Y06
created: 2026-09-26T09:15:51.939927Z
updated: 2026-09-26T09:15:54.619761Z
type: task
title: The Directory roles tab is laid out like Users, Devices and Groups — titled filters, page size and "Showing x of y" top right, a fixed paging bar at the bottom
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 758
sprint: s3nfes0
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Found on staging, 2026-09-26: the same gap as COM-757 (Shared mailboxes). The Directory roles tab doesn't follow the list convention the other Access Control tabs use (Users, Devices, Groups).

**Behaviour wanted, as on those tabs.**
- Each search box and filter has a **title above it**, not just a placeholder.
- **Top right:** the **page size selector** and **Showing x of y**.
- **Bottom:** a **fixed Previous / Next bar** that stays in view while the table scrolls, with **Records x–y of z**.
- Sorting by a column sorts the whole list, not just the page on screen.
- The chosen page size is remembered, the same way the other tabs remember theirs.
- The existing notice about eligible (PIM) assignments stays where it is. It says whether eligible holders could be read.

**Notes.** `DirectoryRolesPage.tsx` currently fetches up to 200 roles in one request (`useDirectoryRoles`, `limit: 200`) and sorts them in the browser (`useClientSort`). A tenant with more than 200 roles, counting custom ones, would silently lose the rest. The API (`GET /directory/roles`) already pages and sorts on the server (`limit`/`offset`/`order_by`/`direction`). So this is a frontend change to the `DevicesPage.tsx` pattern: `PageSizeControl`, server sort through `SortableTh`/`toggleSort`, the fixed paging bar, the `useLocalStorage` page size, and resetting to page 1 when the search changes. Check that every sortable column on the tab is an `order_by` the API accepts, and add any that are missing. Keep the row links to the role detail page. Update `DirectoryRolesPage.test.tsx` to stub the paged route.

Built the same way as COM-757; whichever lands second reuses anything the first factors out. `useDirectoryRoles` has other callers that may want the whole list, so check before changing its signature rather than repurposing it.