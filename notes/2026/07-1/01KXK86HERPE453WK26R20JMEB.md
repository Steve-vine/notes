---
id: 01KXK86HERPE453WK26R20JMEB
created: 2026-07-15T16:01:46.968592191Z
updated: 2026-07-16T13:24:00.310864719Z
type: task
title: Request-more-info loop (onboarding)
assignee: steve
label:
- brief
priority: medium
task_status: active
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 183
blocked_by:
- 01KXK86E3SAMMHM8YJBCDCRN6J
sprint: sxngp10
---
Phase 3 (ADR 0039 §6): the info-requested round-trip on onboarding requests.

- [ ] Approver requests info (comment required) → request `info_requested`, requester notified (in-app + email).
- [ ] Requester edits answers and resubmits [require_vendor_submit, own requests only] → that approval resets to `pending`, approver notified.
- [ ] UI: info-requested banner + inline comment thread on the request detail; resubmit action.
- [ ] Tests: approval reset semantics, both notification directions, ownership guard.

Ref: ADR 0039 §6.