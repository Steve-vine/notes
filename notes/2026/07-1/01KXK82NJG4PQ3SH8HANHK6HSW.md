---
id: 01KXK82NJG4PQ3SH8HANHK6HSW
created: 2026-07-15T15:59:40.112832075Z
updated: 2026-07-15T20:56:31.442752267Z
type: task
title: VendorFlag model + API (user-definable flags)
priority: medium
label:
- brief
assignee: steve
task_status: review
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 170
blocked_by:
- 01KXK82G1Z8AX0CJQ5JRCHA9PB
sprint: s1lenxu
---
User-definable, company-scoped vendor flags (PCI, Healthcare, Breach…) — ADR 0039 §3.

- [x] `models/vendor_flag.py`: UUID/Timestamp/Actor/CompanyScoped; `name` (`UniqueConstraint(company_id, name)`), `color` (Mantine color key, default gray), `description`. No SoftDelete — flags are labels.
- [x] `vendor_flag_assignments` join (`models/vendor_flag_assignment.py`): composite PK (vendor_id, flag_id), both FKs CASCADE (the `content_reviewers` shape). Flag delete = hard delete, cascades assignments.
- [x] Migration 0036 (real downgrade); `vendor_flags` added to `_AUDITED_TABLES` (assignments unaudited, like other join tables).
- [x] `api/v1/vendor_flags.py`: GET/POST/PATCH/DELETE `/vendor-flags` [reads require_vendor_read, writes require_vendor_write]; duplicate name per company → 409 on create and rename.
- [x] Vendor endpoints gain `flag_ids` (full-set assignment on create/update; omitted = unchanged, [] = clear; unknown/cross-company flag → 404), `flags` on `VendorOut` (batched lookup, no N+1), and a `flag` list filter. Flags-only PATCH writes no revision.
- [x] Tests (9 integration): per-company name uniqueness, assignment round-trip, cascade on flag delete, filter, no-revision rule, role gating.

Branch `feature/com-170-vendor-flags`, PR #161. Ref: ADR 0039 §3.