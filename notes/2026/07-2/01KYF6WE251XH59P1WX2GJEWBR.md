---
id: 01KYF6WE251XH59P1WX2GJEWBR
created: 2026-07-26T12:37:31.333374Z
updated: 2026-07-26T12:38:27.457771Z
type: task
title: Widen pytest parallelism (-n 4 → -n 8)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 317
sprint: sr2f21y
assignee: steve
label:
- improvement
priority: medium
task_status: backlog
---
1254 backend tests run at `pytest -n 4` in **~293s** on a 16-core node. Bump to `-n 8` (keep `--dist loadscope` — several integration modules share DB state and assume in-module ordering). Verify the per-worker session-scoped Postgres containers scale on memory. **Blocked by [[set CPU/memory requests on ise-runners pods]]** — only widen once runner CPU requests guarantee the cores, or it worsens thrash.

Acceptance: pytest step roughly halves with no new flakes.