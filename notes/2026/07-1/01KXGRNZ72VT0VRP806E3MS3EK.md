---
id: 01KXGRNZ72VT0VRP806E3MS3EK
created: 2026-07-14T16:52:06.498882591Z
updated: 2026-07-14T16:52:18.682753843Z
type: task
title: Compliance & maturity dashboard
label:
- brief
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 18
sprint: sz3kacg
comments:
- id: 01KXGRPB3TCYHRSW8FX5M9WEGX
  author: Steve Vine
  at: 2026-07-14T16:52:18.682663215Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-15 20:23 UTC]
    PR up for review: https://github.com/Steve-vine/compass/pull/17

    **Stacked on DEV-403** — its PR base is the `steve/dev-403-…` branch (auto-retargets to `main` once [#16](https://github.com/Steve-vine/compass/pull/16) merges). Please review/merge #16 first. No new migration — the dashboard is read-only aggregation.

    All three checklist items delivered:
    - **Per-company posture API** `GET /api/v1/dashboard?company=…` — per-domain compliance % + average maturity, open-gap counts, overall headline totals, and a recent-activity feed (assessment changes + gap raises). Compliance % = implemented ÷ applicable, where applicable excludes not-applicable controls and an unassessed control counts as a shortfall (empty company → 0%, not "no data").
    - **Dashboard UI** — compliance ring + maturity / open-gaps / assessed cards; a maturity & compliance heatmap by domain; a recent-activity feed.
    - **Heatmap cells link into domain/control** — domain rows → `/domains/{slug}`, activity refs → `/controls/{ref}`.

    Verification: backend ruff/mypy(src) clean, 27 unit + 41 integration tests pass; frontend eslint/tsc/prettier clean, 13 vitest pass.

    This completes the Milestone 2 "know where we stand" set (assessments → gaps → dashboard). Out of scope: trend charts, framework coverage (M3), risk posture (M4), report exports.
---
The "know where we stand" payoff per ADR 0011/0017 — the MVP's headline view.

- [ ] Per-company posture API: compliance % and maturity rollups by domain, open-gap counts, recent activity
- [ ] Dashboard UI: compliance %, maturity heatmap by domain, open gaps, recent activity
- [ ] Heatmap cells link into the domain / control

Depends on: Assessment model + API, Gaps. Refs: ADR 0011, 0017.

---
*Migrated from Linear [DEV-404](https://linear.app/stevevine/issue/DEV-404/compliance-and-maturity-dashboard) · created 2026-06-13 · completed 2026-06-15*  
*Related to (Linear): DEV-427*