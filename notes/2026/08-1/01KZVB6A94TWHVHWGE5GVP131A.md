---
id: 01KZVB6A94TWHVHWGE5GVP131A
created: 2026-08-12T15:59:24.452705Z
updated: 2026-08-12T16:00:41.229023Z
type: task
title: OTEL Celery instrumentation logs `Attempting to instrument while already instrumented`
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 102
sprint: svz96jc
assignee: steve
imported_from: linear
label:
- bug
priority: low
task_status: backlog
---
Worker emits this WARN twice on startup. Harmless (instrumentation is no-op the second time) but noisy. Likely caused by `celeryd_init` + `worker_process_init` both calling the instrumentor. Fix is to gate on a module-level `_instrumented` flag.

Source: Obsidian Issues Tracker #18 (P4 Low, Open). Discovered during Brief 006b live verification.

---

Imported from Linear [DEV-26](https://linear.app/stevevine/issue/DEV-26/otel-celery-instrumentation-logs-attempting-to-instrument-while)