---
id: 01M0N4GG6BPQ47RE7ASHNYHEW0
created: 2026-08-22T16:22:53.387736Z
updated: 2026-08-22T16:55:19.707757Z
type: task
title: Compliance is earned by review — activation lands Not Assessed
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 361
sprint: sbph5q5
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Approval currently *grants* compliance: `activate_vendor` (`vendor_requests.py`) writes an auto-satisfactory onboarding `VendorReview` and applies it, so a vendor is `compliant` the moment the last approver clicks — before the supplier has answered a single assessment question. Decided 2026-08-22: **compliance is earned, and a Review is the only way a user changes it** (reasons captured on the Review tab, as today).

The model:
- vendor added/approved → **`not_assessed`**
- all required assessments completed and a **satisfactory review** recorded → `compliant`
- **unsatisfactory review** → `non_compliant`
- vendors whose assessment rules require nothing **stay `not_assessed`** — Compliant is only ever earned by a review, and an uncovered vendor showing green would hide a hole in the rules

## Changes

- [ ] `activate_vendor`: stop writing the auto-satisfactory review and stop calling `apply_review_outcome`. Activation sets `active` and leaves compliance at `not_assessed`. Decide whether any onboarding record replaces the dropped review row — the request + approvals already record the decision, so probably nothing.
- [ ] Consequence to verify: with no review row, the review-cadence scan has no anchor for new vendors — cadence starts from the **first real review**, which is correct under this model; assert it rather than assume it.
- [ ] `apply_review_outcome` itself is untouched — it remains the single writer, now fed only by actual reviews.
- [ ] Review tab: show the vendor's required-assessment completion state as context beside the record-review form, and **decide**: recording a satisfactory review while required assessments are outstanding — blocked, warned, or allowed? (Recommend warn, not block: the reviewer is the judgment, the rule is advice.)
- [ ] ADR amendment (0039 §4/§6 territory): the compliance model — earned via review, activation is not a review, the full status meanings including the companion tasks' dormancy and cadence rules. One ADR covering the model; COM-362/COM-363 implement against it.
- [ ] Tests: activation → active + not_assessed, no review row; satisfactory/unsatisfactory review drive compliant/non_compliant; rule-less vendor stays not_assessed indefinitely.