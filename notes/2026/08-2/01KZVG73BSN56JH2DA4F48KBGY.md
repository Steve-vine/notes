---
id: 01KZVG73BSN56JH2DA4F48KBGY
created: 2026-08-12T17:27:13.017299Z
updated: 2026-08-12T17:27:13.017299Z
type: task
title: Brief 013 — httpx throughput and DNS pre-resolution
imported_from: linear
label: brief
task_status: done
priority: high
assignee: steve
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 386
---
Brief at `docs/briefs/013-httpx-throughput-and-preresolve.md` (PR opening shortly).

Resolves DEV-162. Three layers in one brief:

* **Layer A** — defaults change in `_build_command` and `HttpxOpts` (`rate_limit` 150→25, `threads` 50→10, `timeout` 10→5; pass `-duc`, `-no-…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-165](https://linear.app/stevevine/issue/DEV-165/brief-013-httpx-throughput-and-dns-pre-resolution) · parent DEV-162