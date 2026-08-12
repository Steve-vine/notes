---
id: 01KZVDA6QX9SV95CDV30N690MT
created: 2026-08-12T16:36:29.053084Z
updated: 2026-08-12T16:36:58.49919Z
type: task
title: KEV/EPSS source resilience + UI air-gap bundle import
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 182
sprint: skesb93
assignee: steve
imported_from: linear
priority: high
task_status: done
---
## Context (live bug, confirmed on dev)

The CISA KEV feed returns **403 from the cluster egress regardless of headers** — tested no-UA, browser User-Agent, `Accept`, and the `.csv` variant; all 403 with `server: None` and a ~456-byte WAF body. So this is an **edge/IP block on the egress**, not the missing-`User-Agent` a code read would suggest. Result: `kev_count = 0`, the whole `sync_cve_data` task errors on the KEV step (`last_status = error`), and `require_kev: true` in the `version-cve` engine returns nothing. EPSS (`epss.cyentia.com`) should be verified too.

For production this must degrade gracefully and KEV/EPSS must be loadable even when egress is blocked.

## Scope

* **Per-source isolation & status**: NVD, KEV, EPSS each sync independently with their own `last_status`/`last_error`/`last_synced` (so a KEV 403 never aborts the NVD backfill). Surface per-source status on the health/status API.
* **KEV egress handling**: send a proper `User-Agent`; on 403/blocked, record a clear per-source error rather than failing the run. Optionally support a configurable KEV/EPSS URL or proxy (settings store).
* **UI air-gap import**: let a super-admin upload a pre-fetched bundle (`cve.ndjson` / `kev.json` / `epss.csv(.gz)`) through the UI, wrapping the existing `CveSyncer.import_bundle()` (today CLI-only: `redvektor-admin cve-import-file`). This is the supported path to get KEV onto an egress-blocked install.

## Acceptance criteria

* A KEV/EPSS source failure leaves NVD sync unaffected; each source's status is independently visible.
* Uploading a valid bundle via the UI populates `kev`/`epss` columns; `require_kev` findings then work.
* KEV 403 produces an actionable per-source error, not a whole-task failure.
* `uv run pytest`, `uv run mypy src/`, `ruff` green.

## Reuse

* `CveSyncer.import_bundle()` / `cli/admin.py:460` `cve-import-file`
* `services/cve_sync.py` `_sync_kev` / `_sync_epss`

## Dependencies

Per-source status feeds the CVE database tab; coordinate the per-source state shape with DEV-662 (backfill) and the CVE admin API issue.

*Triage-level brief.*

---

Imported from Linear [DEV-663](https://linear.app/stevevine/issue/DEV-663/kevepss-source-resilience-ui-air-gap-bundle-import)