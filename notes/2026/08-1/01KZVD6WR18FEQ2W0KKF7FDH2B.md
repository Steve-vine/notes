---
id: 01KZVD6WR18FEQ2W0KKF7FDH2B
created: 2026-08-12T16:34:40.513529Z
updated: 2026-08-12T16:34:40.513529Z
type: task
title: Worker OOMKilled during CVE sync — raise worker memory
task_status: done
assignee: steve
label: tech_debt
imported_from: linear
priority: high
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 175
---
## Context (confirmed live on dev)

The Celery worker is **OOMKilled** (`exitCode 137`, `reason: OOMKilled`) during the CVE mirror sync. The worker memory limit is **512Mi** (`requests 256Mi / limits 512Mi`), and processing a single NVD page — 2,000 CVE objects → `parse_nvd_vulnerability` + applicability-tree JSON + SQLAlchemy upsert of CVEs and their `cve_cpe_match` rows — exceeds it.

Effect: a sync batch never completes. Pages advance via the DEV-667 per-page progress writes, the worker OOMs partway, the task redelivers (`acks_late`), re-runs, advances a bit, OOMs again. So:

* `cve_count` / `backfill_start_index` limp forward via crash-redelivery, **not** clean batch completion.
* `cve_sync_completed` **and** `cve_backfill_auto_continue` **never fire** (the run never reaches the end), so the DEV-667 auto-continue chain can't work on real infra and the backfill won't complete cleanly.

Found while verifying DEV-667/672 on dev (2026-06-27). The peak memory is **per-page**, not per-batch, so `cve_sync_max_pages_per_run` doesn't affect it.

## Scope

* Raise the worker memory limit (chart `worker.resources`) to give the CVE sync headroom — ~**1Gi limit** (and bump the request, e.g. 512Mi). The worker runs the heaviest maintenance task; 512Mi is marginal.
* (Optional, separate consideration) reduce per-page peak memory in `_sync_nvd`/`_upsert_cves` (smaller NVD `resultsPerPage`, or stream/free per-page structures) — but the simple, correct fix is more RAM.

## Acceptance criteria

* A full CVE sync batch completes on dev without OOMKill; `cve_sync_completed` is logged.
* The DEV-667 auto-continue chain fires end-to-end (a single trigger drives `cve_count` to ≈ NVD total across auto-chained batches) — verifiable in worker logs (`cve_backfill_auto_continue`).
* No worker restart/`OOMKilled` during a sync run.

## Notes

Blocks clean end-to-end verification of DEV-667 (auto-continue). Relates to DEV-662/665/667. cf. the "new-engine-gotchas" note: 512Mi default OOMs on heavy per-job memory.

---

Imported from Linear [DEV-674](https://linear.app/stevevine/issue/DEV-674/worker-oomkilled-during-cve-sync-raise-worker-memory)