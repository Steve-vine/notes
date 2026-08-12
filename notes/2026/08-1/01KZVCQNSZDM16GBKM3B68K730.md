---
id: 01KZVCQNSZDM16GBKM3B68K730
created: 2026-08-12T16:26:21.887254Z
updated: 2026-08-12T16:26:21.887254Z
type: task
title: CVE sync upsert is slow / hits statement_timeout + stalls — batch the upserts
assignee: steve
imported_from: linear
label: tech_debt
task_status: done
priority: high
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 174
---
## Context (found verifying DEV-667/674 on dev, 2026-06-27)

With the worker at 1Gi (DEV-674) the OOM is gone, but the CVE backfill still doesn't complete cleanly — `cve_sync_completed`/`cve_backfill_auto_continue` rarely fire. Root cause is the **per-page upsert performance**:

`CveSyncer._upsert_cves` processes a 2,000-CVE NVD page by issuing **per-CVE** statements in a single transaction — for each CVE an `INSERT … ON CONFLICT DO UPDATE` into `cve`, plus a delete + re-insert of its `cve_cpe_match` rows. That's thousands of sequential awaited round-trips per page. Observed on dev:

* Under any concurrency (e.g. redelivered duplicate runs) it hits the **30s** `statement_timeout`: `psycopg.errors.QueryCanceled: canceling statement due to statement timeout … inserting index tuple in relation "cve"` → `cve_sync_nvd_failed` → the run aborts before completing → no auto-continue.
* Even single-threaded a page takes minutes; combined with leaked connections from aborted runs the task can stall.

The DEV-665/672 lock prevents the concurrency (so the timeout is mostly self-inflicted during manual testing), but the underlying upsert is too slow/fragile for a 361k backfill and is the practical blocker to it completing.

## Scope

* **Batch the writes.** Replace the per-row loop with set-based upserts: a single multi-row `pg_insert(Cve).values([...]).on_conflict_do_update(...)` per page (or chunks of N), and bulk the `cve_cpe_match` replace (one delete `WHERE cve_id = ANY(...)` + one multi-row insert) instead of per-CVE. Cuts thousands of round-trips to a handful.
* Consider chunking a page into sub-batches with a commit per chunk so progress is durable and no single statement/txn is huge.
* Optionally raise `statement_timeout` for the sync DB session specifically (it's a bulk maintenance job), but batching is the real fix.
* Re-verify on dev: a single trigger drives `cve_count` → ~361k via auto-chained batches, no `statement_timeout`, no stall.

## Acceptance criteria

* A backfill batch completes well within `statement_timeout`; no `QueryCanceled` under normal operation.
* Full backfill (~361k) completes via DEV-667 auto-continue without manual intervention; per-page wall-clock materially reduced.
* Tests cover the batched upsert (CVE + cve_cpe_match) for correctness/idempotency.

## Notes

This is the practical blocker to the M12 CVE backfill actually finishing. Relates to DEV-662 (sync), DEV-667 (auto-continue), DEV-674 (memory). The DEV-667 auto-continue logic is correct (unit-tested) but can't be demonstrated end-to-end until batches complete reliably.

---

Imported from Linear [DEV-675](https://linear.app/stevevine/issue/DEV-675/cve-sync-upsert-is-slow-hits-statement-timeout-stalls-batch-the)