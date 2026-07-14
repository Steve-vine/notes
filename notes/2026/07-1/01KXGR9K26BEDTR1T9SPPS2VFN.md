---
id: 01KXGR9K26BEDTR1T9SPPS2VFN
created: 2026-07-14T16:45:20.838941431Z
updated: 2026-07-14T16:45:20.838941431Z
type: task
title: 'Auth: local accounts, sessions, roles, API tokens'
label: brief
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 7
---
Build authentication and the role model per ADR 0007.

- [ ] User model with `auth_provider` field (default `local`), argon2id password hashing
- [ ] Server-side sessions in Redis; HttpOnly/SameSite cookies
- [ ] `get_current_user` dependency (handlers never touch the login mechanism)
- [ ] Roles: admin / editor / viewer enforced in the API layer
- [ ] Login / logout / password reset flows
- [ ] Per-user, hashed, revocable API tokens

Depends on: Database foundation. Refs: ADR 0007.

---
*Migrated from Linear [DEV-393](https://linear.app/stevevine/issue/DEV-393/auth-local-accounts-sessions-roles-api-tokens) · created 2026-06-13 · completed 2026-06-14*  
*Related to (Linear): DEV-394, DEV-416, DEV-406, DEV-392, DEV-391*