---
id: 01KZVFPWK2W45JN8CH9Z8X72EJ
created: 2026-08-12T17:18:21.794683Z
updated: 2026-08-12T17:18:21.794683Z
type: task
title: Skip broken test_two_concurrent_transitions_one_event_emitted (stopgap for DEV-261)
task_status: done
priority: medium
imported_from: linear
label:
- tech_debt
- chore
assignee: steve
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 343
---
## Problem

`tests/test_finding_status_concurrency.py::test_two_concurrent_transitions_one_event_emitted` has a **test design flaw** — see DEV-261 for the full diagnosis. The two `attempt` coroutines target different statuses, and the matrix legitimately allows the chained tra…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-262](https://linear.app/stevevine/issue/DEV-262/skip-broken-test-two-concurrent-transitions-one-event-emitted-stopgap) · parent DEV-261