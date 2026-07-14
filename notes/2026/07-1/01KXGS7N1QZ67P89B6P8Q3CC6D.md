---
id: 01KXGS7N1QZ67P89B6P8Q3CC6D
created: 2026-07-14T17:01:45.91113595Z
updated: 2026-07-14T17:01:45.91113595Z
type: task
title: Risk register & detail UI
label: brief
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 39
---
The Risks section (ADR 0017 — the `/risks` nav item, currently a placeholder), per the selected company.

- [ ] Browse risks: table filterable by status / band / owner, with banded score badges (inherent + residual; Low/Med/High/Critical colours from the scales).
- [ ] Risk detail: 5×5 likelihood×impact scoring for inherent **and** residual (with the derived score/band), title/description, owner, status workflow.
- [ ] Linked **controls** (the Core controls that mitigate, → control detail) and **gaps** — link/unlink inline.
- [ ] Treatment plans: list + add/edit (type, owner, due date, status), with the accept-vs-appetite path surfaced.

Refs: ADR 0012, 0017, 0018. Depends on: Risk register model + API, Treatment plans.

---
*Migrated from Linear [DEV-451](https://linear.app/stevevine/issue/DEV-451/risk-register-and-detail-ui) · created 2026-06-17 · completed 2026-06-17*  
*Related to (Linear): DEV-453, DEV-452*