---
id: 01KXK822HGDVXE3MWXECAF7XCA
created: 2026-07-15T15:59:20.624324619Z
updated: 2026-07-15T16:27:46.43539096Z
type: task
title: Vendor roles plumbing (vendor-owner / vendor-manager / vendor-assessor)
label:
- brief
assignee: steve
priority: medium
task_status: review
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 167
blocked_by:
- 01KXK69HD5SYCKV01J1XVPG5Y2
comments:
- id: 01KXK9P3EN3GY1WKV21WM5QKP4
  author: Steve Vine
  at: 2026-07-15T16:27:45.493908917Z
  text: |-
    Build complete on feature/com-167-vendor-roles; PR #158 open against main, branch merged to staging.

    **What was done**
    - Role enum gains vendor_owner / vendor_manager / vendor_assessor; vendor capability frozensets + User predicates (can_read_vendors / can_write_vendors / can_submit_vendor_request / can_assess_vendors); require_vendor_read/write/submit/assess guards via the _require factory.
    - Migration 0034: in-place ALTER TYPE ADD VALUE ×3; real downgrade deletes vendor-role grants and rebuilds the type under a temp name (the 0019 promote pattern). Exercised by test_db's up/down test.
    - Frontend: Permissions/permissionsFor extended with the four vendor booleans; Users admin role picker gains the three options; schema.d.ts regenerated (offline OpenAPI dump — no server needed).
    - Tests: 8 predicate unit tests (test_vendor_roles.py), 2 authz integration tests (enum round-trip via /auth/me, admin assigns vendor roles via API), 6 frontend permission tests. All local runs green (ruff, mypy src, 77 unit + 12 integration, frontend lint/typecheck/format/154+6 tests).

    **Decisions made on the fly** (recorded as an amendment to ADR 0039)
    - Role identifiers are underscored (vendor_owner), not hyphenated: SQLAlchemy persists enum *names*, and every existing role keeps name == value — one spelling across DB, API and frontend. Display labels ("Vendor Owner") live in the UI.
    - Vendor roles joined _LIBRARY_READ, honouring ADR 0026's "library read is open to every role" amendment; Company access stays closed to them.

    **Problems encountered**
    - None of substance — one Prettier line-width fix and one Ruff line-length fix.
sprint: s1lenxu
---
Add the three new vendor roles and the Vendors permission section (ADR 0039 §8). No vendor entities yet — this is pure authZ plumbing so the rest of Sprint 26 can gate on it.

- [ ] `Role` enum (`models/user.py`): `vendor_owner = "vendor-owner"`, `vendor_manager = "vendor-manager"`, `vendor_assessor = "vendor-assessor"`.
- [ ] Capability frozensets + `User` predicates: `can_read_vendors` (admin, viewer, all three vendor roles), `can_write_vendors` (admin, vendor_manager), `can_submit_vendor_request` (+ vendor_owner), `can_assess_vendors` (admin, vendor_assessor).
- [ ] Guards in `core/auth.py` via the `_require` factory: `require_vendor_read/write/submit/assess`.
- [ ] Migration: add the three values to the `user_role` Postgres enum (downgrade recreates the type after deleting rows holding the new values — explicit-enum convention, see `0016_notifications.py`).
- [ ] Frontend: extend `Permissions`/`permissionsFor` in `src/auth/hooks.ts` (canReadVendors/canWriteVendors/canSubmitVendorRequest/canAssessVendors); `npm run generate:api` so the Users admin role picker offers the new roles.
- [ ] Tests: capability predicates, guard 403s, role assignment round-trip.

Branch `feature/com-<id>-vendor-roles`. Ref: ADR 0039, 0026.