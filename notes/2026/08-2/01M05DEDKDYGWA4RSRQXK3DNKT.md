---
id: 01M05DEDKDYGWA4RSRQXK3DNKT
created: 2026-08-16T13:51:11.469255Z
updated: 2026-09-01T13:55:50.63738Z
type: task
title: 'Portal: My Approvals tab + vendor_assessor becomes a portal-only role'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 226
sprint: sbph5q5
comments:
- id: 01M05GM7NYKTJ8J9HFNATENZ45
  author: Steve Vine
  at: 2026-08-16T14:46:47.742352Z
  text: |-
    Shipped as PR #225 (branch feature/com-226-portal-approvals, stacked on #224/COM-225) — awaiting CI.

    **Role change.** `vendor_assessor` becomes an outward-facing role beside `vendor_portal`: out of `_VENDOR_READ` and `_LIBRARY_READ`, into `_PORTAL_READ`, and out of `_INTERNAL` (so the user directory follows). The two are named together as `_PORTAL_ONLY` / `PORTAL_ONLY_ROLES` so the pair is a stated concept rather than two coincidences. `_VENDOR_ASSESS` untouched — this is about which surfaces they reach, not what they may decide. An assessor who also holds an internal role stays internal (capability is additive).

    **My Approvals.** Fourth portal tab, gated on the assess capability; order All Vendors | My Vendors | My requests | My Approvals. The COM-223 grouped list, scoped to requests with an approval in one of my areas, with Review opening the COM-224 read-only vendor view and the decision in the engagement box. Literally the same component as the internal tab — extracted to `vendors/RequestGroupTable.tsx`, picking its endpoints from the vendor-source context, so the two surfaces cannot drift.

    **Endpoints.** `GET /portal/approvals` (grouped server-side — here the grouping *is* the scope; carries every area on the request, not only mine, since deciding for Cyber while Legal has refused is a decision made blind), `GET /portal/approvals/{request_id}` (404 outside my areas), `POST /portal/approvals/{request_id}/{approval_id}/decide`. The decide route delegates wholesale to the internal handler's extracted `decide_from_body`, so one place still says who may decide, refuses a second decision and re-derives the request status.

    **Scoping decision:** strictly by approver rows, admins included — "what has been put to me", not "what exists". An admin named on no area sees nothing; the company-wide queue is the internal Requests tab, unchanged for admins and vendor-managers.

    **Directory:** resolved without widening anything — My Approvals renders names straight from the payload (`approver_names` / `decided_by_name`), and the review surface reaches colleagues through the existing `/portal/directory`.

    **ADR:** amendment appended to ADR 0040 (also amending ADR 0039 §8). No migration — the enum value exists and no data moves; an assessor-only account simply lands on `/portal` at next sign-in.

    **Tests:** backend — assessor 403s across the internal app while the portal stays open; grouped payload + per-area `can_decide`; scoping; the assess gate; Review 404 outside my areas; portal decide *is* the internal decision (activates the vendor, 409s twice, 403s for non-members and for a submit-only portal role); the portal write-tripwire list gains the decide route. Frontend — tab visible for assessors only, assessor bounced off `/vendors` to the portal, grouped rendering, Approve only on the `can_decide` row, decide posts to the portal route and never touches the internal one, Review fetches through the portal, empty state, status filter. Existing assessor-based tests moved to portal reads or to an admin approver, each with the reason recorded.
- id: 01M05GPSQXC7153W3QJSZ2CVW7
  author: Steve Vine
  at: 2026-08-16T14:48:11.773321Z
  text: 'PR moved: #225 was auto-closed by GitHub when its stacked base branch (COM-225''s) was deleted on merge. Same branch, rebased onto main and reopened as **PR #226**.'
assignee: steve
label:
- feature
priority: medium
task_status: done
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