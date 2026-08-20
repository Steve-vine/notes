---
id: 01M0FHC1PKENF5MEPTX1SHEKCD
created: 2026-08-20T12:12:12.371096Z
updated: 2026-08-20T12:12:12.371096Z
type: task
title: Retry transient Graph failures during the directory sync
label: bug
priority: high
assignee: steve
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 312
---
A single `httpx.HTTPError` anywhere in the ~thousands-of-requests crawl aborts the whole pass (`core/graph.py` `graph_get_all`, and the token POST). Seen 2026-08-20: "Server disconnected without sending a response" (stale keep-alive reuse) and a 120s stall hitting the client timeout — only 1 of 7 passes succeeded.

Add a small retry wrapper with backoff around Graph GETs and the token POST: retry `RemoteProtocolError`/timeouts/connect errors, honour `Retry-After` on 429/503, cap attempts, log each retry.