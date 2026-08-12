---
id: 01KZVD77PSCKAWB8JAWCZVMPJ8
created: 2026-08-12T16:34:51.737801Z
updated: 2026-08-12T16:35:54.464292Z
type: task
title: 'CVE sync lock: heartbeat-refresh + release on shutdown (avoid 1h stale-lock stall)'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 176
sprint: skesb93
assignee: steve
imported_from: linear
label:
- tech_debt
priority: medium
task_status: done
---
## Context

The DEV-665 Valkey advisory lock (`redvektor:cve-sync:lock`) guards against concurrent CVE syncs with a fixed **3600s TTL** as the only backstop. The lock is released in `sync_cve_data`'s `finally` — but that doesn't run on a hard **SIGKILL**. So when the worker is killed mid-sync (e.g. `kubectl rollout restart` whose grace period elapses), the lock stays held for **up to an hour**, and every sync in that window returns `{'skipped': 1}` (locked).

This now interacts badly with the DEV-667 **auto-continue** chain: a worker restart mid-backfill leaves the lock stuck, so the chain stalls until the TTL expires instead of resuming. Hit live during the DEV-667/669 deploy (2026-06-27) — had to clear the lock manually.

## Scope

Make the lock self-healing without depending on a clean shutdown:

* **Short TTL + heartbeat refresh.** Drop the TTL to a small value (e.g. 120s) and, while a sync run is active, refresh it periodically (e.g. every ~45s) via `SET key val XX EX <ttl>` (extend only if still held). On crash/kill the lock then expires within the TTL (~2 min), not an hour. The TTL must stay comfortably above the inter-refresh interval, not above a whole batch's wall-clock (the heartbeat covers long batches).
* **Release on graceful shutdown** where practical (`worker_shutting_down`), as a fast-path on top of the heartbeat. (Note Celery prefork: the task/child holds the lock; the signal fires in MainProcess — so the heartbeat-TTL is the load-bearing mechanism, the signal is best-effort.)
* Keep the existing best-effort semantics (Valkey unreachable ⇒ acquire returns True; sync upserts are idempotent).

## Acceptance criteria

* After a worker is SIGKILLed mid-sync, a new sync can run within ~the TTL (seconds), not up to 3600s.
* A legitimately long batch keeps its lock (heartbeat refreshes it) — no double-run.
* No regression to the concurrency guard (a second concurrent trigger still no-ops).
* Tests cover acquire/refresh/release + that release runs on the normal path.

## Notes

Follow-up to DEV-665 (lock) and DEV-667 (auto-continue). Found during the M12 dev deploy.

---

Imported from Linear [DEV-672](https://linear.app/stevevine/issue/DEV-672/cve-sync-lock-heartbeat-refresh-release-on-shutdown-avoid-1h-stale)