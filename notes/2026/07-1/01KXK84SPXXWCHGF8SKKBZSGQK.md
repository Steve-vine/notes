---
id: 01KXK84SPXXWCHGF8SKKBZSGQK
created: 2026-07-15T16:00:49.885949996Z
updated: 2026-07-16T07:24:37.02869872Z
type: task
title: Vendor review cadence + VendorReview model/API
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 173
sprint: sxady3y
blocked_by:
- 01KXK8323S7Y8BV1RN3HN4Q2X1
comments:
- id: 01KXMWDR8Y0919ZV3MMMDDSAP6
  author: Steve Vine
  at: 2026-07-16T07:14:29.278251709Z
  text: |-
    Build complete on feature/com-173-vendor-reviews; PR #164 open against main, branch merged to staging. Sprint 27 opener.

    **What was done**
    - review_frequency_months cadence on vendors, snapshotted into vendor_revisions (same migration, 0037); VendorReview model on the ContentReview pattern with kind/outcome enums; GET/POST /vendors/{id}/reviews (reviewer snapshotted from the acting user); next_review_at derived at read time from latest reviewed_on + cadence via the shared core/due.add_months, batched for the list endpoint.
    - 7 integration tests including an explicit guard that recording a review does NOT move compliance_status/state — that is COM-174's single helper per ADR 0039 §4's "one helper owns posture" rule.

    **Local verification**: ruff + format, mypy src, 84 unit + 23 integration, Semgrep p/default clean.

    **Decisions made on the fly**
    - vendor_reviews.vendor_id FK is CASCADE (the content_reviews shape) — moot in practice since vendors soft-delete, but keeps the pattern verbatim.
    - next_review_at is a date (not datetime like content's stored column) since it's pure derived date arithmetic.
    - Cadence bounds 1–120 months at the schema layer.
- id: 01KXMX09S4KYHX8Y8W7QQN5B4A
  author: Steve Vine
  at: 2026-07-16T07:24:37.028475718Z
  text: 'Released: PR #164 squash-merged to main as 5e51007 (COM-173: Vendor review cadence + VendorReview model/API). Main-push CI (test suite + production deploy) triggered; feature branch deleted. Marking Done.'
assignee: steve
label:
- brief
priority: medium
task_status: done
---
Phase 2 opener (ADR 0039 §4): the review-record entity and cadence.

- [x] `review_frequency_months` on `vendors` (+ revision snapshot extension, same migration — `VENDOR_SNAPSHOT_FIELDS` extended, the snapshot-contract unit test enforces it).
- [x] `models/vendor_review.py` — the `ContentReview` pattern: `reviewed_on`, `reviewer_id` SET NULL + snapshotted `reviewer_name`/`reviewer_job_title`, `findings`, plus `kind` (onboarding/annual/triggered) and `outcome` (satisfactory/findings/unsatisfactory). Append-only; NOT in `_AUDITED_TABLES` (it is the log).
- [x] `POST /vendors/{id}/reviews` [require_vendor_write] (reviewer = acting user, snapshotted) + `GET /vendors/{id}/reviews` [read], newest first.
- [x] Derived `next_review_at` on `VendorOut` (latest `reviewed_on` + cadence via the shared `add_months`, derived at read time — ADR 0025 ethos; batched for the list endpoint).
- [x] Integration tests (7): reviewer snapshot, ordering, derivation on detail + list + null cases, posture-untouched guard, cadence revision snapshot, role gating.

Migration 0037. Branch `feature/com-173-vendor-reviews`, PR #164. Ref: ADR 0039 §4, ADR 0032.