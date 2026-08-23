---
id: 01M0N4QKGAB65QJNSP7KM6MJTS
created: 2026-08-22T16:26:46.154175Z
updated: 2026-08-23T07:22:51.706522Z
type: task
title: Review modal sets compliance explicitly — a dropdown, defaulted from the outcome
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 364
sprint: sbph5q5
blocked_by:
- 01M0N4GG6BPQ47RE7ASHNYHEW0
comments:
- id: 01M0N95EH0KZJC4RENVFF0ZGYD
  author: Steve Vine
  at: 2026-08-22T17:44:14.112091Z
  text: |-
    Implemented — PR #366, awaiting the last CI run before merge.

    - **Compliance dropdown beside Outcome**, seeded from the mapping as the outcome is picked and re-seeded on each outcome change **until the reviewer touches it** — after which their choice stands. Re-deriving over an explicit override is how a form loses an answer somebody meant.
    - Selectable: `compliant` / `under_review` / `non_compliant`. **`not_assessed` is absent from the dropdown *and* refused server-side** (422, naming the three that are valid) — the rule is about what a review *is*, so it does not live only in today's UI.
    - Both fields required on the payload.
    - `apply_review_outcome` keeps its name and single-writer role but now **takes the status** instead of deriving it; the mapping moved to `COMPLIANCE_FROM_OUTCOME`, exported as the default the client seeds from.
    - Stored on the review row (**migration 0098**) and shown as a new column in the review history table — otherwise storing it achieves nothing a reader can see.
    - **Design note on the column:** nullable and *not* backfilled. NULL means "this row states no compliance consequence of its own", which covers both pre-COM-364 rows (the reviewer stated nothing; the mapping did) and the offboarding audit record, which never moves the posture. Backfilling from the mapping would have put words in past reviewers' mouths and stamped the offboarding rows with a `compliant` they never asserted. Reuses the existing pg enum via `postgresql.ENUM(create_type=False)` — `sa.Enum` would pass on fresh CI and fail on every incremental deploy.
    - ADR: covered in ADR 0052's "The reviewer states the consequence" section, written with COM-361.
    - Tests: override persists/applies/returns on the row and the list and writes the revision; `not_assessed` → 422 with nothing written; missing field → 422; the offboarding record has a null status with the vendor still `compliant`; frontend — the default tracks the outcome, an override survives a later outcome change and is what gets POSTed, and Not assessed is absent from the dropdown.
- id: 01M0NAYQNRBJTNPWY2NVMAHK9Y
  author: Steve Vine
  at: 2026-08-22T18:15:31.255979Z
  text: 'Merged to main (PR #366, CI green).'
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Today the review outcome *implies* the compliance status through a fixed mapping (`apply_review_outcome`: satisfactory → compliant, findings → under_review, unsatisfactory → non_compliant). Since the Review is the only user lever on compliance (COM-361's model), let the reviewer say what they mean: a **Compliance** dropdown on the record-review modal, so the resulting state is explicit rather than inferred.

- [ ] Modal: a Compliance dropdown alongside Outcome. It **defaults from the outcome** via the existing mapping as the outcome is picked, and the reviewer may override — e.g. a satisfactory review that still leaves the vendor `under_review` while one finding is verified.
- [ ] Selectable values: `compliant`, `under_review`, `non_compliant`. **Not `not_assessed`** — that means "never judged", and a recorded review is a judgment; offering it would let a review un-happen. If a case for it emerges, that's a model change for the ADR, not a dropdown option.
- [ ] Backend: the review payload carries the chosen `compliance_status`; `apply_review_outcome` (or a successor signature) applies the explicit choice — still the single writer, now taking instruction instead of inferring it. The chosen status is **stored on the `VendorReview` row** so the record shows what the reviewer set, not just what the mapping would have said.
- [ ] Validation: dropdown required; the outcome remains required too — outcome describes the review, compliance states the consequence, and both belong in the record.
- [ ] The cadence flip and dormancy rules (COM-362/COM-363) are system writers and unaffected.
- [ ] ADR: one line in COM-361's amendment — the reviewer states the resulting status explicitly; the outcome mapping is a default, not a rule.
- [ ] Tests: default tracks outcome selection; override persists and applies; not_assessed rejected server-side; stored review row carries the chosen status; revision written as today.