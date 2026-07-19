---
id: 01KXGS4YTEY7T2TDTHPNN2A1RQ
created: 2026-07-14T17:00:17.614513962Z
updated: 2026-07-14T20:47:49.774342Z
type: task
title: Risk scoring scales + appetite (rubric)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 36
sprint: sq2tcpq
comments:
- id: 01KXGS59Y6FRW6XXFF93PSPNDE
  author: Steve Vine
  at: 2026-07-14T17:00:28.99821584Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-17 11:15 UTC]
    PR open: https://github.com/Steve-vine/compass/pull/33

    **Delivered** (all four checklist items)
    - **Three versioned reference tables** (full history on all three, as agreed): `RiskScaleLevel` (likelihood/impact descriptors), `RiskScoreBand` (band thresholds), `RiskAppetite` (per-category max residual + default). Migration `0011`, idempotent seed from `rubrics.md` (10/4/6) + `import-risk-rubric` CLI wired into the import Job.
    - **`/risk-rubric` API**: GET list / admin PATCH (revision-on-change) / GET revisions for scale, bands and appetite — a faithful clone of the maturity rubric.
    - **`core/risk_scoring.py`** shared helpers (score, band_for, appetite_for, is_over_appetite) for the register/dashboard/exports to reuse.
    - **Admin → Risk rubric** tab: three editable tables with Save + History.

    **Verification**: backend ruff/mypy + full integration suite **81 passed** (4 new) + 4 scoring unit tests; frontend lint/typecheck/39 tests (4 new)/format/build — all green. Org-wide reference data; ships on the next roll.

    Unblocks DEV-449 (register), DEV-450 (treatments), DEV-452 (dashboard).
assignee: steve
label:
- brief
priority: medium
task_status: done
---
The risk rubric foundation (ADR 0018) — editable in-app reference data the whole risk module scores against. Seeds from `brief/rubrics.md`; mirrors the maturity-rubric work (<issue id="4bfec9e6-6476-43ff-9a5c-2d25e4d9d8ec" href="https://linear.app/stevevine/issue/DEV-405/maturity-rubric-editable-reference-data">DEV-405</issue>/406).

- [ ] `ScoreScale` reference data: likelihood (1–5) and impact (1–5) descriptors + the score-band thresholds (Low 1–4 / Medium 5–9 / High 10–14 / Critical 15–25). Model + migration + idempotent seed + read API.
- [ ] `RiskAppetite`: maximum tolerable residual per risk **category** with an org-wide **default** categories may override.
- [ ] Admin → Settings UI to edit descriptors, band thresholds and appetite values (history preserved, not overwritten).
- [ ] A shared scoring helper (score = likelihood × impact; value → band) reused by the register, dashboard and exports.

Org-wide (not per-company). Refs: ADR 0012, 0018, 0015; brief/rubrics.md.

---
*Migrated from Linear [DEV-448](https://linear.app/stevevine/issue/DEV-448/risk-scoring-scales-appetite-rubric) · created 2026-06-17 · completed 2026-06-17*  
*Related to (Linear): DEV-405, DEV-450*