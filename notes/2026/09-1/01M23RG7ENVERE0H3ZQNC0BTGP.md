---
id: 01M23RG7ENVERE0H3ZQNC0BTGP
created: 2026-09-09T18:57:19.829693Z
updated: 2026-09-09T18:57:19.829693Z
type: task
title: One posture calculation — the Dashboard, coverage and risk overview read the same function the snapshot will write
label: chore
priority: high
assignee: steve
task_status: backlog
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 635
---
Before anything records posture nightly, there has to be one place that computes it. Today the arithmetic is spread across three endpoints: `api/v1/dashboard.py` (compliance, tiers, per-domain, open gaps), `api/v1/coverage.py` (per-framework met/applicable, via `core/coverage.py`), and `api/v1/risk_overview.py` (band counts, over appetite). Each is right on its own; the snapshot must not become a fourth version.

- New `core/posture.py` with one entry point, `measure(db, company) -> PostureMeasure`: a plain dataclass (JSON-serialisable) holding the headline (applicable, assessed, implemented, compliance %, avg maturity), the three tiers, the per-domain rollup, per-framework posture for every active framework (applicable, met, percent, excluded), gaps (open, overdue — `target_date` past and status in `OPEN_GAP_STATUSES`), and risks (total, residual band counts, over appetite).
- The three endpoints call it and shape the response from it. **No behaviour change** — the existing dashboard, coverage and risk-overview tests are the proof; the OpenAPI schema does not move.
- The per-framework figure is the coverage endpoint's headline (met ÷ applicable requirements, ADR 0057 exclusions out of the denominator). Reuse `core/coverage.py`'s derivation, never re-derive.

**Overdue gaps is the one new number.** The Dashboard shows open gaps; the Timeline wants overdue beside it. Add it to `measure()` here so the snapshot has it from its first row; whether the Dashboard shows it too is not this task.

Nothing user-visible ships from this task. It exists so the snapshot task is small and so the line can never disagree with the ring.