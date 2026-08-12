---
id: 01KZVGAABGNK4NC9AJ7A7V5Y2T
created: 2026-08-12T17:28:58.480996Z
updated: 2026-08-12T17:29:52.332823Z
type: task
title: Brief 009 — httpx scanner integration
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 398
sprint: s5d7bqn
assignee: steve
imported_from: linear
label:
- brief
priority: null
task_status: done
---
Second scanner alongside subfinder — pinned httpx v1.9.0 image (Go 1.25 builder), non-root uid 10001. `SCANNER_REGISTRY` extended with `supported_target_kinds`, `_RESOLVERS` dispatch dict, `SCANNER_INCOMPATIBLE_TARGET` 422 validation. Frontend scanner picker now offers two options. 291 backend tests (84%), 62 frontend tests (87.5%). Verified end-to-end against [example.com](<http://example.com>).

**Brief spec:** [docs/briefs/009-httpx-scanner.m…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-15](https://linear.app/stevevine/issue/DEV-15/brief-009-httpx-scanner-integration)