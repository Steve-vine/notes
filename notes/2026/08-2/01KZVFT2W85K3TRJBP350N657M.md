---
id: 01KZVFT2W85K3TRJBP350N657M
created: 2026-08-12T17:20:06.536663Z
updated: 2026-08-12T17:20:06.536663Z
type: task
title: Move per-engine resource declarations onto `EngineMetadata` (retire `_SCANNER_RESOURCE_OVERRIDES`)
imported_from: linear
label:
- tech_debt
- bug
assignee: steve
priority: medium
task_status: done
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 349
---
**Type:** Architectural / tech debt
**Source:** PR #122 added a stopgap `_SCANNER_RESOURCE_OVERRIDES` map in `core/jobspec.py` to fix nuclei OOM (DEV-112 smoke). The proper fix lives on `EngineMetadata`.

## Problem

Per-engine resource requirements (memory limits in particular) are currently expressed as a sid…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-255](https://linear.app/stevevine/issue/DEV-255/move-per-engine-resource-declarations-onto-enginemetadata-retire)