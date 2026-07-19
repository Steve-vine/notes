---
id: 01KXK82G1Z8AX0CJQ5JRCHA9PB
created: 2026-07-15T15:59:34.4633198Z
updated: 2026-07-19T21:30:27.696849687Z
type: task
title: Vendor API (/api/v1/vendors)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 169
sprint: s1lenxu
blocked_by:
- 01KXK822HGDVXE3MWXECAF7XCA
- 01KXK829M1RYJKBP5YP688WK0Y
comments:
- id: 01KXKR40SRNBSX1FPVD4HZ7XVG
  author: Steve Vine
  at: 2026-07-15T20:40:01.592281725Z
  text: |-
    Build complete on feature/com-169-vendor-api; PR #160 open against main, branch merged to staging.

    **What was done**
    - Full Phase-1 REST surface mirroring the risks router: create (forces state=new, revision 1), list with company + state/status/criticality/owner/q filters (escaped ilike for q), get, PATCH with transition validation, soft DELETE, revision history.
    - Transition enforcement: PATCH state checked against VENDOR_STATE_TRANSITIONS → 409 "Illegal state transition"; offboarded is terminal with an admin-only revert override (ADR 0039 §2). PATCH skips the revision write when nothing changed (risks-router behaviour preserved).
    - Revisions written via COM-168's shared write_vendor_revision helper — no duplicated snapshot logic.
    - 12 integration tests vs real Postgres + Redis covering CRUD, revisions, transitions, filters and the full role matrix.

    **Local verification**: ruff + format, mypy src, 84 unit + 12 integration passed, Semgrep p/default clean.

    **Decisions made on the fly**
    - compliance_status is PATCH-able in Phase 1: the ADR's "only review/approval paths move it" discipline starts in Phase 2 when those paths exist — otherwise the field would be frozen at not_assessed with no reviews to derive from.
    - The list `status` query param maps to compliance_status (matching the task brief's filter list); lifecycle uses the `state` param.
- id: 01KXKRNKVHRG88JTY19YYV3V5C
  author: Steve Vine
  at: 2026-07-15T20:49:38.161657305Z
  text: 'Released: PR #160 squash-merged to main as e7f3a5b (COM-169: Vendor API). Main-push CI (test suite + production deploy) triggered; feature branch deleted. Marking Done.'
assignee: steve
task_status: done
priority: medium
---
The Phase-1 vendor REST surface (ADR 0039 §9), mirroring `api/v1/risks.py`/`assessments.py`.

- [x] Schemas in `api/v1/schemas.py`: `VendorOut`, `VendorCreate`, `VendorUpdate`, `VendorRevisionOut` (`website` uses the shared `_HttpUrl` pattern).
- [x] `api/v1/vendors.py` (`APIRouter(prefix="/vendors", tags=["vendors"])`), registered in `api/v1/router.py`:
  - `GET /vendors` — company query param + filters state/status/criticality/owner/q [require_vendor_read]
  - `POST /vendors` — creates as state=new + first revision [require_vendor_write]
  - `GET /vendors/{id}` [read] · `PATCH /vendors/{id}` — validates state transitions against the model's map (409; offboarded terminal, admin-only revert), writes a revision only on real change [write] · `DELETE /vendors/{id}` — soft delete [write]
  - `GET /vendors/{id}/revisions` [read]
- [x] Integration tests (`tests/test_vendors.py`, 12 tests): CRUD + revision history, illegal transition 409, terminal offboarded + admin revert, dormant round-trip, all list filters, role gating (manager writes; owner/assessor/viewer read-only; analyst/company-assessor 403; unauthenticated 401).

Branch `feature/com-169-vendor-api`, PR #160. Ref: ADR 0039 §2, §8–9.