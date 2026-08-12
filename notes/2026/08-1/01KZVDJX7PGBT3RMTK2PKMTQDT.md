---
id: 01KZVDJX7PGBT3RMTK2PKMTQDT
created: 2026-08-12T16:41:14.23036Z
updated: 2026-08-12T16:41:50.346457Z
type: task
title: 'version-cve: RESOLVES_TO hostname↔IP bridge for host-stack assembly'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 189
sprint: s3ry03w
assignee: steve
imported_from: linear
label:
- feature
priority: medium
task_status: done
---
Re-scoped from "write EXPOSES host edges" after closer analysis (host-stack P2/P3, [DEV-634](<https://linear.app/stevevine/issue/DEV-634>)/[DEV-635](<https://linear.app/stevevine/issue/DEV-635>)).

## Why re-scoped

Host-stack assembly (`assemble_host_assets`) already traverses `DERIVED_FROM` + `EXPOSES`, and the P2/P3 in-cluster proofs used `DERIVED_FROM` edges. In the normal subfinder→httpx→nmap chain, a host's `endpoint`/`technology`/`url` assets already share a `subdomain` anchor via `DERIVED_FROM` lineage — so assembly **already connects them**. Writing `EXPOSES` generally would mostly add redundant edges.

The **real gap** is the **IP/hostname anchor split**: nmap can anchor an `endpoint` to an `ip` while httpx anchors `technology`/`url` to the `subdomain` (hostname). Those subgraphs are disconnected — the bridge is a `RESOLVES_TO` edge from the endpoint's `meta.observed_ip`.

## Decisions

* `RESOLVES_TO` is directed **hostname → IP** (parent `subdomain`, child `ip`).
* Bridge **subdomain→its IPs only** (a hostname has determinate IPs); do **not** bridge IP→hostnames (ambiguous vhosts) — preserves vhost separation. Shared-IP infra may be attributed to multiple hosts (documented best-effort limitation).

## Scope

* **Write the bridge** in the asset-mint loop (`tasks/workflow_runs.py` `_ingest_assets_for_step_run`): when a minted asset has a hostname identity + a known IP (`endpoint` `host:port/proto` + `meta.observed_ip`; `subdomain` + `meta.observed_ip`), resolve-or-mint the `subdomain` + `ip` anchors and upsert a `RESOLVES_TO` edge. Idempotent.
* **Traverse the bridge** in `assemble_host_assets`: from a `subdomain` anchor, add its `RESOLVES_TO` ip children to the BFS root set so their `endpoint` descendants are gathered; keep the vhost boundary otherwise.

## Acceptance

* An `endpoint` minted with `observed_ip` produces a `subdomain --RESOLVES_TO--> ip` edge; host-stack assembly from a hostname-anchored technology now reaches the IP-anchored endpoint's CVEs. Two vhosts sharing an IP don't pull each other's hostname-anchored technologies. Tests over the real chain + assembly shapes.

## Notes

Not required for correctness (P3 is promote-only / false-negative-safe) — raises coverage of the IP/hostname split. EXPOSES-everywhere is intentionally **not** done (redundant with DERIVED_FROM). Plan-mode-driven; touches the dispatcher asset-mint path.

---

Imported from Linear [DEV-642](https://linear.app/stevevine/issue/DEV-642/version-cve-resolves-to-hostnameip-bridge-for-host-stack-assembly)