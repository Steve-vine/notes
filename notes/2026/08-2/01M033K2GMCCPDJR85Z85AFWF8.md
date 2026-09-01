---
id: 01M033K2GMCCPDJR85Z85AFWF8
created: 2026-08-15T16:20:29.33295Z
updated: 2026-09-01T13:55:50.31254Z
type: task
title: 'Requests tab: default to awaiting-approval + consolidated Approvals section with inline approve'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 216
sprint: sbph5q5
comments:
- id: 01M03AQZVCADDEMZZ8HEWY4GS9
  author: Steve Vine
  at: 2026-08-15T18:25:30.475986Z
  text: |-
    Done — PR #213 (feature/com-216-requests-approvals, stacked on #212 → #211). Both halves landed as specified.

    Status filter takes a *set*, not a single value, because "open" is three statuses. The API default stays unfiltered — history is deliberately kept, and which slice to show is the client's call, not the endpoint's; the tab is what defaults to open.

    GET /vendor-approvals is read-only by design and there's a test asserting it: deciding still posts to the request route, so there's one write path, one place enforcing who may decide, and one place deriving a request's status from its approvals. A second decide endpoint on the queue would be a second chance to get that derivation wrong.

    can_decide is server-computed, as the task implied — worth spelling out why: the client would need each area's approver list to work it out, and that's a vendor-manager surface a vendor-owner cannot read. It gates the button only; the API still enforces.

    Inline Approve only, per your decision. Every row (including ones the caller can't decide) has an Open button into the request detail, where reject and request-info live with their comment box.

    Two things I added that weren't in the task:
    - **aria-labels on both tables.** Adding a second table made three existing assertions ambiguous, which is the same ambiguity a screen-reader user would hit. Naming them fixed both.
    - **The empty state distinguishes** "Nothing awaiting a decision" from "No requests match those filters" — the first would be a lie with a kind filter applied.

    Sorting is Python-side, not SQL: the order is a ranking of the status enum, and Postgres would sort by its own declaration order instead.

    Backend 388 integration passing; frontend 276. OpenAPI regenerated. No migration.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Two fixes to the internal Requests tab (Vendors section):

**1. Open requests by default.** `GET /vendor-onboarding-requests` has no status filter, so the tab shows every request forever — approved/rejected included. Add a `status` filter to the endpoint; the tab defaults to open (`submitted` / `in_review` / `info_requested`) with a filter control Open / Approved / Rejected / All (decided 2026-08-15: history stays reachable — a rejected request is deliberately a kept record — just not in your face).

**2. Approvals section at the bottom of the tab.** Today approvals are only actionable inside each request's detail modal. Add a consolidated table below the requests list — one row per approval (request × area): vendor, request kind, approval area, status, decided by/when.

- [ ] Backend: approvals list endpoint (e.g. `GET /vendor-approvals?company=…&status=…`) joining approval → request → vendor → area, `require_vendor_read`; includes whether the **current user is an approver** for each pending row. OpenAPI regenerated.
- [ ] Shows **pending and decided** approvals, pending first; status filter.
- [ ] **Inline Approve** on pending rows where the current user is an approver — same `useDecideApproval` path as the modal (server stays the enforcement boundary). Reject / request-info stay in the request detail modal (they need a comment) — each row links to its request detail (decided 2026-08-15).
- [ ] Requests tab table + approvals table stay consistent after an inline decision (invalidate both queries; derived request status may flip to approved and drop out of the open view).
- [ ] Tests: status filter on both endpoints, approver-only inline approve (403 path unchanged), decided rows render decider + timestamp.