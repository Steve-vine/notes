---
id: 01KZVCQDZ3QH8MGTMQ31KM3EPP
created: 2026-08-12T16:26:13.859062Z
updated: 2026-08-12T16:26:59.200837Z
type: task
title: 'CVE sync: batch EPSS apply + skip KEV/EPSS during backfill batches'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 173
sprint: skesb93
assignee: steve
imported_from: linear
label:
- tech_debt
priority: high
task_status: done
---
## Context (found verifying DEV-675 on dev, 2026-06-27)

After batching the NVD CVE upsert (DEV-675), the NVD pages now complete fast and cleanly (verified: `backfill_start_index` advances per batch, no `statement_timeout`, no OOM). But a sync run still doesn't reach `cve_sync_completed` — it stalls at the **end** of every run in `_sync_epss`.

`_apply_epss` loops over the **entire FIRST EPSS feed (\~250k rows)** issuing a **per-row** `UPDATE cve SET epss_score=…, epss_percentile=… WHERE cve_id=…` (confirmed live via `pg_stat_activity`). That's ~250k sequential UPDATEs per run — minutes of grind — and it runs on **every** sync, including every backfill batch. So:

* A run takes minutes in EPSS even after NVD is done → `cve_sync_completed`/DEV-667 auto-continue are delayed/blocked.
* During a ~180-batch backfill, the full KEV (1.6k) + EPSS (250k) apply repeats on every batch — hugely wasteful.

## Scope

1. **Batch** `_apply_epss` (same class as DEV-675): replace the per-row loop with a set-based bulk update — e.g. `UPDATE cve SET epss_score = v.score, epss_percentile = v.pct FROM (VALUES …) AS v(cve_id, score, pct) WHERE cve.cve_id = v.cve_id`, chunked to stay under the 65535 bind-param cap. Turns ~250k statements into a few hundred. (KEV already applies in 2 bulk statements — fine.)
2. **Don't run heavy KEV/EPSS on every backfill batch.** During backfill (`backfill_in_progress`), skip KEV/EPSS and apply them once when the backfill completes (and on the normal incremental cadence). Backfill batches become NVD-only → fast → auto-continue rips through the catalogue; KEV/EPSS apply once at the end.

## Acceptance criteria

* A sync run (backfill batch) completes in well under a minute on dev; `cve_sync_completed` + DEV-667 `cve_backfill_auto_continue` fire; a single trigger drives `cve_count` → ~361k hands-free.
* KEV/EPSS still applied (once post-backfill + on incremental runs); EPSS apply is bulk, no `statement_timeout`.
* Tests cover the batched EPSS apply + the skip-during-backfill orchestration.

## Notes

Last link in the chain (OOM → statement_timeout → param-cap → EPSS per-row) blocking the M12 backfill from completing + auto-continuing cleanly. Relates to DEV-662/667/675. The NVD-side batching is already merged and working.

---

Imported from Linear [DEV-677](https://linear.app/stevevine/issue/DEV-677/cve-sync-batch-epss-apply-skip-kevepss-during-backfill-batches)