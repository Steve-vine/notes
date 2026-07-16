---
id: 01KXK8685QZZ47RR80WAZJH8SA
created: 2026-07-15T16:01:37.463442292Z
updated: 2026-07-16T12:36:02.19513596Z
type: task
title: Approval areas, approvers & rules + admin UI
assignee: steve
label:
- brief
priority: medium
task_status: backlog
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 181
blocked_by:
- 01KXK8323S7Y8BV1RN3HN4Q2X1
sprint: sxngp10
---
Phase 3 (ADR 0039 §6): the user-definable approval reference data.

- [ ] `approval_areas` (CompanyScoped: name, description, position, active), `vendor_approvers` ((area_id, user_id) join), `approval_rules` (per-area typed criteria: `always_required`, `min_criticality`, `data_types_any` JSONB) + migration.
- [ ] CRUD APIs [require_vendor_write for areas/rules; approver membership too].
- [ ] Management UI: areas list, per-area approver picker, criteria editor.
- [ ] Tests: rule evaluation function against engagement fixtures (the required-areas set).

Ref: ADR 0039 §6.