---
id: 01KZVEQ7MFV9N3REPX9D7HSJAN
created: 2026-08-12T17:01:04.527953Z
updated: 2026-08-12T17:02:10.877691Z
type: task
title: Run report frozen on stale data for fast runs — polling stops on runStatus prop, not fetched payload
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 264
sprint: sewyev2
assignee: steve
imported_from: linear
label:
- follow_up
- bug
priority: null
task_status: done
---
## Symptom

Watching a **fast run** (e.g. single-step cloudflare-dns-discovery) on the run-detail page, the Brief 111 run report stays empty / "not recorded" even after the run succeeds. A slower multi-step run (cloudflare + tls-certificate-analysis) displays fine. Backend verified innocent: the single-step run's `workflow_step_runs.meta` carries `asset_count: 412`, `asset_kind_counts: {"subdomain": 412}`, `finding_severity_counts: {}` — the dat…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-379](https://linear.app/stevevine/issue/DEV-379/run-report-frozen-on-stale-data-for-fast-runs-polling-stops-on) · parent DEV-375