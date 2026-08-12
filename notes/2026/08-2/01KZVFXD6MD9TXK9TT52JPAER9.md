---
id: 01KZVFXD6MD9TXK9TT52JPAER9
created: 2026-08-12T17:21:55.412309Z
updated: 2026-08-12T17:21:55.412309Z
type: task
title: ADR 025 — Finding identity / fingerprint algorithm
priority: high
label: chore
imported_from: linear
assignee: steve
task_status: done
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 356
---
Short ADR pinning the `Finding.fingerprint` algorithm before the Finding model brief lands.

## Why now

ADR 004 (asset-centric data model) says finding dedup is "same fingerprint + same asset = update", but does not pin **how the fingerprint is computed**. Every Phase 4 brief downstream of this depends on the answer:

* …

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-246](https://linear.app/stevevine/issue/DEV-246/adr-025-finding-identity-fingerprint-algorithm)