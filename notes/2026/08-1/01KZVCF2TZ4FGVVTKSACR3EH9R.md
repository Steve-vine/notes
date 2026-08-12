---
id: 01KZVCF2TZ4FGVVTKSACR3EH9R
created: 2026-08-12T16:21:40.31975Z
updated: 2026-08-12T16:22:39.400154Z
type: task
title: Per-Engine parameter schema and `/engines` endpoint
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 152
sprint: sv5cbvq
assignee: steve
imported_from: linear
label: null
priority: null
task_status: done
---
Backend contract for ADR 020. Each Engine declares its parameter shape in Pydantic. New `/engines` endpoint returns the list with schemas for the frontend. Foundation — everything else depends on this.

---

Imported from Linear [DEV-178](https://linear.app/stevevine/issue/DEV-178/per-engine-parameter-schema-and-engines-endpoint)