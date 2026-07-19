---
id: 01KXGS2TJDDMEQZ92KGD8YEF2M
created: 2026-07-14T16:59:07.725701955Z
updated: 2026-07-19T21:30:29.863733777Z
type: task
title: Framework coverage reporting
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 33
sprint: s9wnr7r
blocked_by:
- 01KXGS1G8K7SD6ASJJ5JJVBF1B
comments:
- id: 01KXGS34XZAC2Q21RP2EN6WN1T
  author: Steve Vine
  at: 2026-07-14T16:59:18.334898657Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-16 22:05 UTC]
    PR open: https://github.com/Steve-vine/compass/pull/30

    **Delivered** (all three checklist items)
    - **Coverage API** `GET /api/v1/coverage?company=&framework=` — per-requirement derived status, contributing controls, and a framework-level coverage %.
    - **Strict scoring** (the agreed model): `met` only when every in-scope mapped control is implemented; `partial`/`unmet`/`not_assessed` otherwise; not-applicable controls excluded (mirrors `dashboard.py` posture).
    - **Unmapped requirements** flagged and counted against coverage (Core is the superset, ADR 0010).
    - **Coverage tab** on the framework page (company-scoped): headline ring + status-count badges + requirements table with status badges, Unmapped flags, and contributing-control links. Crosswalk stays the default tab.

    **Verification**: backend ruff/mypy + 4 integration tests; frontend lint/typecheck/31 tests (3 new)/format/build — all green. No contract changes to assessments or the crosswalk; ships on the next image roll.
assignee: steve
task_status: done
priority: medium
---
Derived per-company framework coverage (ADR 0010/0011) — "% of ISO 27001 satisfied", rolled up from Core assessments via the crosswalk (frameworks are not assessed directly).

- [ ] Coverage API: per requirement, derive a status (met / partial / unmet / not-assessed) from the satisfying Core controls' assessment posture; framework-level coverage % per company.
- [ ] Coverage view: a framework's requirements with their derived status + the contributing controls; overall coverage %.
- [ ] Unmapped requirements count against coverage and are flagged (ADR 0010 — Core is the superset).

Depends on: Crosswalk model + API (+ M2 Assessments). Refs: ADR 0010, 0011, 0017.

---
*Migrated from Linear [DEV-434](https://linear.app/stevevine/issue/DEV-434/framework-coverage-reporting) · created 2026-06-16 · completed 2026-06-17*  
*Related to (Linear): DEV-435, DEV-431*