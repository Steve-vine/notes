---
id: 01KZVE9ATCJ1C6G2QPHJJNS8CH
created: 2026-08-12T16:53:29.036649Z
updated: 2026-08-12T16:53:29.036649Z
type: task
title: 'Run report: step''s emitted count doesn''t equal new + known (service-detection)'
imported_from: linear
task_status: done
label: follow_up
assignee: steve
priority: medium
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 222
---
Found while investigating DEV-523.

In the run report's per-step Assets-by-engine row, the **emitted** count can disagree with **new + known** (and with the number of rows actually shown). Observed by Steve on the **service-detection** step:

* Service Detection **alone**: `6 emitted · 0 new th…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-555](https://linear.app/stevevine/issue/DEV-555/run-report-steps-emitted-count-doesnt-equal-new-known-service)