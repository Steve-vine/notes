---
id: 01KXK8685QZZ47RR80WAZJH8SA
created: 2026-07-15T16:01:37.463442292Z
updated: 2026-07-19T21:30:27.293262561Z
type: task
title: Approval areas, approvers & rules + admin UI
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 181
sprint: sxngp10
blocked_by:
- 01KXK8323S7Y8BV1RN3HN4Q2X1
comments:
- id: 01KXNGWRME2QA51V882KEZP07Y
  author: Steve Vine
  at: 2026-07-16T13:12:12.686306541Z
  text: |-
    Build complete on feature/com-181-approval-areas (stacked on COM-180); PR #172 open against main, branch merged to staging.

    Decisions: added GET /approval-areas/assignable-users (slim id/name/email, require_vendor_write) because GET /users is admin-only and the approver picker needs real user selection — minimal exposure, recorded for the ADR review; rule evaluation lives in core/vendor_approval.py so COM-182's execution uses the identical function; area deletion is deferred to retire (the vendor_approvals guard lands next brief).

    Local verification: ruff + format, mypy src, 88 unit + 5 integration, 187 Vitest, build, Semgrep clean.
- id: 01KXNK4A0SFKRTM63M5P455R9C
  author: Steve Vine
  at: 2026-07-16T13:51:17.017071971Z
  text: |-
    Staging deploy failure traced to migration 0044 and fixed (3b27047): `sa.Enum(..., create_type=False)` silently ignores create_type when the referenced type (vendor_criticality) was created by an earlier migration in a *separate* alembic invocation — staging's incremental 0043→head deploy hit "type vendor_criticality already exists", while the fresh-DB round trip passed because the whole chain shares one process. Fixed with `postgresql.ENUM(..., create_type=False)` (the dialect class honours it unconditionally); reproduced and verified with a two-invocation testcontainers harness before pushing. Fix propagated through the stacked COM-182/183 branches; staging rebuilt from main + all six branches.

    Lesson for future migrations: cross-migration enum reuse must use postgresql.ENUM, not sa.Enum — the 0012-style sa.Enum(create_type=False) precedent is only safe within a single migration file.
assignee: steve
task_status: done
priority: medium
---
Phase 3 (ADR 0039 §6): the user-definable approval reference data.

- [x] `approval_areas` (CompanyScoped: name, description, position, active), `vendor_approvers` ((area_id, user_id) composite join), `approval_rules` (per-area typed criteria: `always_required`, `min_criticality` reusing the vendor_criticality enum, `data_types_any` JSONB) + migration 0044.
- [x] CRUD APIs [require_vendor_write]: area POST/PATCH (retire/reactivate), PUT approvers (full-set), rule POST/DELETE with shape validation; plus `GET /approval-areas/assignable-users` — a slim id/name/email active-user list for the picker (the admin user surface stays admin-gated).
- [x] Rule-evaluation helper `core/vendor_approval.py` (rule_matches + required_area_ids: OR semantics, active areas only) — shared with COM-182 so submission and execution can't diverge.
- [x] Management UI: Approvals tab on the Vendors page — per-area cards with approver MultiSelect, rule badges + add-rule modal, retire/reactivate, add-area modal.
- [x] Tests: 4 pure unit (rule evaluation incl. untriaged vendors + OR/active fixtures) + 2 integration + 2 Vitest.

Branch `feature/com-181-approval-areas` (stacked on COM-180), PR #172. Ref: ADR 0039 §6.