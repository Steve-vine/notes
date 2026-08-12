---
id: 01KZVDCETCNE25NSWF3D276N27
created: 2026-08-12T16:37:42.86068Z
updated: 2026-08-12T16:37:42.86068Z
type: task
title: CVE mirror backfill robustness (resumable, observable, fix mis-flagged completion)
assignee: steve
imported_from: linear
priority: urgent
task_status: done
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 183
---
## Context (live bug, confirmed on dev)

The dev mirror holds **2,001 CVEs / \~8,800 CPE matches**, but `cve_sync_state` reports `backfill_complete = true` and `backfill_start_index = 0`. NVD currently advertises **361,476** CVEs and is fully reachable from the cluster (verified `totalResults=361476`, HTTP 200). So backfill is marked done having pulled <1% of the catalogue, and because the flag is `true` every scheduled run now only does the incremental (modified-since) window — **it never resumes the backfill**. This is why `version-cve` finds almost nothing: CPE coverage for modern products is sparse (e.g. no nginx; apache `http_server` rows are all 1999-era).

This must work properly for production: a fresh install must reliably pull the full catalogue.

## Scope

* Diagnose how `backfill_complete` got set at index 0 / 2001 rows (likely an early NVD error or `totalResults` mis-read aborting the page loop, then KEV 403 erroring the task — see sibling issue). Add a guard so the flag can only flip true when `start_index >= totalResults` from a **successful** page.
* Make backfill **resumable + observable**: persist `backfill_start_index`, expose progress (current index / `totalResults`, % complete, ETA) on the health/status surface.
* Respect the NVD rate limit honestly: without `nvd_api_key` it's ~5 req/30s; surface whether a key is in use and back off on 429/403 instead of failing the whole run.
* Don't let one source's failure (KEV/EPSS) abort the NVD backfill — isolate per-source (coordinate with DEV-<KEV>).
* Provide a safe "reset + re-run backfill" path (used by the full-backfill trigger in the CVE admin API issue).

## Acceptance criteria

* From an empty/partial mirror, repeated sync runs drive `backfill_start_index` to `totalResults` and only then set `backfill_complete = true`; final `cve_count` ≈ NVD total.
* Backfill progress is queryable while running.
* A transient NVD/KEV error pauses/retries rather than silently marking the backfill complete.
* `uv run pytest`, `uv run mypy src/`, `ruff` green.

## Notes

Overlaps conceptually with M11 P5 (refresh/operability hardening) but is being pulled forward for production-readiness.

*Triage-level brief — confirm root cause in plan mode before implementing.*

---

Imported from Linear [DEV-662](https://linear.app/stevevine/issue/DEV-662/cve-mirror-backfill-robustness-resumable-observable-fix-mis-flagged)