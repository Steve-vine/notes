---
id: 01KZVDK9HHQB17ZED9J48NH0JP
created: 2026-08-12T16:41:26.83394Z
updated: 2026-08-12T16:41:26.83394Z
type: task
title: 'version-cve P2: host-stack assembly via the asset-relationship graph'
task_status: done
imported_from: linear
label: feature
assignee: steve
priority: low
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 191
---
Phase 2 of [DEV-632](<https://linear.app/stevevine/issue/DEV-632>). Assemble a **host's full detected-CPE set** so P3 can evaluate a CVE's applicability tree against it.

## Decision (settled at DEV-632 planning)

Host identity = the `asset_relationships` **graph** (`resolves_to` / `hosted_on`), not `meta.observed_ip` alone — to bridge IP-keyed `endpoint` assets and hostname-keyed `technology` assets into one true host, and to avoid vhost-lumping (many hostnames → one IP).

## Scope

* Server-side host-stack assembly (the internal lookup endpoint already holds `company_id` + session): given the input asset, traverse `asset_relationships` to gather the host's `endpoint` + `technology` (+ relevant) assets, then resolve each to CPE(s) reusing `_resolve_endpoint_hits` / `_resolve_technology_hits` (`services/cve_lookup.py`) → a unioned host CPE set.
* Decide the host-mode contract on `internal_cve_lookup.py` (e.g. a `host_scope` flag) + how the engine opts in.
* Tests over representative relationship shapes (endpoint↔ip↔technology); vhost separation.

## Acceptance

* Given any asset on a host, the server assembles the host's full CPE set via the relationship graph (not just the one asset), with vhosts kept distinct. (Pure assembly; evaluation is P3.)

---

Imported from Linear [DEV-634](https://linear.app/stevevine/issue/DEV-634/version-cve-p2-host-stack-assembly-via-the-asset-relationship-graph) · parent DEV-632