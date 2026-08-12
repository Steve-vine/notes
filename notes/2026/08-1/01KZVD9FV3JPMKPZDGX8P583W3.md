---
id: 01KZVD9FV3JPMKPZDGX8P583W3
created: 2026-08-12T16:36:05.603496Z
updated: 2026-08-12T16:36:05.603496Z
type: task
title: 'Frontend: CVE database settings tab (status, config, sync/backfill actions, bundle import)'
priority: high
assignee: steve
imported_from: linear
task_status: done
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 179
---
## Context

The "CVE database" tab inside the new Settings shell (DEV-664), wired to the CVE admin API (DEV-665). Super-admin only. This is the user-facing deliverable that makes the CVE mirror manageable.

## Scope

* **Status panel** (live, polled): CVE count, CPE-match count, KEV/EPSS counts, last full sync, last run + duration, **backfill progress** (% / index / total), **per-source status** (NVD / KEV / EPSS — last sync, ok/error, error message), mirror freshness (ok / stale / empty), whether an NVD key is in use.
* **Settings form**: NVD API key (masked; set / rotate / clear — never display the stored key), sync interval, max-pages-per-run, enabled toggle, stale-after-hours. Validate against API ranges; show that changes apply live (DEV-661).
* **Actions**: "Sync now" (incremental), "Run full backfill" (with a confirm — it's a long, full-catalogue pull), and **air-gap bundle import** (upload cve.ndjson / kev.json / epss.csv(.gz) → DEV-663).
* Follow the `features/*/use-*.ts` TanStack Query hook pattern (new `features/admin/use-cve-mirror.ts`); use generated OpenAPI TS types from DEV-665.

## Acceptance criteria

* A super-admin sees live status, edits settings (key masked, applied without restart), triggers sync + full backfill (with progress reflected), and imports a bundle.
* Non-super-admin cannot reach the tab.
* TS strict, no `any`, dark + light mode; `npm run build` clean.
* Playwright smoke green against dev with `RV_EXPECTED_SHA`; capture a manual verification of a triggered sync moving the count.

## Reuse

* DEV-664 shell + tab gating; DEV-665 endpoints/types
* `features/projects/use-projects.ts` hook pattern; `components/ui/*`

## Dependencies

Blocked by DEV-664 (shell) and DEV-665 (API). Consumes DEV-662 (backfill progress) and DEV-663 (per-source status + import) via the API.

*Triage-level brief.*

---

Imported from Linear [DEV-666](https://linear.app/stevevine/issue/DEV-666/frontend-cve-database-settings-tab-status-config-syncbackfill-actions)