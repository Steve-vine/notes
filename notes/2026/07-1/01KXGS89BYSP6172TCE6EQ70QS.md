---
id: 01KXGS89BYSP6172TCE6EQ70QS
created: 2026-07-14T17:02:06.71834312Z
updated: 2026-07-14T17:02:06.71834312Z
type: task
title: 'Risk dashboard: heatmap + appetite breaches'
label: brief
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 40
---
Derived risk reporting per company (ADR 0012/0011) — see the risk posture at a glance.

- [ ] Risk API: per-company aggregates — counts by band, the residual 5×5 **heat-map** matrix (cell = risk count), and risks whose **residual exceeds appetite** (<issue id="f34a32da-81d5-4ab5-8aa0-4e6dd765b954" href="https://linear.app/stevevine/issue/DEV-448/risk-scoring-scales-appetite-rubric">DEV-448</issue>) flagged for escalation.
- [ ] Risk overview view: the 5×5 heat-map (banded colours), band totals, and an "over appetite" list; links through to the register/detail. Surface on the dashboard and/or a risk overview tab.
- [ ] Inherent-vs-residual delta visible (treatment effectiveness).

Refs: ADR 0012, 0011, 0017, 0018. Depends on: Risk register model + API, Risk scoring scales + appetite.

---
*Migrated from Linear [DEV-452](https://linear.app/stevevine/issue/DEV-452/risk-dashboard-heatmap-appetite-breaches) · created 2026-06-17 · completed 2026-06-17*  
*Related to (Linear): DEV-453, DEV-436, DEV-451*