---
id: 01M3WFRBHBCC91T534R462NXBN
created: 2026-10-01T19:41:11.595132Z
updated: 2026-10-01T19:42:48.305952Z
type: task
title: The last lists keep their filters in the address — Devices, Shared Mailboxes, Directory Roles, the report library, Activity and vendor Requests
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 832
sprint: s0zzctz
assignee: steve
label:
- improvement
priority: low
task_status: todo
---
Follow-up from sprint 65 (COM-805, COM-808, COM-812). COM-792 made "a list you come back to is the list you left" the convention: a list's filters, search, sort and page live in the address. The UI Upgrade kept six lists as they were, holding their filters on the page, because those tasks were layout only.

## What people see

On each of these lists, filters, search, sort and page survive the trail, Back, a refresh and a copied link. Choosing the list from the menu still opens it fresh:
- **Access ▸ Devices**
- **Access ▸ Shared Mailboxes**
- **Access ▸ Directory Roles**
- **Access ▸ Reports** (the report library: the Subject filter)
- **Activity** (Entity, Action, "<company> only", and the page)
- **Vendor Management ▸ Requests** (Status and Kind)

Nothing else about them changes.

## Notes (technical)

- **The pattern.** Move each list's `useState` filters to `components/useQueryState.ts` (`useQueryState`, `useQueryText`, `useQueryFlag`, `useQueryList`, `useQueryNumber`, `useQuerySort`), as COM-792 did for the others.
  - Mind [[url-backed-filters-flushsync]]: RR7 navigations are transitions, so writes compose per handler.
  - Keep `useTabParam`'s `?tab=` untouched where a list sits under a tab.
- **Parameter names.** Use names that don't clash with the page's other params. On Access Control the pop-ups own `user`, `group`, `device` and `policy` (`access/popupParam.ts`).
- **Server-paged lists** (Activity, the report library) send the URL values to their endpoints, as today's state does.
- **Pages:**
  - `access/DevicesPage.tsx`, `SharedMailboxesPage.tsx`, `DirectoryRolesPage.tsx`, `ReportLibraryPage.tsx`;
  - `pages/ActivityPage.tsx`;
  - the Requests tab in `pages/VendorsPage.tsx`.
- **Tests per list:**
  - opening an address with filters shows them applied;
  - changing a filter writes it to the address;
  - the menu (a bare address) opens it fresh.

**Done when:** on staging, each of the six lists comes back as you left it after following a link away and returning by the trail or Back.