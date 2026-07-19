---
id: 01KXGR9K26BEDTR1T9SPPS2VFN
created: 2026-07-14T16:45:20.838941431Z
updated: 2026-07-14T21:36:59.737505Z
type: task
title: 'Auth: local accounts, sessions, roles, API tokens'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 7
sprint: s7hkfxa
comments:
- id: 01KXGRA2104HHPDA58JCHMJNTD
  author: Steve Vine
  at: 2026-07-14T16:45:36.160539555Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-14 10:43 UTC]
    **Done building — moving to In Review.** PR: https://github.com/Steve-vine/compass/pull/6 (all 5 CI checks green; `backend` runs auth + db integration against PG + Redis)

    ## What was done
    - **Models**: `User` (argon2id `password_hash`, `auth_provider`, role admin/editor/viewer, status) + `ApiToken` (hashed, revocable); migration `0002` (reversible — drops enum types on downgrade).
    - **`ActorMixin`** `created_by`/`updated_by` → FK `users` (closes the DEV-392 deferral).
    - **`core/security.py`** (argon2id + token hashing), **`core/sessions.py`** (Redis sessions, `SESSION_REDIS_URL`), **`core/auth.py`** (`get_current_user` via cookie *or* bearer token; `require_role`).
    - **API**: `/api/v1/auth` (login/logout/me/change-password, HttpOnly cookie) + `/api/v1/tokens` (create→plaintext once / list / revoke).
    - **`main.py`** registers a `session_store` readiness check on `/readyz`.
    - **`cli.py`** `create-admin` to bootstrap the first account.
    - **Chart**: `SESSION_REDIS_URL` through Secret + ESO + all values overlays; `.env.example` updated.

    ## Decisions on the fly
    - **Self-service password flows only** (your call) — login/logout/me/change-password.
    - **`ActorMixin` FK is `ondelete=SET NULL`** (don't delete history when a user is removed); `ApiToken.user_id` is `CASCADE`.
    - **`SESSION_REDIS_URL` as a first-class secret** (Valkey db 2), wired through the chart like `BROKER_URL`, rather than overloading the broker URL.
    - **ruff**: exempted FastAPI `Depends()`/`Query()`/… in argument defaults from bugbear B008 (the idiomatic FastAPI pattern).

    ## Verification
    - Local unit + integration (real PG + Redis): login/session/logout, change-password, token auth + revocation, role 403, migration up *and* down — all green. Manual `create-admin` + `/readyz` shows `database: ok` **and** `session_store: ok`; login→/me confirmed. `helm template` renders the new secret in k3s + prod.

    ## Acceptance criteria
    - [x] User model with `auth_provider` (default `local`), argon2id hashing
    - [x] Server-side Redis sessions; HttpOnly/SameSite cookies
    - [x] `get_current_user` dependency (handlers never touch the mechanism)
    - [x] Roles admin/editor/viewer enforced in the API
    - [x] Login / logout / **self-service** password change (email-based reset deferred — follow-up to file)
    - [x] Per-user, hashed, revocable API tokens

    ## Follow-ups
    - **Email-based forgot-password** (needs a mailer) — I'll file a `follow-up` on merge.
    - Admin cross-user management → DEV-406. Celery broker readiness → DEV-416.
- id: 01KXGRA982JCF7K16J48A27KNT
  author: Steve Vine
  at: 2026-07-14T16:45:43.554520512Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-14 14:04 UTC]
    **Merged + verified — Done.** Squash-merged as `cb51d09` ([PR #6](https://github.com/Steve-vine/compass/pull/6)); post-merge `release.yml` rebuilt + pushed the image (incl. migration `0002`) — green.

    Email-based forgot-password tracked as follow-up **DEV-417**. Next: **DEV-394** (Company entity), which adopts the per-company FK pattern and the `ActorMixin` FK landed here.
assignee: steve
label:
- brief
priority: medium
task_status: done
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