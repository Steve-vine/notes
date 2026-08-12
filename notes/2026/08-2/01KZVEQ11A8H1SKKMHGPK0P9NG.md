---
id: 01KZVEQ11A8H1SKKMHGPK0P9NG
created: 2026-08-12T17:00:57.770724Z
updated: 2026-08-12T17:00:57.770724Z
type: task
title: Run-detail liveness indicator — dispatcher stamps step-run last_seen_at each poll
label:
- follow_up
- bug
imported_from: linear
assignee: steve
task_status: done
priority: medium
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 263
---
## Problem

A port-scanner step against 362 hosts appeared **stuck at 316/362 for \~7 min** but was healthy — naabu cleared responsive hosts in ~3s, then spent ~7 min timing out 46 unresponsive hosts, emitting nothing. The run-detail progress froze on the last value, indistinguishable from a hung scanner without SSHing into the cluster.

## Why the originally-filed engine heartbeat won't work

Investigated in plan mode. Buffering is **not** the …

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-380](https://linear.app/stevevine/issue/DEV-380/run-detail-liveness-indicator-dispatcher-stamps-step-run-last-seen-at)