---
id: 01KXK82NJG4PQ3SH8HANHK6HSW
created: 2026-07-15T15:59:40.112832075Z
updated: 2026-07-15T15:59:40.112832075Z
type: task
title: VendorFlag model + API (user-definable flags)
priority: medium
label: brief
assignee: steve
task_status: backlog
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 170
---
User-definable, company-scoped vendor flags (PCI, Healthcare, Breach…) — ADR 0039 §3.

- [ ] `models/vendor_flag.py`: UUID/Timestamp/Actor/CompanyScoped; `name` (`UniqueConstraint(company_id, name)`), `color` (Mantine color key), `description`.
- [ ] `vendor_flag_assignments` join: composite PK (vendor_id, flag_id), both FKs CASCADE (the `content_reviewers` shape). Flag delete = hard delete, cascades assignments.
- [ ] Migration; `vendor_flags` added to `_AUDITED_TABLES`.
- [ ] `api/v1/vendor_flags.py`: GET/POST/PATCH/DELETE `/vendor-flags` [read gates on require_vendor_read, writes on require_vendor_write].
- [ ] Vendor endpoints gain `flag_ids` (full-set assignment on create/update), `flags` on `VendorOut`, and a `flag_id` list filter.
- [ ] Tests: per-company name uniqueness, assignment round-trip, cascade on flag delete, filter.

Branch `feature/com-<id>-vendor-flags`. Ref: ADR 0039 §3.