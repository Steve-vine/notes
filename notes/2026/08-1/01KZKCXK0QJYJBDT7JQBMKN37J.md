---
id: 01KZKCXK0QJYJBDT7JQBMKN37J
created: 2026-08-09T13:55:40.183965Z
updated: 2026-08-09T13:56:32.176655Z
type: task
title: Vendor Portal role + portal read API
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 192
sprint: sw3i5is
blocked_by:
- 01KZKCX3891CBRC8S0V33HC1DS
assignee: steve
priority: medium
task_status: todo
---
Backend half of the portal's read side: the new `vendor_portal` role and a dedicated, deliberately narrow read API for it. ADR 0040.

---

## Agreed work (planned with Claude, 2026-08-09)

**Scoping decisions (Steve):**
- A **dedicated `api/v1/portal.py`** gated on `require_portal_read`, *not* a widened `require_vendor_read`. Widening would hand portal users all ~20 vendor endpoints (assessments, risks, actions); a separate router keeps the surface explicit and reviewable.
- `vendor_portal` gets **only** the portal — deliberately absent from `_LIBRARY_READ`, `_COMPANY_READ` and `_VENDOR_READ` (the first role with no Library access; see ADR 0040).
- Portal detail scope excludes assessments, linked risks and review actions.

**Checklist:**
- [ ] `models/user.py` — `Role.vendor_portal` (underscored, name == value per the ADR 0039 amendment); `_PORTAL_READ = _VENDOR_READ | {vendor_portal}` (anyone who can read vendors can read the portal); `_VENDOR_SUBMIT` gains `vendor_portal`; `User.can_read_portal`. Module docstring updated.
- [ ] `core/auth.py` — `require_portal_read` via the existing `_require` factory.
- [ ] Migration **0050** — `ALTER TYPE user_role ADD VALUE IF NOT EXISTS 'vendor_portal'`; downgrade deletes grants and rebuilds the type under a temp name. Copy `0034_vendor_roles.py` verbatim (in-place `ADD VALUE`, never a fresh `sa.Enum`).
- [ ] `api/v1/portal.py` + router mount:
  - `GET /portal/vendors` (same state/status/criticality/flag/q filters as the register)
  - `GET /portal/vendors/{id}` (`VendorOut`, unchanged shape)
  - `GET /portal/vendors/{id}/engagements`
  - `GET /portal/vendors/{id}/certifications`
  - `GET /portal/vendors/{id}/reviews`
  - `GET /portal/vendors/{id}/revisions`
  - `GET /portal/requests` — scoped to `requested_by = me`
- [ ] **Reuse, don't re-derive**: extract the list-filter / `VendorOut` assembly / flag-join helpers currently inline in `api/v1/vendors.py` and call them from both routers.
- [ ] `GET /api/v1/companies` is already `get_current_user`-gated — confirm the portal company switcher needs no change.
- [ ] Tests: a `vendor_portal`-only user gets 200 on `/api/v1/portal/vendors` and 403 on `/api/v1/vendors`, `/api/v1/content`, `/api/v1/risks`, `/api/v1/activity`; existing vendor roles keep exactly what they had; company scoping honoured (404 cross-company); migration upgrade **and downgrade** cycle green.
- [ ] PR to main, merge branch to staging.
