---
id: 01M1YQBFMEPYCNRXQDCFRWMEV1
created: 2026-09-07T20:01:03.630486Z
updated: 2026-09-07T20:02:21.338819Z
type: task
title: 'Portal lists sort: Actions, Vendors, Recertifications'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 614
sprint: sa2t9sq
blocked_by:
- 01M1YQ9HPHK8C1QK2GFV1CYVBM
- 01M1YQAJHWCMWXW6AB0SXRBZ3F
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
The Compass Portal is what an ordinary employee sees, and its three pages are all lists. They sort the same way the internal app does — the portal is a different audience, not a different product.

## Pages

- **Actions** (`pages/PortalActionsPage.tsx`) — no work here: it renders the shared `actions/ActionsTable.tsx`, which *Posture lists sort* changes. Verify only, and check the `showOwner={false}` column set still sorts correctly.
- **Vendors** (`pages/PortalVendorsPage.tsx`) and the vendor detail it links to (`pages/PortalVendorDetailPage.tsx`)
- **Requests** (`pages/PortalRequestsPage.tsx`) — the requests an employee raised and the ones awaiting their approval
- **Recertifications** (`pages/PortalRecertificationsPage.tsx`) and a review in progress (`pages/PortalRecertReviewPage.tsx`)

## Notes

- The portal renders none of the internal navigation (ADR 0040 §2) and that stays true — this task reuses `SortableTh` and `sort.ts`, which are shared components, not navigation.
- A reviewer's outstanding items sort by due date by default, as they do now.

Tests: the three portal pages, reorder and reverse. `PortalRouting.test.tsx` must stay green untouched.
