---
id: 01KXK86E3SAMMHM8YJBCDCRN6J
created: 2026-07-15T16:01:43.545070707Z
updated: 2026-07-16T13:23:54.050103895Z
type: task
title: 'Approval execution: decisions, emails & vendor activation'
label:
- brief
assignee: steve
priority: medium
task_status: review
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 182
blocked_by:
- 01KXK864MG04VA4ZEG7HJQQ2DE
- 01KXK8685QZZ47RR80WAZJH8SA
sprint: sxngp10
---
Phase 3 (ADR 0039 §6): the approval workflow itself.

- [x] Rule evaluation at submission (COM-181's shared helper) → one `vendor_approvals` row per required area (pending; decider snapshot columns) + migration 0045. No configured areas → vacuously all-approved → immediate activation.
- [x] Decide endpoint [require_vendor_assess + area-approver membership, admin override]: one-shot (409 once decided), info_requested requires a comment (422). Request status **derived** from its approvals (rejected > approved-all > info_requested > in_review > submitted).
- [x] All approved → vendor `new→active`, `compliance_status→compliant` via the COM-174 review-outcome helper, onboarding `VendorReview` written (single activation helper). Any rejected → request rejected, vendor stays `new`.
- [x] Notifications: `vendor_approval_pending` / `vendor_approval_decided` kinds + `vendor_onboarding_request` target type (enum migration, add-only); in-app rows dedup (same-transaction flush) + best-effort email via `core/email.send_email` inline; requester notified on decisions; bell deep-links.
- [x] Approvals UI: per-request approval matrix with Approve/Reject/Request-info on the request detail modal; "Awaiting my approval" filter (`mine_to_approve`) for assessors.
- [x] Tests: happy path (in_review → approved + active/compliant + onboarding review + dedup), rejection + one-shot 409, membership/comment guards, mine_to_approve.

Branch `feature/com-182-approval-execution` (stacked on COM-181), PR #173. Ref: ADR 0039 §6, ADR 0006.