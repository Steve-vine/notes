---
id: 01KXK86E3SAMMHM8YJBCDCRN6J
created: 2026-07-15T16:01:43.545070707Z
updated: 2026-07-16T12:36:03.139479934Z
type: task
title: 'Approval execution: decisions, emails & vendor activation'
label:
- brief
assignee: steve
priority: medium
task_status: backlog
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 182
blocked_by:
- 01KXK864MG04VA4ZEG7HJQQ2DE
- 01KXK8685QZZ47RR80WAZJH8SA
sprint: sxngp10
---
Phase 3 (ADR 0039 §6): the approval workflow itself.

- [ ] Rule evaluation at submission → one `vendor_approvals` row per required area (pending; approver snapshot columns).
- [ ] Approve / reject / request-info endpoints [require_vendor_assess]; request status **derived** from its approvals.
- [ ] All approved → vendor `new→active`, `compliance_status→compliant`, onboarding `VendorReview` written (single activation helper). Any rejected → request rejected, vendor stays `new`.
- [ ] Notifications: `vendor_approval_pending` / decision kinds + target types (enum migration); Celery email task per approval-created/decided event via `core/email.send_email`; in-app rows dedup on the existing quadruple.
- [ ] Approvals UI: pending-approvals view for assessors, per-request approval matrix on the request detail.
- [ ] Tests: full happy path (submit → approvals → active), rejection, notification dedup.

Ref: ADR 0039 §6, ADR 0006.