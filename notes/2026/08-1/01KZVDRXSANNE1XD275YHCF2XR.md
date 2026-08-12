---
id: 01KZVDRXSANNE1XD275YHCF2XR
created: 2026-08-12T16:44:31.402661Z
updated: 2026-08-12T16:44:31.402661Z
type: task
title: 'P2: version-cve engine + CVE-keyed findings'
task_status: done
assignee: steve
label: feature
priority: high
imported_from: linear
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 199
---
Phase 2 of M11. Builds on the P1 mirror ([DEV-607](<https://linear.app/stevevine/issue/DEV-607>), merged): a new **external-job** `version-cve` **engine** that reads detected versions off existing assets, queries the in-cluster CVE lookup, and emits CVE-keyed findings — passive, version-based vuln detection alongside nuclei. Target: reproduce the PHP-8.3.x Nessus block RedVektor missed.

Scoped by `docs/proposals/version-to-cve-correlation.md`.

## Scope

* **New external-job engine** `version-cve` (`acceptsAssetKinds: [endpoint, technology]`): reads the version signal already on assets — nmap `endpoint.meta` `{product, version, cpe}` is the high-confidence path; httpx `technology.meta.name` is best-effort (full tech-string→CPE parsing is **P3**, so P2 can lean on the nmap CPE first).
* **Query the P1 lookup** over the cluster network — the dispatcher injects `RV_CVE_LOOKUP_URL` + a token (decide: reuse the output token, or a dedicated lookup token); the engine calls `GET /internal/.../cve-lookup`.
* **Emit CVE-keyed findings**: `severity_scheme=cvss` (mapped via `core/severity.normalise_cvss`), CVE ids, dedup fingerprint, KEV/EPSS in meta. Settle the `FindingEventV1` `cve_ids`/`cvss` contract (add fields vs reuse nuclei's server-side meta-extraction).
* CR seed + conformance; engine image (PD-tooling-style or a thin Python engine — TBD at plan time).

## Out of scope (later phases)

* httpx tech-string → product/version → CPE generation (**P3**); FP tuning + full CPE applicability operator trees + origin-only scope hygiene (**P4**); refresh/air-gap hardening (**P5**).

## Acceptance

* A run over an asset carrying a known-vulnerable product version (e.g. an nmap `endpoint` with an OpenSSH/PHP CPE) emits CVE-keyed findings with CVSS severity + KEV/EPSS — reproducing a version-based finding nuclei does not.
* Engine conformance + dispatcher-ingest tests green; in-cluster end-to-end proof.

## Notes

Plan-mode-driven: the engine packaging, the `FindingEventV1` contract decision, and the lookup-token plumbing get agreed with Steve before implementation.

---

Imported from Linear [DEV-610](https://linear.app/stevevine/issue/DEV-610/p2-version-cve-engine-cve-keyed-findings)