---
id: 01KZVG51EV7XB26PJJ2CW1JWE7
created: 2026-08-12T17:26:05.531952Z
updated: 2026-08-12T17:26:46.479768Z
type: task
title: Subfinder progress bar with per-source attribution
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 384
sprint: s5d7bqn
assignee: steve
imported_from: linear
label:
- follow_up
- feature
priority: medium
task_status: done
---
## Why

Subfinder runs take 2+ minutes even on healthy real targets (we saw 134s on [moneypenny.com](<http://moneypenny.com>) with `-active`, 374s on [example.com](<http://example.com>)). During that time the UI currently shows the step as running with no granular progress — it appears stuck.

We have a clear progress signal available: subfinder runs N sources and we know N upfront from the invocation. A "0 of N sources complete" → "N of N sourc…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-168](https://linear.app/stevevine/issue/DEV-168/subfinder-progress-bar-with-per-source-attribution) · parent DEV-166