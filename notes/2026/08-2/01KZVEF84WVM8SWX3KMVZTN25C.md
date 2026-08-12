---
id: 01KZVEF84WVM8SWX3KMVZTN25C
created: 2026-08-12T16:56:42.908046Z
updated: 2026-08-12T16:57:38.404013Z
type: task
title: 'vulnerability-scanner: wall-clock timeout discards all findings + fails silently (ingest partial results, surface the timeout)'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 237
sprint: sewyev2
assignee: steve
imported_from: linear
label:
- follow_up
priority: medium
task_status: done
---
## Context

Surfaced during M9 testing. A `Cloudflare → web-probe → vulnerability-scanner` run: web-probe produced 144 live `url` assets, nuclei received all 144, ran **1804s**, and the step `failed` at its `wall_clock_seconds: 1800` budget. The run-detail / meta showed `finding_count: null`, `error_code: null` — indistinguishable from "0 findings found" to the user (reported as "ran 32 min, 0 findings").

Two distinct problems, beyond the user-…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-443](https://linear.app/stevevine/issue/DEV-443/vulnerability-scanner-wall-clock-timeout-discards-all-findings-fails)