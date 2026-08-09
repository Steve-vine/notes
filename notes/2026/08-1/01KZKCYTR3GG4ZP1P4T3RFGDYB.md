---
id: 01KZKCYTR3GG4ZP1P4T3RFGDYB
created: 2026-08-09T13:56:20.867744Z
updated: 2026-08-09T13:56:36.591748Z
type: task
title: Portal requests + internal Requests tab
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 195
sprint: sw3i5is
blocked_by:
- 01KZKCY1SV4CR8KEY7TZ8R989D
- 01KZKCYFXWJKTCWP0JED5RA3E9
assignee: steve
priority: medium
task_status: todo
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
