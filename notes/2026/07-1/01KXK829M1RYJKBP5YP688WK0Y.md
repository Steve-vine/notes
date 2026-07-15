---
id: 01KXK829M1RYJKBP5YP688WK0Y
created: 2026-07-15T15:59:27.873862546Z
updated: 2026-07-15T16:00:09.535867203Z
type: task
title: Vendor + VendorRevision models & migration
task_status: backlog
priority: medium
label:
- brief
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 168
sprint: s1lenxu
---
The core Vendor entity and its append-only revision history (ADR 0039 §1–3). Models + migration only; the API is the next brief.

- [ ] `models/vendor.py`: mixins UUID/Timestamp/Actor/SoftDelete/CompanyScoped (the `Risk` composition). Fields: `name`, `website`, `description`, `notes`, `criticality` (StrEnum critical/high/medium/low, nullable), `owner_id` FK→users SET NULL.
- [ ] `VendorState` StrEnum (new/active/non_compliant/dormant/offboarded, default new) + `VendorComplianceStatus` StrEnum (not_assessed/compliant/under_review/non_compliant, default not_assessed) — named SAEnums shared as module constants.
- [ ] Module-level allowed-transitions map beside the enum (ADR 0039 §2): new→active; active↔non_compliant; active|non_compliant→dormant; dormant→active; any→offboarded (terminal, admin revert only).
- [ ] `models/vendor_revision.py`: the `RiskRevision` pattern — 1-based `revision`, FK RESTRICT, snapshot of all mutable columns; revision-write helper.
- [ ] Migration (explicit enum create/drop, real downgrade, `op.f` names).
- [ ] Add `vendors` to `_AUDITED_TABLES` (`db/audit.py`); model docstring citing ADR 0039 + the "extend the snapshot when adding columns" reminder.
- [ ] Tests: migration up/down, transition map shape, revision helper.

Branch `feature/com-<id>-vendor-models`. Ref: ADR 0039 §1–3.