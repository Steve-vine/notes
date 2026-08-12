---
id: 01KZVG864BV5MM3BNNHJQWKKGQ
created: 2026-08-12T17:27:48.619284Z
updated: 2026-08-12T17:27:48.619284Z
type: task
title: Rename subfinder engines to reflect actual upstream behaviour
task_status: done
priority: medium
label:
- follow_up
- chore
assignee: steve
imported_from: linear
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 394
---
During Brief 010's smoke against `example.com`, the two subfinder engines produced the inverse of what their names suggest:

* `subfinder-default` (recursive=false, all sources) — **22,249 assets** in \~60s
* `subfinder-aggressive` (recursive=true) — **6 assets** in 1.2s

This is upstream subfinder behaviour: the `-recursive` flag *narrows* sources because some passive sources don't support recursive enumeration. The flag is misleadingly named u…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-156](https://linear.app/stevevine/issue/DEV-156/rename-subfinder-engines-to-reflect-actual-upstream-behaviour) · parent DEV-16