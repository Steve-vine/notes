---
id: 01KZVDNGR3PDWVSVYZMWHNQVN6
created: 2026-08-12T16:42:39.747099Z
updated: 2026-08-12T16:42:39.747099Z
type: task
title: 'version-CVE findings: dedicated UI surface (CVE id, KEV/EPSS, confidence)'
assignee: steve
imported_from: linear
priority: medium
label: feature
task_status: done
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 194
---
Follow-up across M11 P2–P4. The `version-cve` engine ([DEV-610](<https://linear.app/stevevine/issue/DEV-610>)) emits CVE-keyed findings, but they currently ride the **generic findings list** with no version-CVE-specific presentation — the CVE id, KEV flag, EPSS score, CWE ids, and `match_confidence` all live in `Finding.meta` (JSONB), not surfaced in the UI.

## Context

* The findings are spec-1.0.0 `FindingEventV1` with `severity_scheme=cvss`; `Finding.cve_ids` is empty for V1 (decision DEV-610), so the CVE id is in `meta.cve_id`/`meta.cve_ids`.
* `meta` also carries: `kev` (bool), `epss_score`, `epss_percentile`, `cvss_version`, `cwe_ids`, `match_confidence` (`high` nmap-CPE / `low` httpx-tech, DEV-621), `matched_at`.
* The findings list/detail components (`app/frontend/src/features/findings/`) render title/severity/status generically.

## Scope (to triage at plan time)

* **Surface the CVE metadata** on the finding row/detail: the CVE id (linked to NVD?), a **KEV** badge, EPSS score, CWE ids, and a **confidence** indicator (high/low) — reading from `meta`.
* Decide whether this needs a backend change (promote `cve_ids`/`kev`/`epss` to first-class finding fields + API, vs the frontend reading `meta`). Cross-reference the DEV-610 **cve_ids-in-meta decision** — if first-class querying/filtering is wanted (e.g. "show me all KEV findings"), that's a backend+API change worth settling here.
* Optional: filter/sort findings by KEV / EPSS / confidence.

## Acceptance

* A version-CVE finding shows its CVE id + KEV/EPSS/confidence in the findings UI (not just buried in meta); decided + documented whether CVE fields become first-class.

## Notes

Plan-mode-driven. The key decision is **meta-rendering vs first-class promotion** (ties back to the DEV-610 contract and the [grype/dependency-track-style](<https://example.invalid>) "filter by KEV" use case). Frontend-led if meta-rendering; backend+frontend if promoting.

---

Imported from Linear [DEV-630](https://linear.app/stevevine/issue/DEV-630/version-cve-findings-dedicated-ui-surface-cve-id-kevepss-confidence)