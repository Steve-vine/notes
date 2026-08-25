---
id: 01M0FHC1PKENF5MEPTX1SHEKCD
created: 2026-08-20T12:12:12.371096Z
updated: 2026-08-25T18:43:24.322709Z
type: task
title: Retry transient Graph failures during the directory sync
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 312
sprint: s5yxs5a
comments:
- id: 01M0FP1THCN1CK8ENDK7EFJNHH
  author: Steve Vine
  at: 2026-08-20T13:34:00.235935Z
  text: |-
    Implemented in PR #306 (feature/com-312-graph-retry) — CI green.

    core/graph.py gains _send_with_retry: up to 4 attempts with exponential backoff (1s/2s/4s) for RemoteProtocolError, timeouts and connect errors; 429/503 honour a parseable Retry-After capped at 120s; every retry logged with what/attempt/delay. Applied to the token POST and every paged GET in graph_get_all. Non-transient failures propagate unchanged. Unit tests cover retry-then-success, Retry-After, cap-out, 500-not-retried, and the token POST.
assignee: steve
company: null
label:
- bug
priority: high
task_status: done
---
A single `httpx.HTTPError` anywhere in the ~thousands-of-requests crawl aborts the whole pass (`core/graph.py` `graph_get_all`, and the token POST). Seen 2026-08-20: "Server disconnected without sending a response" (stale keep-alive reuse) and a 120s stall hitting the client timeout — only 1 of 7 passes succeeded.

Add a small retry wrapper with backoff around Graph GETs and the token POST: retry `RemoteProtocolError`/timeouts/connect errors, honour `Retry-After` on 429/503, cap attempts, log each retry.