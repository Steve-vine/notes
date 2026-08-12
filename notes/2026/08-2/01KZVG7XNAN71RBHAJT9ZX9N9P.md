---
id: 01KZVG7XNAN71RBHAJT9ZX9N9P
created: 2026-08-12T17:27:39.946734Z
updated: 2026-08-12T17:27:39.946734Z
type: task
title: Brief 011 — Basic DAG execution (linear chains)
imported_from: linear
label:
- follow_up
- brief
task_status: done
priority: medium
assignee: steve
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 392
---
Linear chained scan engines — `subfinder → httpx` as the canonical first example. One Scan row, multiple ScanJob rows, with each step's output Assets feeding into the next step's inputs.

Brief at `docs/briefs/011-dag-execution.md` (PR opening shortly).

**Key decisions locked:**

* Linear sequence only (chain), not full DAG. Branching/fan-out/fan-in deferred until needed.
* Implicit "previous step's output" is the only input source.
* Asset gat…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-159](https://linear.app/stevevine/issue/DEV-159/brief-011-basic-dag-execution-linear-chains)