---
id: 01KZVDVTTACNW1VW4WSNHXR171
created: 2026-08-12T16:46:06.666747Z
updated: 2026-08-12T16:46:39.408888Z
type: task
title: url-inventory selector engine reduces crawl output to a scan set (DEV-566 part 2 / ADR-039 Phase B)
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 204
sprint: sp88phy
assignee: steve
imported_from: linear
label:
- feature
priority: low
task_status: done
---
Phase B of ADR-039; DEV-566 part 2.

Add a new **internal** `url-inventory` selector engine that decouples discovery from scanning: it reads the run's discovered `url` assets and emits a reduced **seed** set to the downstream vuln-scanner, with zero dispatcher-routing change (reuses the `inventory-selector` seed path).

### Scope

* New internal engine (mirror `internal_engines/asset_query.py` / `inventory-selector`): `execution: INTERNAL`, `acceptsAssetKinds: ["url"]`, mints no assets, returns seeds. CR seed (`chart/seeds/url-inventory.yaml`) + register handler.
* Reads discovered `url` assets (in-process session, scoped to company + this run's prior steps) and emits: (a) host roots via `core/urls.host_base_url`, (b) URLs with a non-empty query (parameterised injection candidates), (c) one representative `url` per `route-template` (template-aware once Phase A lands; until then one per `(scheme,host,port,path)`).
* Params: independent toggles per subset + a `limit` cap (mirror `ScopeFeedSelectorOpts`).
* Tests: each subset's selection; seed filtering by the next engine's `acceptsAssetKinds`.

### Acceptance

* `web-crawler → url-inventory → vulnerability-scanner` feeds the scanner only host-roots + parameterised + one-per-template, dramatically cutting nuclei input. vuln-scanner is unchanged (`acceptsAssetKinds: [url]`). Can ship before Phase A (degrades to per-(host,path)).

---

Imported from Linear [DEV-587](https://linear.app/stevevine/issue/DEV-587/url-inventory-selector-engine-reduces-crawl-output-to-a-scan-set-dev)