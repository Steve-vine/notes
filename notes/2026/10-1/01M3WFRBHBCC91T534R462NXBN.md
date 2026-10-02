---
id: 01M3WFRBHBCC91T534R462NXBN
created: 2026-10-01T19:41:11.595132Z
updated: 2026-10-02T08:52:13.688006Z
type: task
title: The last lists keep their filters in the address — Devices, Shared Mailboxes, Directory Roles, the report library, Activity and vendor Requests
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 832
sprint: s0zzctz
comments:
- id: 01M3WM087AR4T1JDQJKQBJF0GM
  author: Steve Vine
  at: 2026-10-01T20:55:24.650039Z
  text: |-
    Merged: PR #833 (8b3b2c7).

    Each of the six lists now comes back as you left it — after following a link away and returning by the trail or Back, after a refresh, and from a copied link. Choosing the list from the menu still opens it fresh.

    - Access ▸ Devices — search, the four filters, sort, page
    - Access ▸ Shared Mailboxes — search, source, sort, page
    - Access ▸ Directory Roles — search, sort, page
    - Access ▸ Reports — search, Subject, sort
    - Activity — Entity, Action, "<company> only", sort, page
    - Vendor Management ▸ Requests — Status, Kind, "Awaiting my approval", sort

    Two things beyond what the task named: "Awaiting my approval" and the column sort on vendor Requests are kept too. And the Requests filters stay put when you switch to another Vendor Management tab and back, the same way the register's own filters already do.

    To check on staging: set a filter on each, open a row or follow a link, come back by the trail.

    Technical: the lists' useState moved to the useQueryState hooks (the COM-792 pattern). The Requests tab shares its address with the vendor register, which already owns `status` and `sort`, so it uses `request-status` and `request-sort`. The vendor portal's My Approvals is unchanged. Three tests per list, plus the Devices filters surviving an open device pop-up.
assignee: steve
label:
- improvement
priority: low
task_status: done
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