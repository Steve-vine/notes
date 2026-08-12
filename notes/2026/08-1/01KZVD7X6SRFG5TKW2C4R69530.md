---
id: 01KZVD7X6SRFG5TKW2C4R69530
created: 2026-08-12T16:35:13.753778Z
updated: 2026-08-12T16:35:13.753778Z
type: task
title: 'CVE backfill: live mid-run progress + auto-continue batches'
task_status: done
assignee: steve
label: tech_debt
priority: medium
imported_from: linear
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 178
---
## Context

Follow-up from the DEV-662/665/666 CVE-mirror work, surfaced during the first real backfill on dev. The mechanism works, but the operator experience has two papercuts:

1. **Progress only updates per-batch.** `cve_sync_state.backfill_start_index` / `backfill_total` are written at the *end* of each `sync_cve_data` run (after `cve_sync_max_pages_per_run` pages). During a run the rows are being upserted (`cve_count` climbs) but the CVE Database tab's progress bar sits at its last value / 0% until the batch finishes — looks stuck even though it's working.
2. **Full backfill needs repeated manual "Sync now".** Each run pulls one batch (~40 pages ≈ 80k CVEs) then stops; the full ~361k needs ~5 runs. Today you either click "Sync now" repeatedly or wait for the 12h schedule to chew through it over days.

The per-batch cap itself is correct — a single multi-hour run would exceed Celery's ~1h broker visibility timeout and get redelivered (see the vuln-scanner scale tuning note). This issue is about UX on top of that model, not removing the cap.

## Scope

* **Live progress:** have `_sync_nvd` persist `backfill_start_index` (+ `backfill_total` once learned) **per page** (or every N pages), so the UI bar advances during a run. Cheap single-row update; keep it transactional with the page upsert.
* **Auto-continue:** when a backfill run finishes a batch and `backfill_complete` is still false, **self-re-enqueue** `sync_cve_data` (respecting the lock + a sane gap) so the catalogue completes without manual clicks — stopping when `backfill_complete` flips true. Guard against runaway (only while in backfill, not for incremental runs).
* UI: the progress bar already reads these fields (DEV-666); confirm it reflects live updates and shows an "in progress / N more batches" affordance.

## Acceptance criteria

* During a backfill run, the CVE Database tab's progress advances without waiting for the batch to finish.
* Triggering a full backfill once drives `cve_count` to ≈ NVD total across auto-chained batches with no further clicks, and stops cleanly at completion.
* No run exceeds the visibility-timeout bound; no double-running (lock honoured).
* Tests cover the per-page progress write and the auto-continue/stop conditions.

## Notes

Discovered 2026-06-27 during the dev backfill (cve_count climbing 3k→13k→… while the bar showed 0%). Relates to DEV-662 (backfill), DEV-665 (triggers/lock), DEV-666 (tab).

---

Imported from Linear [DEV-667](https://linear.app/stevevine/issue/DEV-667/cve-backfill-live-mid-run-progress-auto-continue-batches)