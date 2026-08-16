---
id: 01M02XK3FX2VH3BZXCHFH3V20P
created: 2026-08-15T14:35:38.877816Z
updated: 2026-08-16T16:18:24.728428Z
type: task
title: 'Portal: move "Request a new vendor" from My requests to the Vendors tab'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 211
sprint: sbph5q5
comments:
- id: 01M02ZXTN5CPC3Q5JG514GJ7BF
  author: Steve Vine
  at: 2026-08-15T15:16:27.429728Z
  text: |-
    Done — PR #204 (feature/com-211-portal-request-button → main).

    The button + RequestVendorModal mount moved from PortalRequestsPage's header to PortalVendorsPage's, a move rather than a duplicate: My requests is now purely the tracking view, and its empty state reads "Request one from the Vendors page."

    Tests moved with the button. PortalVendorsPage's "offers no way to add or edit a vendor" case became "offers no way to edit a vendor — only to ask for one": it now asserts the request button IS there while register/add/edit/delete affordances stay absent, and it carries the submit-to-/portal/requests assertion that used to live on the requests page.

    Frontend only, no backend change, no schema regeneration. Independent of the COM-208/209/210 stack.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
The "Request a new vendor" button lives in the portal's **My requests** page header (`PortalRequestsPage.tsx:52`), but the natural moment to ask for a vendor is while looking at the register and not finding it — the **Vendors** tab, which today offers no way to raise one.

- [ ] Move the button + `RequestVendorModal` mount from `PortalRequestsPage` to the `PortalVendorsPage` header (a move, not a duplicate — My requests becomes purely the tracking view).
- [ ] My requests empty state points the user at the Vendors tab ("Request one from the Vendors page").
- [ ] Tests updated for both pages.

No backend change; independent of the COM-208/209/210 stack so it can merge on its own.