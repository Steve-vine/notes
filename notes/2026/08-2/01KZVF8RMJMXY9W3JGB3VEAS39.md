---
id: 01KZVF8RMJMXY9W3JGB3VEAS39
created: 2026-08-12T17:10:38.994771Z
updated: 2026-08-12T17:11:30.54769Z
type: task
title: Dispatcher validates handshake from pod stdout for HTTP_POST engines (Brief 088)
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 296
sprint: syc8wmf
assignee: steve
imported_from: linear
label: null
priority: high
task_status: done
---
## Problem

The Brief 058 handshake gate validates the handshake against the stream returned by `_parse_pod_logs(logs)`. For STDOUT engines `logs` is the pod's stdout — which contains the handshake — so the gate works. For **HTTP_POST** engines (`nuclei`, the only one today) the dispatcher sets `logs = output_row.payload` (the POSTed results buffer) and **never reads pod stdout**. But the SDK emits the handshake on **stdout** by design — `protoc…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-325](https://linear.app/stevevine/issue/DEV-325/dispatcher-validates-handshake-from-pod-stdout-for-http-post-engines)