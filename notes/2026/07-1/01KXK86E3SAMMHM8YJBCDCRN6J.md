---
id: 01KXK86E3SAMMHM8YJBCDCRN6J
created: 2026-07-15T16:01:43.545070707Z
updated: 2026-07-16T18:50:40.738697196Z
type: task
title: 'Approval execution: decisions, emails & vendor activation'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 182
sprint: sxngp10
blocked_by:
- 01KXK864MG04VA4ZEG7HJQQ2DE
- 01KXK8685QZZ47RR80WAZJH8SA
comments:
- id: 01KXNHJAKTT8G4DDRRNXBYBMEN
  author: Steve Vine
  at: 2026-07-16T13:23:59.226051301Z
  text: |-
    Build complete on feature/com-182-approval-execution (stacked on COM-181); PR #173 open against main, branch merged to staging.

    Decisions worth flagging:
    - Zero configured approval areas → submission auto-approves and activates immediately (vacuous all-approved; keeps the pre-workflow behaviour sensible for companies that haven't set up areas).
    - Emails go inline via core/email.send_email (best-effort no-op without SMTP) rather than a new Celery task — the task text said Celery, but a broker dependency in the request path would need eager-mode plumbing in tests, and send_email is non-blocking today; migrate to a task when real SMTP delivery lands (the Email capability candidate task).
    - Activation reuses COM-174's _apply_review_outcome so posture still has exactly one owner; the onboarding VendorReview is authored by the final approver.
    - Approver notifications dedup per (user, kind, request) — an approver across multiple areas gets one notification.

    Local verification: ruff + format, mypy src, 88 unit + 11 integration, 187 Vitest, build, Semgrep clean.
assignee: steve
label:
- brief
priority: medium
task_status: done
---
Phase 3 (ADR 0039 §6): the approval workflow itself.

- [x] Rule evaluation at submission (COM-181's shared helper) → one `vendor_approvals` row per required area (pending; decider snapshot columns) + migration 0045. No configured areas → vacuously all-approved → immediate activation.
- [x] Decide endpoint [require_vendor_assess + area-approver membership, admin override]: one-shot (409 once decided), info_requested requires a comment (422). Request status **derived** from its approvals (rejected > approved-all > info_requested > in_review > submitted).
- [x] All approved → vendor `new→active`, `compliance_status→compliant` via the COM-174 review-outcome helper, onboarding `VendorReview` written (single activation helper). Any rejected → request rejected, vendor stays `new`.
- [x] Notifications: `vendor_approval_pending` / `vendor_approval_decided` kinds + `vendor_onboarding_request` target type (enum migration, add-only); in-app rows dedup (same-transaction flush) + best-effort email via `core/email.send_email` inline; requester notified on decisions; bell deep-links.
- [x] Approvals UI: per-request approval matrix with Approve/Reject/Request-info on the request detail modal; "Awaiting my approval" filter (`mine_to_approve`) for assessors.
- [x] Tests: happy path (in_review → approved + active/compliant + onboarding review + dedup), rejection + one-shot 409, membership/comment guards, mine_to_approve.

Branch `feature/com-182-approval-execution` (stacked on COM-181), PR #173. Ref: ADR 0039 §6, ADR 0006.