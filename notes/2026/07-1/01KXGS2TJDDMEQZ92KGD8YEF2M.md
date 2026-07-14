---
id: 01KXGS2TJDDMEQZ92KGD8YEF2M
created: 2026-07-14T16:59:07.725701955Z
updated: 2026-07-14T16:59:14.270718685Z
type: task
title: Framework coverage reporting
task_status: done
label:
- brief
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 33
sprint: s9wnr7r
---
Derived per-company framework coverage (ADR 0010/0011) — "% of ISO 27001 satisfied", rolled up from Core assessments via the crosswalk (frameworks are not assessed directly).

- [ ] Coverage API: per requirement, derive a status (met / partial / unmet / not-assessed) from the satisfying Core controls' assessment posture; framework-level coverage % per company.
- [ ] Coverage view: a framework's requirements with their derived status + the contributing controls; overall coverage %.
- [ ] Unmapped requirements count against coverage and are flagged (ADR 0010 — Core is the superset).

Depends on: Crosswalk model + API (+ M2 Assessments). Refs: ADR 0010, 0011, 0017.

---
*Migrated from Linear [DEV-434](https://linear.app/stevevine/issue/DEV-434/framework-coverage-reporting) · created 2026-06-16 · completed 2026-06-17*  
*Related to (Linear): DEV-435, DEV-431*