---
id: 01M1YQBFMEPYCNRXQDCFRWMEV1
created: 2026-09-07T20:01:03.630486Z
updated: 2026-09-08T00:02:11.966825Z
type: task
title: 'Portal lists sort: Actions, Vendors, Recertifications'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 614
sprint: sa2t9sq
blocked_by:
- 01M1YQ9HPHK8C1QK2GFV1CYVBM
- 01M1YQAJHWCMWXW6AB0SXRBZ3F
comments:
- id: 01M1Z5504V58CT7SDE4MHR9XZT
  author: Steve Vine
  at: 2026-09-08T00:02:11.227165Z
  text: |-
    Done — PR #628 merged to main.

    - Actions: no change needed — the portal renders the shared ActionsTable, sortable since COM-611. Verified with showOwner={false}: no Owner heading to click, Due still sorts.
    - Vendors: name; state, compliance, criticality (ADR 0060 ladder, worst first) and certification by rank; flags by count then name — the same ranks as the internal register. A vendor's engagement sub-rows stay under it.
    - Requests (My requests): vendor, kind, status by lifecycle (what is waiting on me first), submitted as a date; a request's summary lines stay under it. The Approve slice is RequestGroupTable, sortable since COM-612.
    - Recertifications: entity, triggered, rows decided, owners submitted, my status — the ones still needing me first. A review in progress: member, memberships, decision (undecided first), set by; the arrival order stays the default.
    - The portal renders none of the internal navigation (ADR 0040 §2); SortableTh and sort.ts are shared components, not navigation. PortalVendorDetailPage has no table.

    Tests: the three portal pages reorder and reverse with aria-sort; Actions verified with the Owner column hidden. PortalRouting.test.tsx untouched and green. One wrinkle worth knowing: the portal Actions page refetches once the company resolves and rebuilds its table behind a loading gap, so a test has to wait for the company-scoped fetch before clicking a heading.
assignee: steve
label:
- feature
priority: medium
task_status: review
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
