---
id: 01KZVGA29F8H3XH9FXTX60D86W
created: 2026-08-12T17:28:50.22376Z
updated: 2026-08-12T17:29:46.49403Z
type: task
title: naabu — fast port enumeration (M7 engine 1/4)
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 396
sprint: s0ht2jk
assignee: steve
imported_from: linear
label:
- feature
priority: medium
task_status: done
---
**M7 new engine (1 of 4).** Build `naabu` as a self-contained engine against the finalised spec 1.1.0 / CRD v2 — **no backend or frontend changes** (M6.5 acceptance bar). Split out of the original "nmap + naabu" issue at M7 triage 2026-06-08; nmap is now its own issue.

## Footprint (engine-only)

* `app/scanners/naabu/` — Dockerfile, `runner.py`, conformance tests (mirrors `subfinder`/`httpx`).
* `chart/seeds/naabu.yaml` — `Engine` + `EngineVer…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-113](https://linear.app/stevevine/issue/DEV-113/naabu-fast-port-enumeration-m7-engine-14)