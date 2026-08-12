---
id: 01KZVECG1VS54ZR7SEF9MQ9YQF
created: 2026-08-12T16:55:12.699745Z
updated: 2026-08-12T16:56:01.096137Z
type: task
title: 'Findings: per-run confirmation linkage so the run-report drill-down lists re-confirmed findings (not only first-discovered)'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 231
sprint: sewyev2
assignee: steve
imported_from: linear
label:
- tech_debt
priority: low
task_status: done
---
## Summary

Follow-up to DEV-454 (which is the *labeling* fix). Finding provenance is **set-once on first discovery** (`discovered_in_workflow_step_run_id`, Brief 112) and there is **no per-run/step "confirmed this run" linkage** for findings — unlike assets, which got `last_…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-455](https://linear.app/stevevine/issue/DEV-455/findings-per-run-confirmation-linkage-so-the-run-report-drill-down)