---
id: 01KZVDVESF8WW32AZG74TXHEM0
created: 2026-08-12T16:45:54.351117Z
updated: 2026-08-12T16:45:54.351117Z
type: task
title: web-crawler prod-only scope filtering + slower cadence (DEV-566 part 4)
task_status: done
priority: low
assignee: steve
label: feature
imported_from: linear
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 202
---
Part 4 of [DEV-566](<https://linear.app/stevevine/issue/DEV-566>) (the umbrella is closed; parts 1–3 delivered via ADR-039 / DEV-586 / DEV-587 / DEV-583). This is the remaining, separable operator-scoping work.

### Problem

The crawl/scan set still includes hosts that aren't worth scanning:

* **dev/staging mirror clones** (`dev-*`, `aslive-*`) multiply the same app into near-duplicate crawl output.
* The `url-inventory` selector's **host-roots subset is additive** and currently emits a root for *every* discovered host — including out-of-scope hosts that a `fqdn` crawl merely *recorded* as links but didn't crawl (observed on go.dev in DEV-587/DEV-588: 339 seeds from 282 urls because external hosts inflated host-roots).

### Scope (to triage)

* **Prod-only filtering** — drop `dev-*` / staging clones from the crawl and/or the scan-feed selection.
* **In-scope host-roots** — restrict the `url-inventory` host-roots subset to in-scope hosts (e.g. the run's scope/anchor hosts), so out-of-scope linked hosts don't become scan seeds. Likely a selector option + a scope check.
* **Cadence** — run the crawler/inventory on a slower schedule than targeted scans (workflow-scheduling guidance, not engine code).

### Acceptance

* A crawl→inventory→scan run on a real CDN-fronted estate feeds the scanner only in-scope, prod hosts; out-of-scope linked hosts and dev/staging clones are excluded. Documented in `docs/scan-workflow-best-practices.md`.

---

Imported from Linear [DEV-592](https://linear.app/stevevine/issue/DEV-592/web-crawler-prod-only-scope-filtering-slower-cadence-dev-566-part-4)