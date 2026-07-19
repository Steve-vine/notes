---
id: 01KXK829M1RYJKBP5YP688WK0Y
created: 2026-07-15T15:59:27.873862546Z
updated: 2026-07-19T21:30:26.841794225Z
type: task
title: Vendor + VendorRevision models & migration
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 168
sprint: s1lenxu
blocked_by:
- 01KXK69HD5SYCKV01J1XVPG5Y2
comments:
- id: 01KXKQ1429CJYZB0YNFA78S1AE
  author: Steve Vine
  at: 2026-07-15T20:20:58.057708464Z
  text: |-
    Build complete on feature/com-168-vendor-models; PR #159 open against main, branch merged to staging.

    **What was done**
    - Vendor model with the Risk mixin composition; two stored status fields (lifecycle state + assurance compliance_status) as named Postgres enums; VENDOR_STATE_TRANSITIONS map beside the enum (new→active; active↔non_compliant; active|non_compliant→dormant; dormant→active; any→offboarded terminal).
    - VendorRevision (RiskRevision pattern) + write_vendor_revision helper and VENDOR_SNAPSHOT_FIELDS exported from the model module so COM-169's router imports rather than re-implements.
    - Migration 0035: enums created on the vendors table, reused with create_type=False on the snapshot, real downgrade dropping tables + all three types; vendors added to _AUDITED_TABLES.
    - Tests: 7 unit (transition-map shape + a snapshot-contract test that fails if a future vendors column skips the revision table), 1 integration (helper appends 1-based snapshots vs real Postgres); migration covered by test_db's alembic round-trip.

    **Local verification**: ruff + format, mypy src, 84 unit + 4 integration passed, Semgrep p/default clean on the new files (lesson from COM-167 applied — no f-string SQL anywhere).

    **Decisions made on the fly**
    - The revision helper lives in models/vendor_revision.py (not the router, where risks keeps its private copy) because this brief ships no router yet and the API brief needs it importable.
    - criticality is nullable in Phase 1 — a vendor can be registered before triage assigns one.
- id: 01KXKQP26SGMKN4EECP7TFGZ77
  author: Steve Vine
  at: 2026-07-15T20:32:24.281500388Z
  text: 'Released: PR #159 squash-merged to main as 8878f6c (COM-168: Vendor + VendorRevision models & migration). Main-push CI (test suite + production deploy) triggered; feature branch deleted. Marking Done.'
assignee: steve
task_status: done
priority: medium
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