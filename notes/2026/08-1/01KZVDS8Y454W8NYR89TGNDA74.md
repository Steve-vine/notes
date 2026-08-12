---
id: 01KZVDS8Y454W8NYR89TGNDA74
created: 2026-08-12T16:44:42.82036Z
updated: 2026-08-12T16:44:42.82036Z
type: task
title: 'P1: In-cluster CVE/CPE mirror + sync + lookup (version-CVE foundation)'
label: feature
priority: high
task_status: done
imported_from: linear
assignee: steve
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 200
---
Phase 1 of M11 (version-based vulnerability detection). Foundation for everything else — stand up the **in-cluster CVE/CPE data mirror** the correlation engine will query, with **no external egress**.

Scoped by `docs/proposals/version-to-cve-correlation.md` (DEV-585 spike). Decision (2026-06-24): the data source is a mirror synced into the cluster — a customer-deployed install must never call an external service / leak "what runs where". ProjectDiscovery `cvemap` (cloud API) is out as the primary source.

## Scope

* **Sync** the CVE/CPE data into the cluster on a refresh schedule (Celery Beat or a K8s CronJob):
  * NVD 2.0 **CVE** feed (id, CVSS v3.x, CWE, description) + the **CPE-match** feed (applicability ranges).
  * **CISA KEV** (known-exploited flag) and **FIRST EPSS** (exploit-probability score) feeds.
* **Store** it in an in-cluster reference store. Evaluate NVD-feeds-into-Postgres (reuses our Postgres; reference data is global, not tenant-scoped) vs a self-hosted cve-search-style service. Decide + justify here.
* **Lookup**: expose a CPE / `(product, version)` → CVE query that is **version-range aware** (not equality) and returns CVSS + CWE + KEV + EPSS. Queryable **in-cluster** by an isolated engine container over the cluster network (engines can't import `redvektor_api`). No request leaves the cluster.
* Prove the path end-to-end: feed an nmap `endpoint.meta.cpe` (e.g. an OpenSSH or PHP CPE) and get back the matching CVE list with scores.

## Out of scope (later phases)

* The `version-cve` engine + finding emission (**P2**), httpx tech-string→CPE parsing (**P3**), FP tuning (**P4**), operability/air-gap hardening (**P5**).

## Acceptance

* A scheduled sync populates the in-cluster store from NVD + KEV + EPSS with no manual step.
* Given a CPE (or product+version), the lookup returns version-range-correct CVEs with CVSS/CWE/KEV/EPSS, entirely in-cluster (no external egress — verifiable with egress blocked).
* Store choice + sync mechanic documented (ADR or the proposal doc updated).

## Notes

This is plan-mode-driven like every issue — the store/sync/lookup shape gets agreed with Steve before implementation. Foundational, so it lands before P2's engine.

---

Imported from Linear [DEV-607](https://linear.app/stevevine/issue/DEV-607/p1-in-cluster-cvecpe-mirror-sync-lookup-version-cve-foundation)