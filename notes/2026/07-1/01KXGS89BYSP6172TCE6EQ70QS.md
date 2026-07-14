---
id: 01KXGS89BYSP6172TCE6EQ70QS
created: 2026-07-14T17:02:06.71834312Z
updated: 2026-07-14T18:32:39.998286862Z
type: task
title: 'Risk dashboard: heatmap + appetite breaches'
label:
- brief
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 40
sprint: sq2tcpq
comments:
- id: 01KXGS8N4VH2QXTWSQFWGRSP5E
  author: Steve Vine
  at: 2026-07-14T17:02:18.779286979Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-17 13:23 UTC]
    PR open: https://github.com/Steve-vine/compass/pull/37

    **Delivered** (all three checklist items)
    - **`GET /api/v1/risk-overview?company=`** — residual + inherent band counts, the residual 5×5 heat-map (25 cells), and the over-appetite escalation list. Reuses `risks._to_out`/`_rubric` so it never disagrees with the register.
    - **Risks page Overview tab** (Register | Overview): band totals (residual + inherent → treatment-effectiveness delta), a banded 5×5 heat-map, and an over-appetite list linking to the register.

    **Verification**: backend ruff/mypy + full integration suite **92 passed** (2 new); frontend lint/typecheck/48 tests (1 new)/format/build — all green. No migration; ships on the next image roll.

    M4 remaining: just **DEV-453** (evidence attachments on risks — a quick DEV-436 reuse).
blocked_by:
- 01KXGS4YTEY7T2TDTHPNN2A1RQ
- 01KXGS67RWK8T0Q5A0J7MVPMTW
---
Derived risk reporting per company (ADR 0012/0011) — see the risk posture at a glance.

- [ ] Risk API: per-company aggregates — counts by band, the residual 5×5 **heat-map** matrix (cell = risk count), and risks whose **residual exceeds appetite** (<issue id="f34a32da-81d5-4ab5-8aa0-4e6dd765b954" href="https://linear.app/stevevine/issue/DEV-448/risk-scoring-scales-appetite-rubric">DEV-448</issue>) flagged for escalation.
- [ ] Risk overview view: the 5×5 heat-map (banded colours), band totals, and an "over appetite" list; links through to the register/detail. Surface on the dashboard and/or a risk overview tab.
- [ ] Inherent-vs-residual delta visible (treatment effectiveness).

Refs: ADR 0012, 0011, 0017, 0018. Depends on: Risk register model + API, Risk scoring scales + appetite.

---
*Migrated from Linear [DEV-452](https://linear.app/stevevine/issue/DEV-452/risk-dashboard-heatmap-appetite-breaches) · created 2026-06-17 · completed 2026-06-17*  
*Related to (Linear): DEV-453, DEV-436, DEV-451*