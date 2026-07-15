---
id: 01KXK822HGDVXE3MWXECAF7XCA
created: 2026-07-15T15:59:20.624324619Z
updated: 2026-07-15T16:00:21.671018307Z
type: task
title: Vendor roles plumbing (vendor-owner / vendor-manager / vendor-assessor)
label:
- brief
assignee: steve
priority: medium
task_status: backlog
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 167
sprint: s1lenxu
blocked_by:
- 01KXK69HD5SYCKV01J1XVPG5Y2
---
Add the three new vendor roles and the Vendors permission section (ADR 0039 §8). No vendor entities yet — this is pure authZ plumbing so the rest of Sprint 26 can gate on it.

- [ ] `Role` enum (`models/user.py`): `vendor_owner = "vendor-owner"`, `vendor_manager = "vendor-manager"`, `vendor_assessor = "vendor-assessor"`.
- [ ] Capability frozensets + `User` predicates: `can_read_vendors` (admin, viewer, all three vendor roles), `can_write_vendors` (admin, vendor_manager), `can_submit_vendor_request` (+ vendor_owner), `can_assess_vendors` (admin, vendor_assessor).
- [ ] Guards in `core/auth.py` via the `_require` factory: `require_vendor_read/write/submit/assess`.
- [ ] Migration: add the three values to the `user_role` Postgres enum (downgrade recreates the type after deleting rows holding the new values — explicit-enum convention, see `0016_notifications.py`).
- [ ] Frontend: extend `Permissions`/`permissionsFor` in `src/auth/hooks.ts` (canReadVendors/canWriteVendors/canSubmitVendorRequest/canAssessVendors); `npm run generate:api` so the Users admin role picker offers the new roles.
- [ ] Tests: capability predicates, guard 403s, role assignment round-trip.

Branch `feature/com-<id>-vendor-roles`. Ref: ADR 0039, 0026.