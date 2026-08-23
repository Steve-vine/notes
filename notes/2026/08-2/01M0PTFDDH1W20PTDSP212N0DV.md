---
id: 01M0PTFDDH1W20PTDSP212N0DV
created: 2026-08-23T08:06:00.881895Z
updated: 2026-08-23T08:06:07.400343Z
type: task
title: 'User portal: Requests tab becomes "My requests"'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 377
sprint: sbph5q5
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Rename the user portal's **Requests** tab to **My requests** — it shows the caller's own submissions, and the unqualified name overstates it.

- [ ] `PortalVendorsSection.tsx:54`: tab label `Requests` → `My requests` (value/route unchanged — no deep links break).
- [ ] `PortalRequestsPage.tsx:83` and `:92`: the page `<Title>` matches the tab.
- [ ] The **admin** page's Requests tab (`VendorsPage.tsx:113`) is every company request and keeps its name — not in scope.
- [ ] Tests: whichever portal-tab tests assert the label list get the new string.