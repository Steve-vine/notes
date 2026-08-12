---
id: 01KZVCPZB01J6T7QFVD36MNDHP
created: 2026-08-12T16:25:58.88001Z
updated: 2026-08-12T16:26:55.170199Z
type: task
title: 'CVE tab: KEV/EPSS enrichment status indicator (post-backfill)'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 172
sprint: skesb93
assignee: steve
imported_from: linear
label:
- follow_up
priority: medium
task_status: done
---
## Context

The CVE Database tab's progress bar (DEV-666) reflects **only the NVD CVE backfill** — `backfill_start_index / backfill_total` (NVD pagination). CPE matches ride along with each CVE page; KEV + EPSS are **skipped during backfill batches and applied once** when it completes / on incremental runs (DEV-677). So there's a window where the bar reads ~100% and NVD is `ok`, but **KEV/EPSS show** `skipped` **(or are mid-apply)** with no indication of that post-backfill step's state — it just silently flips to `ok` when done.

## Scope

Give the operator clear feedback on the KEV/EPSS enrichment phase, distinct from the CVE backfill bar:

* **Backend:** expose a `sync_running` boolean on the admin health payload (from the DEV-672 lock, `is_sync_locked`) so the UI can show an "applying…" state while a sync is active. (KEV apply is 2 statements, EPSS is now bulk/seconds — DEV-677 — so a literal % bar is overkill; an applying/applied/pending/error status is the right altitude.)
* **Frontend (CVE Database tab):** an "Enrichment (KEV / EPSS)" status block beneath the backfill bar:
  * per source: `applied <relative time>` (from `source_status.*.synced_at`), `pending — applies after backfill` (status `skipped`), `error <msg>`, or `applying…` when `sync_running` and not yet applied this cycle.
  * keep the existing CVE backfill bar as the headline; this is the secondary readiness signal.

## Acceptance criteria

* After the CVE backfill hits 100%, the tab clearly shows KEV/EPSS as applying → applied (with timestamps), not a silent badge flip.
* `skipped` during backfill renders as "pending — applies after backfill", not as an error.
* Backend `sync_running` reflects the lock; frontend types regenerated.
* Tests: backend health includes `sync_running`; frontend renders the enrichment states.

## Notes

Polish follow-up to DEV-666 (tab) / DEV-677 (KEV/EPSS orchestration). Low priority — purely UX clarity; the data is already correct.

---

Imported from Linear [DEV-684](https://linear.app/stevevine/issue/DEV-684/cve-tab-kevepss-enrichment-status-indicator-post-backfill)