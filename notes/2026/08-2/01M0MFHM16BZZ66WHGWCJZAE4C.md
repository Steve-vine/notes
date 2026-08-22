---
id: 01M0MFHM16BZZ66WHGWCJZAE4C
created: 2026-08-22T10:16:29.990222Z
updated: 2026-08-22T11:26:13.515432Z
type: task
title: Compliance status Review Due — a compliant vendor past its review date says so
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 353
sprint: sbph5q5
assignee: steve
label:
- feature
priority: medium
task_status: active
---
A vendor that was judged `compliant` stays `compliant` forever, however overdue its next review — the reminders job nags the owner but the record itself keeps asserting a judgment that has expired. Add **`review_due`** to `VendorComplianceStatus`: when a compliant vendor reaches its review date, its compliance status changes to Review Due.

- [ ] Enum: add `review_due` to `vendor_compliance_status` (in-place `ADD VALUE` is enough — nothing is being dropped).
- [ ] **The flip lives in `core/vendor_posture.py`** — that module's contract is "the single place compliance_status is written", and a scheduled writer elsewhere would break it. Add a function (e.g. `apply_review_due(vendor) -> bool`) and have the daily Beat job call it from the existing vendor scan in `tasks/reminders.py`, which already computes `next_due = latest review + review_frequency_months` — same query, one more effect, a revision written when it changes.
- [ ] Rule: only `compliant → review_due`. `under_review` and `non_compliant` already carry a stronger claim; `not_assessed` has nothing to expire.
- [ ] Recovery is free: recording the review runs `apply_review_outcome`, which overwrites `review_due` with the new judgment — assert it with a test rather than adding a path.
- [ ] Decide the edge: a vendor with no `review_frequency_months` or no completed review never becomes `review_due` (nothing to be due against) — matches the reminders scan's own guards.
- [ ] Frontend: badge colour/label in `statusColors.ts`, filters on VendorsPage/PortalVendorsPage, summary tile counts.
- [ ] Tests: compliant vendor crosses next_due → review_due + revision; already-due runs are idempotent (no second revision); under_review/non_compliant untouched; new review restores the judged status.