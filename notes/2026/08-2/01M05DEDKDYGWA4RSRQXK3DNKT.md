---
id: 01M05DEDKDYGWA4RSRQXK3DNKT
created: 2026-08-16T13:51:11.469255Z
updated: 2026-08-16T14:21:42.651168Z
type: task
title: 'Portal: My Approvals tab + vendor_assessor becomes a portal-only role'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 226
sprint: sbph5q5
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Two coupled changes (decided 2026-08-16): the approval workflow joins the portal as **My Approvals**, and **`vendor_assessor` becomes portal-only** — like `vendor_portal`, an assessor can only view the portal, not the full app. Assessors do all their approving in the portal; the internal Requests tab remains for admins.

**ADR note:** amends the ADR 0039 role model (assessor was one of the three roles gating the internal Vendors section) and extends ADR 0040 (the portal gains the approval decision surface — its second write capability after COM-221 contacts). Record in ADR 0040.

**Role change**
- [ ] `vendor_assessor` removed from the internal vendor-read set (`_VENDOR_READ`) and added to portal read (`_PORTAL_READ`); assessor-only users land on `/portal` like `vendor_portal` users. `_VENDOR_ASSESS` (decide gate) unchanged in membership but now honoured via portal endpoints.
- [ ] Revisit `is_internal` / directory gating for assessors — My Approvals renders user names, so the directory (or names-in-payload) must be reachable under portal auth.
- [ ] Internal surfaces stay working for admins (Requests tab, Review surface, admin override).

**My Approvals tab**
- [ ] Portal tab **My Approvals**, visible only to users with the assess capability; tab order: All Vendors | My Vendors | My Requests | My Approvals.
- [ ] Content mirrors the COM-223 grouped list, scoped to **requests with an approval in my areas**: parent request row (vendor, kind, status, submitted, submitted-by) + approval sub-rows (area, approver, status, decided date, Review) — pending-mine first; decided history reachable via the status filter.
- [ ] **Review** opens the COM-224 read-only vendor view via the portal vendor detail — per-engagement boxes, target engagement highlighted, Approve / Reject / Request-info in the box, gated server-side on role + area membership.
- [ ] Portal router endpoints: list-my-approvals + decide (same service paths as internal — one enforcement boundary, two routers).
- [ ] Tests: assessor cannot reach internal app (403/redirect), portal decide allowed for area member with role / 403 otherwise, tab hidden for non-assessors, grouped rendering, admin internal path unchanged.