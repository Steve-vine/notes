---
id: 01KZVEFWBH248VJ121TSK3138C
created: 2026-08-12T16:57:03.601028Z
updated: 2026-08-12T16:58:10.586416Z
type: task
title: port-scanner & service-detection emit kind=endpoint, which isn't a registered asset kind — all assets dropped at ingest
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 243
sprint: sewyev2
assignee: steve
imported_from: linear
label:
- bug
priority: urgent
task_status: done
---
## Summary

`port-scanner` and `service-detection` **emit** `kind="endpoint"` assets, but `endpoint` **is not a registered asset kind**, so the dispatcher drops **every** asset they emit as unknown-kind (`workflow_step_run_asset_dropped_unknown_kind`, `tasks/workflow_runs.py:1116`). Both engines therefore record `asset_count: 0` on every run and persist nothing — they have effectively produced **zero ingested assets since the ADR-037 anchor/endp…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-437](https://linear.app/stevevine/issue/DEV-437/port-scanner-and-service-detection-emit-kindendpoint-which-isnt-a)