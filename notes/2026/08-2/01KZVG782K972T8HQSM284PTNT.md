---
id: 01KZVG782K972T8HQSM284PTNT
created: 2026-08-12T17:27:17.843762Z
updated: 2026-08-12T17:28:24.126209Z
type: task
title: 'Dispatcher: fail-fast on ImagePullBackOff and other terminal Waiting reasons'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 388
sprint: s5d7bqn
assignee: steve
imported_from: linear
label:
- follow_up
- improvement
priority: medium
task_status: done
---
## Symptom

When a scanner Pod's image can't be pulled (e.g. `ImagePullBackOff` because the image isn't in the cluster's registry, or `ErrImagePull` because the tag doesn't exist), the dispatcher's Stage 2 polling loop currently waits the full `deadline_seconds` (default 1800s = 30 min) before timing out and stamping `timed_out` on the ScanJob. That's the configured wall-clock deadline, doing exactly what it's designed to do — but it's a poor UX…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-163](https://linear.app/stevevine/issue/DEV-163/dispatcher-fail-fast-on-imagepullbackoff-and-other-terminal-waiting) · parent DEV-159