---
id: 01KZVG5477XMNS6CGSZPAXYPHB
created: 2026-08-12T17:26:08.359124Z
updated: 2026-08-12T17:26:08.359124Z
type: task
title: Scanner fails on example.com
assignee: steve
imported_from: linear
label: bug
priority: high
task_status: done
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 385
---
## Summary

The `subfinder-then-httpx` scan against `example.com` fails. The httpx step pre-resolves for \~350s, exceeds the 300s wall-clock budget, and exits with `reason=preresolve_timeout`. The progress bar **never displays at all** during the failed run — UI sits on the step before any progress event reaches it.

Five subsequent scans against five domains we own all completed in <30s and rendered the progress bar correctly. So the visible-pr…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-166](https://linear.app/stevevine/issue/DEV-166/scanner-fails-on-examplecom) · parent DEV-162