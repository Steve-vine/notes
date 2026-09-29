---
id: 01M3Q1MWKEX1VCTV4N78W9DE2A
created: 2026-09-29T16:58:25.774316Z
updated: 2026-09-29T16:58:42.389065Z
type: task
title: A list you come back to is the list you left — its filters, search and sort are kept
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 792
sprint: svq5edz
blocked_by:
- 01M3Q1KNEKD2T05ABE65Q66FHX
- 01M3Q1KY6JGTF6H3A7D6JGZYJW
- 01M3Q1MC23VB6W88RDE9H5401R
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
The trail (COM-787) returns you to the right page, tab and scroll position. On most lists, though, the filters you'd set are lost as soon as you leave. Say you filter Risks to *High, Open, owner: me*, open one, and follow a link or two. Clicking the Risks step brings back the full, unfiltered register. The browser's Back does the same today.

## What people see

- **Clicking a list's step, or pressing Back, restores the list as you left it.** Its filters, search text, sort and page are kept, and so is its scroll position (COM-787).
- **Copying the address of a filtered list gives the filtered list**, so "the open high risks" can be sent to someone.
- **Choosing the list from the menu gives it fresh.** It's a new trail, so it opens with no filters. Content and the Role matrix are the exceptions: they remember their filters for the whole browser tab today, and they keep doing so.

## Notes (technical)

- **Move list state into the URL query**, written with `replace: true` so typing doesn't create a history entry per keystroke. The trail step's URL then carries it with no extra machinery. A small shared hook (`useQueryState`, alongside `useTabParam`) is better than per-page code.
- **Lists that keep filters in local `useState` today:** Controls, Domains, Gaps, Risks, Frameworks, Actions, Users, Groups, Requests, the Assessments queue and the Timeline period.
- **Vendors and Inventory** seed from the URL once and never write back (`VendorsPage.tsx:95-99`, `InventoryPage.tsx:143-148,349,575`). Make that two-way.
- **Content and Roles** keep filters in `sessionStorage` (`ContentPage.tsx:116,132`, `access/RolesPage.tsx:37,73`). Keep that behaviour: fall back to it when the URL has no params, and write to both.
- **Page size** stays in `useLocalStorage` (Users, Groups). It's a preference, not a place.
- **Scroll.** `AppLayout.tsx:62-64` only resets scroll on a pathname change, so a query-only change doesn't jump. Good.
- **Ordering.** This task touches the same list pages as the section tasks. Do it after them to avoid conflicts.

**Done when:** on staging, the Risks register filtered, then a risk, then a control, then clicking the Risks step, returns the filtered register at the same scroll. The same holds for Gaps, Controls and Users.