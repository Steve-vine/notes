---
id: 01KZVECNN7Q8QT9CWBW5N4ABMN
created: 2026-08-12T16:55:18.439185Z
updated: 2026-08-12T16:55:18.439185Z
type: task
title: 'Run report: per-step findings row contradicts itself on re-runs ("70 total" vs "No findings attributed") — adopt the emitted/new/known format'
assignee: steve
task_status: done
imported_from: linear
priority: medium
label: bug
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 232
---
## Summary

In the workflow-run **Report**, the per-step **Findings** row shows a header count and a per-step drill-down that **contradict each other on a re-run**:

* Header (`FindingEngineRow`, `app/frontend/src/features/workflow-runs/workflow-run-detail.tsx:700`): `{step.finding_count} total` + severity chips → e.g. **"Vulnerability Scanner · 70 total"**, right-side **"Info 70"**.
* Drill-down (`StepFindingsExpansion`, same file `:634`): list…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-454](https://linear.app/stevevine/issue/DEV-454/run-report-per-step-findings-row-contradicts-itself-on-re-runs-70)