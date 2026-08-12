---
id: 01KZVDY5YQ8C90TRD7XJ5WW6EV
created: 2026-08-12T16:47:23.60754Z
updated: 2026-08-12T16:47:23.60754Z
type: task
title: web-crawler emits route-template assets (DEV-566 part 1 / ADR-039 Phase A)
imported_from: linear
priority: low
label: feature
assignee: steve
task_status: done
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 205
---
Phase A of ADR-039 (`docs/decisions/039-web-crawler-inventory-route-templates-and-scan-selection.md`); DEV-566 part 1.

Introduce the engine-declared `route-template` asset kind and have the web-crawler emit it alongside the existing `url` inventory.

### Scope

* Declare `route-template` on the web-crawler `EngineVersion` CR (`chart/seeds/web-crawler.yaml` `declaredAssetKinds`).
* Add a conservative, unit-tested templating helper in the web-crawler engine: collapse path segments matching all-digits → `{id}`, UUID → `{uuid}`, long hex (≥16) → `{hash}`; drop the query; non-matching segments template to themselves. Template value = full origin, e.g. `https://host/product/{id}`.
* For each discovered `url`, emit the `route-template` asset and set the `url` event's `parent = {kind: route-template, value: <template>}` so ingest writes a `DERIVED_FROM` edge (one template → many instances).
* Tests: templating heuristic per shape; emitted url carries the template parent; conformance.

### Acceptance

* A crawl emits both `url` (every endpoint) and `route-template` assets; concrete URLs are `DERIVED_FROM` their template. No migration (kind is CR-declared).

---

Imported from Linear [DEV-586](https://linear.app/stevevine/issue/DEV-586/web-crawler-emits-route-template-assets-dev-566-part-1-adr-039-phase-a)