---
id: 01KZVF48NTW88WJHBS3SC0JFP2
created: 2026-08-12T17:08:11.578917Z
updated: 2026-08-12T17:10:03.229448Z
type: task
title: M6.5 P5 — Run-time setting-reference resolution + Cloudflare migration
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 290
sprint: set2ygr
assignee: steve
imported_from: linear
priority: null
task_status: done
---
**Piece 5 of 7 — M6.5.** The dispatcher learns to resolve setting-references at run time, and the existing credentialed engine is migrated off hardcoded app config.

## Scope

* At dispatch, resolve a step's setting-references to real values from the company custom-settings store (P2).
* Deliver per the spec (P1): secret → secret mount into the engine-declared env var (`deliver_as`); plain → params file.
* **Cloudflare migration (declaration onl…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-330](https://linear.app/stevevine/issue/DEV-330/m65-p5-run-time-setting-reference-resolution-cloudflare-migration)