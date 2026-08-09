---
id: 01KZKCYTR3GG4ZP1P4T3RFGDYB
created: 2026-08-09T13:56:20.867744Z
updated: 2026-08-09T15:31:03.558389Z
type: task
title: Portal requests + internal Requests tab
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 195
sprint: sw3i5is
blocked_by:
- 01KZKCY1SV4CR8KEY7TZ8R989D
- 01KZKCYFXWJKTCWP0JED5RA3E9
comments:
- id: 01KZKJC7N7X68CJVX5NQW27BAE
  author: Steve Vine
  at: 2026-08-09T15:31:02.951573Z
  text: |-
    Implemented — PR #187 (branch feature/com-195-portal-requests, stacked on #186).

    **What was done**
    - `RequestVendorModal` extracted out of `OnboardingRequests.tsx`, shared by both surfaces; `useSubmitVendorOnboardingRequest` is portal-aware (`/portal/requests` vs `/vendor-onboarding-requests`, same service behind both).
    - `RequestEngagementModal` + `AmendEngagementModal`, reached from a "Request a change" card on the portal vendor page.
    - Portal **My requests** tab (`/portal/requests`) with per-area approval progress and one-click resubmit; portal shell gained Vendors / My requests tabs.
    - Internal tab: Kind column, kind filter, justification, and the amendment diff on the request detail.

    **Decisions made on the fly**
    - **Added `GET /portal/requests/{id}`** (backend, small). "Per-area approval status" was in the agreed scope and the list endpoint doesn't carry approvals; without it that promise would have been quietly dropped. Scoped to the requester and returns **404 not 403** for someone else's — a portal user shouldn't learn that a request they can't see exists. Still a GET, so the no-write-verb tripwire holds.
    - **The amendment modal sends only changed fields.** Echoing untouched ones is harmless server-side (null means unchanged either way) but would make the approver's diff overstate the change. Asserted by key in a test.
    - `KIND_LABELS` moved to `vendors/requestKinds.ts` — the fast-refresh lint rule rejects a file exporting both a component and a constant, the same reason `source.ts`/`VendorSourceProvider.tsx` are split.
    - **The request card mirrors the API's guards** rather than adding new ones: nothing offered on an offboarded vendor or an ended engagement, which COM-193 already refuses with 409/422.

    **Scope note**: the portal's request affordances render only for `canSubmitVendorRequest`, which `vendor_portal` holds — so a `viewer` browsing the portal reads it without being offered a request they'd be refused.

    **Tests**: 9 new — the portal list and progress modal (posts to the portal route and never the internal one; no approve/reject/request-info buttons), the amendment modal's sparse payload, the kind column and filter, and the approver's diff showing exactly the changed field while omitting untouched ones. Backend 336 integration green; frontend 230 green across repeated runs; ruff + mypy strict + eslint + tsc clean.

    **State**: PR #187 open against main, CI running. All five sprint tasks now in review — staging merge next.
assignee: steve
priority: medium
task_status: review
---
The three request flows in the portal, and the internal Vendors → Requests tab catching up with the new kinds. ADR 0040.

---

## Agreed work (planned with Claude, 2026-08-09)

**Scoping decisions (Steve):**
- The portal's "Request a new vendor" modal is **the same component** as the one on Vendors → Requests — extracted, not copied.
- The amendment modal is pre-filled from the current engagement and shows what changed, so an approver sees a diff rather than a wall of fields.
- Portal users see **their own** requests only (`GET /portal/requests`); vendor-managers/assessors keep the full list on the internal tab.

**Checklist:**
- [ ] Extract `RequestVendorModal` out of `vendors/OnboardingRequests.tsx` (~line 106) into `vendors/RequestVendorModal.tsx`, shared by both surfaces.
- [ ] `vendors/RequestEngagementModal.tsx` — new engagement on an existing vendor (scope, data types, residency, access requirements, sub-processors, justification).
- [ ] `vendors/AmendEngagementModal.tsx` — pre-filled from the engagement; submits only changed fields as `proposed_*`; renders a before/after summary.
- [ ] Portal vendor detail — "Request an engagement" action, plus "Request an amendment" per active engagement.
- [ ] Portal **My requests** tab — kind, vendor, status, submitted date, and per-area approval status; one-click resubmit when `info_requested`.
- [ ] Internal `vendors/OnboardingRequests.tsx` — Kind column, filter by kind, and the amendment diff on the request detail modal so approvers can decide.
- [ ] Tests: each modal's submit payload (incl. amendment sending only changed fields), the My-requests list, and the internal tab rendering all three kinds.
- [ ] PR to main, merge branch to staging.
