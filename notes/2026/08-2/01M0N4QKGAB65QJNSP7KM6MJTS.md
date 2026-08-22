---
id: 01M0N4QKGAB65QJNSP7KM6MJTS
created: 2026-08-22T16:26:46.154175Z
updated: 2026-08-22T16:26:52.271561Z
type: task
title: Review modal sets compliance explicitly — a dropdown, defaulted from the outcome
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 364
sprint: sbph5q5
blocked_by:
- 01M0N4GG6BPQ47RE7ASHNYHEW0
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Today the review outcome *implies* the compliance status through a fixed mapping (`apply_review_outcome`: satisfactory → compliant, findings → under_review, unsatisfactory → non_compliant). Since the Review is the only user lever on compliance (COM-361's model), let the reviewer say what they mean: a **Compliance** dropdown on the record-review modal, so the resulting state is explicit rather than inferred.

- [ ] Modal: a Compliance dropdown alongside Outcome. It **defaults from the outcome** via the existing mapping as the outcome is picked, and the reviewer may override — e.g. a satisfactory review that still leaves the vendor `under_review` while one finding is verified.
- [ ] Selectable values: `compliant`, `under_review`, `non_compliant`. **Not `not_assessed`** — that means "never judged", and a recorded review is a judgment; offering it would let a review un-happen. If a case for it emerges, that's a model change for the ADR, not a dropdown option.
- [ ] Backend: the review payload carries the chosen `compliance_status`; `apply_review_outcome` (or a successor signature) applies the explicit choice — still the single writer, now taking instruction instead of inferring it. The chosen status is **stored on the `VendorReview` row** so the record shows what the reviewer set, not just what the mapping would have said.
- [ ] Validation: dropdown required; the outcome remains required too — outcome describes the review, compliance states the consequence, and both belong in the record.
- [ ] The cadence flip and dormancy rules (COM-362/COM-363) are system writers and unaffected.
- [ ] ADR: one line in COM-361's amendment — the reviewer states the resulting status explicitly; the outcome mapping is a default, not a rule.
- [ ] Tests: default tracks outcome selection; override persists and applies; not_assessed rejected server-side; stored review row carries the chosen status; revision written as today.