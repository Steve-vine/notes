---
id: 01KZVDRHN9NKG4K0XWNQTZC115
created: 2026-08-12T16:44:18.985873Z
updated: 2026-08-12T16:44:18.985873Z
type: task
title: 'P3: httpx technology-string → CPE generation for version-cve'
label: feature
assignee: steve
priority: medium
task_status: done
imported_from: linear
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 198
---
Phase 3 of M11. Extends the version-cve correlation ([DEV-610](<https://linear.app/stevevine/issue/DEV-610>), merged) from the high-confidence nmap `endpoint` CPE path to **httpx** `technology` **assets**.

Scoped by `docs/proposals/version-to-cve-correlation.md`.

## Problem

P2 correlates `endpoint` assets (nmap gives a structured `meta.cpe` / `{product, version}`). The other big version signal is httpx tech-detect: `technology` assets carry an **unstructured** `meta.name` (e.g. "Apache 2.4.41", "PHP/8.0", "nginx") — no CPE, no split product/version. To correlate them we must parse the string into `{product, version}`, generate a CPE candidate, and feed the existing matcher.

## Scope

* **Parse** `technology.meta.name` into `{product, version}` (handle common shapes: "Apache 2.4.41", "PHP/8.0", trailing/embedded versions, name-only with no version).
* **Generate a CPE / product-name candidate** and map the detected product to its CPE vendor/product where they differ (e.g. `apache` → `apache:http_server`, `php` → `php:php`, `nginx` → `f5:nginx`/`nginx:nginx`). A small curated alias table is acceptable for P3; the long tail is best-effort.
* **Extend the server-side asset-ref lookup** (`services/cve_lookup.lookup_cves_for_asset`) to handle `asset_kind == "technology"` via the parser, and add `technology` to the version-cve engine's `acceptsAssetKinds` + CR seed.
* **Confidence labelling**: tech-string matches are lower-confidence than nmap CPE — tag findings (e.g. `meta.match_confidence`) so P4 FP tuning can gate on it.
* Name-only / unparseable tech strings → no finding (don't guess a version).

## Out of scope

* FP tuning + full CPE applicability operator trees + origin-only scope hygiene (**P4**); refresh/air-gap hardening (**P5**).

## Acceptance

* A `technology` asset like "Apache 2.4.41" yields CVE findings via the parsed product+version, labelled lower-confidence; a name-only "nginx" (no version) yields none.
* Parser unit tests over the common tech-string shapes; backend + engine tests + in-cluster proof.

## Notes

Plan-mode-driven: the parser heuristics, the product→CPE alias approach, and the confidence model get agreed with Steve before implementation. Parsing accuracy is inherently best-effort (the reason P2 deferred it).

---

Imported from Linear [DEV-621](https://linear.app/stevevine/issue/DEV-621/p3-httpx-technology-string-cpe-generation-for-version-cve)