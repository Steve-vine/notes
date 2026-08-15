---
id: 01M033K2GMCCPDJR85Z85AFWF8
created: 2026-08-15T16:20:29.33295Z
updated: 2026-08-15T18:09:53.794611Z
type: task
title: 'Requests tab: default to awaiting-approval + consolidated Approvals section with inline approve'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 216
sprint: sbph5q5
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Two fixes to the internal Requests tab (Vendors section):

**1. Open requests by default.** `GET /vendor-onboarding-requests` has no status filter, so the tab shows every request forever — approved/rejected included. Add a `status` filter to the endpoint; the tab defaults to open (`submitted` / `in_review` / `info_requested`) with a filter control Open / Approved / Rejected / All (decided 2026-08-15: history stays reachable — a rejected request is deliberately a kept record — just not in your face).

**2. Approvals section at the bottom of the tab.** Today approvals are only actionable inside each request's detail modal. Add a consolidated table below the requests list — one row per approval (request × area): vendor, request kind, approval area, status, decided by/when.

- [ ] Backend: approvals list endpoint (e.g. `GET /vendor-approvals?company=…&status=…`) joining approval → request → vendor → area, `require_vendor_read`; includes whether the **current user is an approver** for each pending row. OpenAPI regenerated.
- [ ] Shows **pending and decided** approvals, pending first; status filter.
- [ ] **Inline Approve** on pending rows where the current user is an approver — same `useDecideApproval` path as the modal (server stays the enforcement boundary). Reject / request-info stay in the request detail modal (they need a comment) — each row links to its request detail (decided 2026-08-15).
- [ ] Requests tab table + approvals table stay consistent after an inline decision (invalidate both queries; derived request status may flip to approved and drop out of the open view).
- [ ] Tests: status filter on both endpoints, approver-only inline approve (403 path unchanged), decided rows render decider + timestamp.