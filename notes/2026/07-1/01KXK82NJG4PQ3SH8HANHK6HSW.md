---
id: 01KXK82NJG4PQ3SH8HANHK6HSW
created: 2026-07-15T15:59:40.112832075Z
updated: 2026-07-19T21:30:26.467187086Z
type: task
title: VendorFlag model + API (user-definable flags)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 170
sprint: s1lenxu
blocked_by:
- 01KXK82G1Z8AX0CJQ5JRCHA9PB
comments:
- id: 01KXKS2KQM4DYHM366EMVZRK0H
  author: Steve Vine
  at: 2026-07-15T20:56:44.020066742Z
  text: |-
    Build complete on feature/com-170-vendor-flags; PR #161 open against main, branch merged to staging.

    **What was done**
    - VendorFlag model (unique name per company, Mantine color key) + composite-PK vendor_flag_assignments join with CASCADE FKs; migration 0036; vendor_flags added to the audit allowlist.
    - /vendor-flags CRUD router (read/write on the vendor guards; 409 on duplicate name for both create and rename).
    - Vendor endpoints extended: flag_ids full-set assignment (omitted = unchanged, [] = clear, unknown/cross-company flag → 404), flags embedded on VendorOut via one batched query for the list endpoint, and a `flag` filter.
    - 9 integration tests; existing vendor + migration suites re-run green.

    **Local verification**: ruff + format, mypy src, 84 unit + 23 integration passed, Semgrep p/default clean.

    **Decisions made on the fly**
    - A flags-only PATCH does not write a VendorRevision (flags are labels, not snapshotted facts — ADR 0039 §3), but it does stamp updated_by/updated_at.
    - VendorOut is now constructed explicitly in the router (rather than ORM from_attributes) so `flags` can be embedded without adding SQLAlchemy relationships, which the codebase doesn't use.
    - Flag name uniqueness is case-sensitive, matching the DB constraint; a case-insensitive guard would need a functional index — deferred unless it bites.
- id: 01KXKSSFA69V7TJH4TNJED7W0P
  author: Steve Vine
  at: 2026-07-15T21:09:13.158054119Z
  text: 'Released: PR #161 squash-merged to main as 30ebdce (COM-170: VendorFlag model + API). Main-push CI (test suite + production deploy) triggered; feature branch deleted. Marking Done.'
assignee: steve
task_status: done
priority: medium
---
User-definable, company-scoped vendor flags (PCI, Healthcare, Breach…) — ADR 0039 §3.

- [x] `models/vendor_flag.py`: UUID/Timestamp/Actor/CompanyScoped; `name` (`UniqueConstraint(company_id, name)`), `color` (Mantine color key, default gray), `description`. No SoftDelete — flags are labels.
- [x] `vendor_flag_assignments` join (`models/vendor_flag_assignment.py`): composite PK (vendor_id, flag_id), both FKs CASCADE (the `content_reviewers` shape). Flag delete = hard delete, cascades assignments.
- [x] Migration 0036 (real downgrade); `vendor_flags` added to `_AUDITED_TABLES` (assignments unaudited, like other join tables).
- [x] `api/v1/vendor_flags.py`: GET/POST/PATCH/DELETE `/vendor-flags` [reads require_vendor_read, writes require_vendor_write]; duplicate name per company → 409 on create and rename.
- [x] Vendor endpoints gain `flag_ids` (full-set assignment on create/update; omitted = unchanged, [] = clear; unknown/cross-company flag → 404), `flags` on `VendorOut` (batched lookup, no N+1), and a `flag` list filter. Flags-only PATCH writes no revision.
- [x] Tests (9 integration): per-company name uniqueness, assignment round-trip, cascade on flag delete, filter, no-revision rule, role gating.

Branch `feature/com-170-vendor-flags`, PR #161. Ref: ADR 0039 §3.