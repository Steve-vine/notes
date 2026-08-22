---
id: 01M0N4GRH0H5BBN34FM4NZY7G5
created: 2026-08-22T16:23:01.920495Z
updated: 2026-08-22T16:23:26.853027Z
type: task
title: Under Review replaces Review Due — one waiting state when the cadence fires
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 362
sprint: sbph5q5
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Decided 2026-08-22: the compliance status set has no separate Review Due — when the review cadence triggers, the vendor goes **`under_review`**. COM-353's `review_due` is retired almost as soon as it shipped; pre-live, so remove it properly rather than letting it rot in the enum.

- [ ] `vendor_compliance_status`: drop `review_due` (enum rebuild — the forward promote pattern again), migrating any `review_due` rows to `under_review`.
- [ ] The Beat cadence flip (`vendor_posture.apply_review_due` or its successor): `compliant → under_review` when `next_due` passes. Rename the helper to match its new meaning.
- [ ] `under_review`'s meaning widens: it now covers both "a review found findings being worked" (the existing outcome mapping, unchanged) and "the cadence says it's time to look again". The status reads as *assurance currently in question* — the Review record distinguishes why, which is where reasons live.
- [ ] Recovery unchanged: recording the review outcome overwrites it (satisfactory → compliant, etc.).
- [ ] Frontend: remove the review_due badge/filter added by COM-353; under_review's label/colour covers both paths.
- [ ] Tests: cadence flips compliant → under_review; findings outcome still → under_review; migration maps review_due rows; review recovery from both entry paths.