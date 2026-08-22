---
id: 01M0N4GRH0H5BBN34FM4NZY7G5
created: 2026-08-22T16:23:01.920495Z
updated: 2026-08-22T17:30:40.001476Z
type: task
title: Under Review replaces Review Due — one waiting state when the cadence fires
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 362
sprint: sbph5q5
blocked_by:
- 01M0N4GG6BPQ47RE7ASHNYHEW0
comments:
- id: 01M0N8CBWA9A7M19T5AWDMNVD9
  author: Steve Vine
  at: 2026-08-22T17:30:32.202032Z
  text: |-
    Done — PR #364, merged to main.

    - **Migration 0097** rebuilds `vendor_compliance_status` without `review_due` (the 0091/0092 promote pattern — Postgres cannot drop a member), mapping rows in **both** tables that carry the type, `vendors` and `vendor_revisions`, to `under_review`. Retired properly rather than deprecated in place, as the task asked.
    - `apply_review_due` → **`apply_cadence_expiry`**, flipping `compliant → under_review`. The guard is unchanged: `under_review` is already where this would send it, `non_compliant` carries a stronger claim than "we no longer know", `not_assessed` has nothing to expire.
    - `under_review`'s widened meaning is documented on the enum itself, so the next reader finds it where the type is defined rather than in a task.
    - Frontend: the orange `review_due` badge colour and both "Review due" filter entries (internal register + portal) removed.
    - Tests: the cadence flip lands on `under_review`, once, idempotently (renamed `test_cadence_expiry_downgrades_a_compliant_judgement`); recovery via a satisfactory review from **both** entrances — cadence-expired and findings; and a migration test with rows present, asserting the vendor, a two-row revision history, and that the member is gone from the pg type.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Decided 2026-08-22: the compliance status set has no separate Review Due — when the review cadence triggers, the vendor goes **`under_review`**. COM-353's `review_due` is retired almost as soon as it shipped; pre-live, so remove it properly rather than letting it rot in the enum.

- [ ] `vendor_compliance_status`: drop `review_due` (enum rebuild — the forward promote pattern again), migrating any `review_due` rows to `under_review`.
- [ ] The Beat cadence flip (`vendor_posture.apply_review_due` or its successor): `compliant → under_review` when `next_due` passes. Rename the helper to match its new meaning.
- [ ] `under_review`'s meaning widens: it now covers both "a review found findings being worked" (the existing outcome mapping, unchanged) and "the cadence says it's time to look again". The status reads as *assurance currently in question* — the Review record distinguishes why, which is where reasons live.
- [ ] Recovery unchanged: recording the review outcome overwrites it (satisfactory → compliant, etc.).
- [ ] Frontend: remove the review_due badge/filter added by COM-353; under_review's label/colour covers both paths.
- [ ] Tests: cadence flips compliant → under_review; findings outcome still → under_review; migration maps review_due rows; review recovery from both entry paths.