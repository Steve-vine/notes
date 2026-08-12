---
id: 01KZVESRS71J8C3C1CTE18FTVS
created: 2026-08-12T17:02:27.623322Z
updated: 2026-08-12T17:02:27.623322Z
type: task
title: Post-workflow-run summary report (assets by type/engine, scan coverage, findings by engine)
imported_from: linear
priority: high
task_status: done
assignee: steve
label:
- brief
- feature
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 266
---
## Summary

After a workflow run completes, produce a human-readable summary of what the run actually did, so engine testing (M8) has visible output without digging through worker logs or the asset/finding tables directly.

## Report contents

1. **Assets discovered, by type, by engine** — for each engine/step in the run, how many assets it emitted, broken down by asset kind (e.g. hostname, ip, url, ...).
2. **Scan coverage** — how many assets w…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-375](https://linear.app/stevevine/issue/DEV-375/post-workflow-run-summary-report-assets-by-typeengine-scan-coverage)