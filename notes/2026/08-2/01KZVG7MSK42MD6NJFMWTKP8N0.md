---
id: 01KZVG7MSK42MD6NJFMWTKP8N0
created: 2026-08-12T17:27:30.867601Z
updated: 2026-08-12T17:27:30.867601Z
type: task
title: 'Chained scan: premature finished_at + httpx progress events buffered to end'
imported_from: linear
priority: high
assignee: steve
task_status: done
label:
- follow_up
- bug
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 390
---
Two related bugs surfaced during the post-DEV-160 smoke (chained `subfinder-then-httpx` against `example.com`, scan_id `b22474f7-a45c-4c06-ac0c-0da7608edeb5`). Both are tied to the chained-scan UX from Brief 011.

## Bug 1 — `Scan.finished_at` stamped prematurely when step 1 …

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-161](https://linear.app/stevevine/issue/DEV-161/chained-scan-premature-finished-at-httpx-progress-events-buffered-to) · parent DEV-159