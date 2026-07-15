---
id: 01KXK84SPXXWCHGF8SKKBZSGQK
created: 2026-07-15T16:00:49.885949996Z
updated: 2026-07-15T16:02:33.512647172Z
type: task
title: Vendor review cadence + VendorReview model/API
assignee: steve
label: brief
task_status: backlog
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 173
blocked_by:
- 01KXK8323S7Y8BV1RN3HN4Q2X1
---
Phase 2 opener (ADR 0039 §4): the review-record entity and cadence.

- [ ] `review_frequency_months` on `vendors` (+ revision snapshot extension, same migration).
- [ ] `models/vendor_review.py` — the `ContentReview` pattern: `reviewed_on`, `reviewer_id` SET NULL + snapshotted `reviewer_name`/`reviewer_job_title`, `findings`, plus `kind` (onboarding/annual/triggered) and `outcome` (satisfactory/findings/unsatisfactory). Append-only; NOT in `_AUDITED_TABLES` (it is the log).
- [ ] `POST /vendors/{id}/reviews` [require_vendor_write] + `GET /vendors/{id}/reviews` [read].
- [ ] Derived `next_review_at` on `VendorOut` (latest `reviewed_on` + cadence, derived at read time — ADR 0025 ethos).
- [ ] Integration tests.

Ref: ADR 0039 §4, ADR 0032.