---
id: 01KXGRAHNECVCY3BP70X6P4BK3
created: 2026-07-14T16:45:52.174370082Z
updated: 2026-07-14T16:45:52.174370082Z
type: task
title: Company entity + default company
label: brief
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 8
---
Introduce Company as the first-class scoping entity per ADR 0009.

- [ ] Company model (`name`, `slug`, `is_default`, `status`) + migration
- [ ] CRUD API under `/api/v1`
- [ ] Seed a default company so single-company operation has no friction
- [ ] Establish the per-company FK pattern other tables will adopt

Depends on: Database foundation. Refs: ADR 0009, 0015.

---
*Migrated from Linear [DEV-394](https://linear.app/stevevine/issue/DEV-394/company-entity-default-company) · created 2026-06-13 · completed 2026-06-14*  
*Related to (Linear): DEV-401, DEV-395, DEV-393*