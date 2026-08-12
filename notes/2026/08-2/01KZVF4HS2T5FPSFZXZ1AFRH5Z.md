---
id: 01KZVF4HS2T5FPSFZXZ1AFRH5Z
created: 2026-08-12T17:08:20.898934Z
updated: 2026-08-12T17:11:10.68593Z
type: task
title: M6.5 P2 — Custom settings store + company settings UI
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 293
assignee: steve
imported_from: linear
label: null
priority: medium
task_status: done
---
**Piece 2 of 7 — M6.5.** Delivers setting **type 2**: company-scoped custom settings.

## Scope

* Company-scoped key/value store with a **secret** flag.
* Secrets encrypted at rest per company (ADR 022 covers storage); plain values stored as-is.
* CRUD API. Secret values are write-only — masked on read, never returned in clear, masked in logs.
* Management screen in company settings: list, add, edit, delete; mark secret; the "Cloudflare API 1 /…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-327](https://linear.app/stevevine/issue/DEV-327/m65-p2-custom-settings-store-company-settings-ui)