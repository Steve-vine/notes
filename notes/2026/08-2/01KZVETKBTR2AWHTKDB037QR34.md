---
id: 01KZVETKBTR2AWHTKDB037QR34
created: 2026-08-12T17:02:54.842133Z
updated: 2026-08-12T17:02:54.842133Z
type: task
title: 'Rename engine: asset-query → inventory-selector (Inventory Selector)'
label: chore
imported_from: linear
priority: medium
task_status: done
assignee: steve
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 272
---
Atomic engine rename per **Brief 110** + **ADR 036**.

**Mapping:** tool `asset-query` → slug `inventory-selector`, displayName "Inventory Selector". (Internal selector engine.)

One PR: package dir + python module + `pyproject` + `@engine` name + handshake + CR `metadata.name`/`engineRef` + seed filename + image repo + CI/smoke/docs + tests move to the slug; implementation refs keep the tool name. Note `asset-query` declares the bootstrap asset…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-369](https://linear.app/stevevine/issue/DEV-369/rename-engine-asset-query-inventory-selector-inventory-selector)