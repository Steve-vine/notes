---
id: 01KZVEEWJPRQMTC31YJNBXVQDR
created: 2026-08-12T16:56:31.06262Z
updated: 2026-08-12T16:56:31.06262Z
type: task
title: Finding-ingest drops findings against un-minted target URLs (redirect/www) as orphan — vuln findings silently lost
label: bug
imported_from: linear
priority: urgent
task_status: done
assignee: steve
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 235
---
## Summary

`_ingest_findings_for_step_run` (`tasks/workflow_runs.py:1404-1425`) drops any finding whose target asset isn't **already** a minted asset — exact `(url, asset_value)` match, or a `host_base_url` fallback. Findings whose `matched-at` URL was never minted by an upstream step (most commonly a **redirect target**, e.g. `moneypenny.com → www.moneypenny.com`, or a deeper/other host) are logged `dispatch_step_run_finding_dropped_orphan_ass…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-445](https://linear.app/stevevine/issue/DEV-445/finding-ingest-drops-findings-against-un-minted-target-urls)