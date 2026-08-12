---
id: 01KZVDVKNK6NK0JAXFJ41K4VYJ
created: 2026-08-12T16:45:59.347188Z
updated: 2026-08-12T16:45:59.347188Z
type: task
title: Wire + document the crawler→url-inventory→vuln-scanner workflow (DEV-566 / ADR-039 Phase C)
imported_from: linear
task_status: done
label: feature
assignee: steve
priority: low
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 203
---
Phase C of ADR-039; closes out DEV-566 parts 1 & 2.

Wire and document the recommended `web-crawler → url-inventory → vulnerability-scanner` workflow shape now that Phases A & B exist, and validate the end-to-end reduction on dev.

### Scope

* Document the recommended workflow (crawler-as-inventory + url-inventory selector + scanner) and cross-link DEV-567 (best-practice vuln-workflow defaults).
* End-to-end dev validation: a real chained run shows the crawler's full URL inventory preserved while the vuln-scanner receives only the reduced set (host-roots + parameterised + one-per-template).

### Acceptance

* The recommended workflow is documented and verified end-to-end on dev; DEV-566 parts 1 & 2 are demonstrably resolved (inventory preserved, scan input bounded).

---

Imported from Linear [DEV-588](https://linear.app/stevevine/issue/DEV-588/wire-document-the-crawlerurl-inventoryvuln-scanner-workflow-dev-566)