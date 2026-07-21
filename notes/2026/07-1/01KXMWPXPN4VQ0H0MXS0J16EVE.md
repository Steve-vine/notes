---
id: 01KXMWPXPN4VQ0H0MXS0J16EVE
created: 2026-07-16T07:19:29.749841747Z
updated: 2026-07-21T16:23:10.621785Z
type: task
title: User management API
project: 01KX671DATY39VW6GWK3M2T3DN
number: 85
sprint: syqgx3z
label: null
task_status: done
---
There is a `User` table (`models.py:75`) but it's only an **EntraID mirror** — rows are written solely at login (`auth/router.py:28-59`), and there's **no admin API** to list or manage users. Add a users router under `/api/v1` to support user management and to feed issue assignment (ISE-87).

**Scope (proposed):**
- List users — id, email, name, roles, disabled, last_login_at. Admin-gated (`AdminUser`). This endpoint also provides the assignable-user list for issue assignment.
- Enable / disable a user (`disabled` flag already exists on the model).

**ADR flag — decide before building role editing:** ADR 0015 (Entra OIDC + break-glass) states roles and membership **live in EntraID** and ISE holds no primary credentials; roles are derived from Entra groups at login (`oidc.py:82`). Read + enable/disable is consistent with that. **Editing roles in-app would contradict 0015 and needs an ADR update/supersede.** Keep this task to read + disable unless we take that decision.