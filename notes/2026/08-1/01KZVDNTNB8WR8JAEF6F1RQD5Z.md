---
id: 01KZVDNTNB8WR8JAEF6F1RQD5Z
created: 2026-08-12T16:42:49.899681Z
updated: 2026-08-12T16:42:49.899681Z
type: task
title: 'P5: CVE-mirror refresh/operability hardening + air-gap import'
label: feature
task_status: done
imported_from: linear
assignee: steve
priority: medium
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 195
---
Phase 5 of M11 — make the in-cluster CVE mirror ([DEV-607](<https://linear.app/stevevine/issue/DEV-607>)) operable and trustworthy in production, including air-gapped installs.

Scoped by `docs/proposals/version-to-cve-correlation.md`.

## Problem

P1 stood up the sync (NVD + CISA KEV + FIRST EPSS → Postgres, incremental + resumable). It works, but operationally it's bare:

* **No freshness visibility** — nothing surfaces how stale the mirror is (last successful sync, backfill progress %, row counts). An operator can't tell if correlation is running on month-old data, and a silently-failing sync degrades findings invisibly.
* **No staleness/failure alerting** — a sync that errors or stops advancing the cursor just… stops.
* **No air-gap path** — the sync is the only egress; a cluster with no internet can't populate the mirror at all. There's no offline import of a pre-built feed bundle.

## Scope (to triage at plan time)

* **Freshness surface** — expose mirror health: `last_full_sync_at`, `last_modified_cursor`, backfill complete %, `cve` / `cve_cpe_match` / KEV / EPSS counts, last-sync status + error. Likely a read model + an admin/ops endpoint (and/or a `/readyz`-style signal); consider a metric for the Datadog dashboards.
* **Staleness gating** — decide whether/how version-cve should behave when the mirror is stale or empty (warn on the run report? a non-fatal engine error? a configurable max-staleness?).
* **Sync failure handling** — surface sync errors (structured log already; add a persisted last-error + an alertable signal); ensure a failed run doesn't corrupt the cursor.
* **Air-gap import** — an offline path to load a pre-built CVE/CPE/KEV/EPSS bundle into the mirror (CLI/management command or a one-shot Job), so `cve_data_sync_enabled=false` clusters still correlate. Define the bundle format + provenance.

## Acceptance

* Mirror freshness/health is observable (endpoint and/or metric); a stale or failing sync is visible, not silent.
* An air-gapped cluster can populate the mirror from an offline bundle with no external egress.
* Tests for the freshness read model + the import path; in-cluster proof.

## Notes

Plan-mode-driven: the freshness-surface shape (ops endpoint vs metric vs readyz), the staleness-gating policy, and the air-gap bundle format get agreed with Steve before implementation. This is the operability counterpart to P1's plumbing.

---

Imported from Linear [DEV-627](https://linear.app/stevevine/issue/DEV-627/p5-cve-mirror-refreshoperability-hardening-air-gap-import)