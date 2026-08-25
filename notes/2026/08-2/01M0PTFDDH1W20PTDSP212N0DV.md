---
id: 01M0PTFDDH1W20PTDSP212N0DV
created: 2026-08-23T08:06:00.881895Z
updated: 2026-08-25T18:43:14.843925Z
type: task
title: 'User portal: Requests tab becomes "My requests"'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 377
sprint: sbph5q5
comments:
- id: 01M0Q0XXXS1PEW9Z6P95PCDX5Q
  author: Steve Vine
  at: 2026-08-23T09:58:47.993066Z
  text: |-
    Done — PR #379, merged to main as 4f957a2.

    The portal tab and both page titles (the no-company state and the populated one) read **My requests**. The tab value and route are unchanged, so deep links and the `/portal/approvals` redirect that already-sent notification emails carry still land where they did.

    The admin `VendorsPage` Requests tab keeps its name, as scoped.

    Tests: the portal tab-label lists in `PortalRouting.test.tsx`, the two heading assertions, and the two test names that quoted the old label.
assignee: steve
company: null
label:
- improvement
priority: medium
task_status: done
---
Rename the user portal's **Requests** tab to **My requests** — it shows the caller's own submissions, and the unqualified name overstates it.

- [ ] `PortalVendorsSection.tsx:54`: tab label `Requests` → `My requests` (value/route unchanged — no deep links break).
- [ ] `PortalRequestsPage.tsx:83` and `:92`: the page `<Title>` matches the tab.
- [ ] The **admin** page's Requests tab (`VendorsPage.tsx:113`) is every company request and keeps its name — not in scope.
- [ ] Tests: whichever portal-tab tests assert the label list get the new string.