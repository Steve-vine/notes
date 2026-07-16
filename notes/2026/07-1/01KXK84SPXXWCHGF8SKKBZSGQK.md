---
id: 01KXK84SPXXWCHGF8SKKBZSGQK
created: 2026-07-15T16:00:49.885949996Z
updated: 2026-07-16T07:14:18.398686308Z
type: task
title: Vendor review cadence + VendorReview model/API
assignee: steve
label:
- brief
task_status: review
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 173
blocked_by:
- 01KXK8323S7Y8BV1RN3HN4Q2X1
sprint: sxady3y
---
Phase 2 opener (ADR 0039 §4): the review-record entity and cadence.

- [x] `review_frequency_months` on `vendors` (+ revision snapshot extension, same migration — `VENDOR_SNAPSHOT_FIELDS` extended, the snapshot-contract unit test enforces it).
- [x] `models/vendor_review.py` — the `ContentReview` pattern: `reviewed_on`, `reviewer_id` SET NULL + snapshotted `reviewer_name`/`reviewer_job_title`, `findings`, plus `kind` (onboarding/annual/triggered) and `outcome` (satisfactory/findings/unsatisfactory). Append-only; NOT in `_AUDITED_TABLES` (it is the log).
- [x] `POST /vendors/{id}/reviews` [require_vendor_write] (reviewer = acting user, snapshotted) + `GET /vendors/{id}/reviews` [read], newest first.
- [x] Derived `next_review_at` on `VendorOut` (latest `reviewed_on` + cadence via the shared `add_months`, derived at read time — ADR 0025 ethos; batched for the list endpoint).
- [x] Integration tests (7): reviewer snapshot, ordering, derivation on detail + list + null cases, posture-untouched guard, cadence revision snapshot, role gating.

Migration 0037. Branch `feature/com-173-vendor-reviews`, PR #164. Ref: ADR 0039 §4, ADR 0032.