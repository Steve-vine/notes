---
id: 01KXK829M1RYJKBP5YP688WK0Y
created: 2026-07-15T15:59:27.873862546Z
updated: 2026-07-15T20:20:35.208139936Z
type: task
title: Vendor + VendorRevision models & migration
task_status: review
priority: medium
label:
- brief
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 168
blocked_by:
- 01KXK69HD5SYCKV01J1XVPG5Y2
sprint: s1lenxu
---
The core Vendor entity and its append-only revision history (ADR 0039 §1–3). Models + migration only; the API is the next brief.

- [x] `models/vendor.py`: mixins UUID/Timestamp/Actor/SoftDelete/CompanyScoped (the `Risk` composition). Fields: `name`, `website`, `description`, `notes`, `criticality` (StrEnum critical/high/medium/low, nullable), `owner_id` FK→users SET NULL.
- [x] `VendorState` StrEnum (new/active/non_compliant/dormant/offboarded, default new) + `VendorComplianceStatus` StrEnum (not_assessed/compliant/under_review/non_compliant, default not_assessed) — named SAEnums shared as module constants.
- [x] Module-level allowed-transitions map beside the enum (ADR 0039 §2): new→active; active↔non_compliant; active|non_compliant→dormant; dormant→active; any→offboarded (terminal, admin revert only).
- [x] `models/vendor_revision.py`: the `RiskRevision` pattern — 1-based `revision`, FK RESTRICT, snapshot of all mutable columns; `write_vendor_revision` helper + `VENDOR_SNAPSHOT_FIELDS` live in the model module so the API brief imports them.
- [x] Migration 0035 (explicit enum create/drop, real downgrade, `op.f` names).
- [x] Add `vendors` to `_AUDITED_TABLES` (`db/audit.py`); model docstring citing ADR 0039 + the "extend the snapshot when adding columns" reminder.
- [x] Tests: migration up/down (test_db round-trip), transition map shape + snapshot contract (7 unit), revision helper vs real Postgres (1 integration).

Branch `feature/com-168-vendor-models`, PR #159. Ref: ADR 0039 §1–3.