---
id: 01M02XK3FX2VH3BZXCHFH3V20P
created: 2026-08-15T14:35:38.877816Z
updated: 2026-08-15T15:10:16.138569Z
type: task
title: 'Portal: move "Request a new vendor" from My requests to the Vendors tab'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 211
sprint: sbph5q5
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
The "Request a new vendor" button lives in the portal's **My requests** page header (`PortalRequestsPage.tsx:52`), but the natural moment to ask for a vendor is while looking at the register and not finding it — the **Vendors** tab, which today offers no way to raise one.

- [ ] Move the button + `RequestVendorModal` mount from `PortalRequestsPage` to the `PortalVendorsPage` header (a move, not a duplicate — My requests becomes purely the tracking view).
- [ ] My requests empty state points the user at the Vendors tab ("Request one from the Vendors page").
- [ ] Tests updated for both pages.

No backend change; independent of the COM-208/209/210 stack so it can merge on its own.