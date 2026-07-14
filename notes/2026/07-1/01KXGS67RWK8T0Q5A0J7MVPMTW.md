---
id: 01KXGS67RWK8T0Q5A0J7MVPMTW
created: 2026-07-14T17:00:59.548558217Z
updated: 2026-07-14T18:32:39.938287414Z
type: task
title: 'Risk register: model + API'
task_status: done
label:
- brief
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 37
sprint: sq2tcpq
comments:
- id: 01KXGS6M9375XPKHDDM1P4Y9MA
  author: Steve Vine
  at: 2026-07-14T17:01:12.355654305Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-17 11:36 UTC]
    PR open: https://github.com/Steve-vine/compass/pull/34

    **Delivered** (all four checklist items)
    - **`Risk` model** (company-scoped) + migration `0012_risks` — inherent/residual L×I; score, band and over-appetite **derived** from the rubric via `core/risk_scoring.py`, never stored.
    - **`RiskControlLink` / `RiskGapLink`** soft-deletable joins (mirror `ControlMapping`).
    - **`/risks` API**: create / list (filter company/status/category/owner + derived band/over_appetite) / get / patch / revisions, with `RiskStatus` open→treated→accepted/closed and append-only `RiskRevision` history.
    - **Link/unlink** mitigating controls and related gaps (404/409/soft-delete).

    Note: I added a **`category`** field (free text, default `"default"`) to drive appetite resolution — flagged in the plan; it aligns with the DEV-448 appetite categories so DEV-452's over-appetite logic works.

    **Verification**: ruff/format/mypy clean; migration round-trips + `alembic check` clean; **full integration suite 87 passed** (6 new). Backend-only (register UI is DEV-451). Unblocks DEV-450/451/452/453.
blocked_by:
- 01KXGS4YTEY7T2TDTHPNN2A1RQ
---
The risk register — risks as first-class, per-company entities (ADR 0012), the core of M4.

- [ ] `Risk` model (company-scoped): `title`, `description`, `status`, `owner_id`, `inherent_likelihood`/`inherent_impact`, `residual_likelihood`/`residual_impact` (each 1–5) + migration. Score + band **derived** from the scales (<issue id="f34a32da-81d5-4ab5-8aa0-4e6dd765b954" href="https://linear.app/stevevine/issue/DEV-448/risk-scoring-scales-appetite-rubric">DEV-448</issue>), not stored.
- [ ] Links: `RiskControlLink` (risk × Core control — controls that mitigate) and `RiskGapLink` (risk × gap, optional). A gap is "a control isn't met"; a risk is "what could happen" — distinct but linked (ADR 0012).
- [ ] API: create / list (filter by company, status, band, owner) / get / update / status workflow (open → treated → accepted/closed) — admin/editor writes, any-auth reads; revision history preserved (mirror the assessment/gap pattern).
- [ ] Link/unlink mitigating controls and related gaps.

Refs: ADR 0012, 0015, 0018. Depends on: Risk scoring scales + appetite. Relates to: Gaps (M2).

---
*Migrated from Linear [DEV-449](https://linear.app/stevevine/issue/DEV-449/risk-register-model-api) · created 2026-06-17 · completed 2026-06-17*