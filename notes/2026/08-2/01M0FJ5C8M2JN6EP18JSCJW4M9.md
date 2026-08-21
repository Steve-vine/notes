---
id: 01M0FJ5C8M2JN6EP18JSCJW4M9
created: 2026-08-20T12:26:02.388217Z
updated: 2026-08-21T22:50:13.825306Z
type: task
title: Recert schedule owners can't include anyone who has never signed in — and the "provision via Entra assignment" warning tells them to do the wrong thing
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 317
sprint: s5gwx0s
assignee: steve
label:
- bug
- follow_up
priority: medium
task_status: active
---
## Finding (smoke test, staging, 2026-08-20)

Creating a recert schedule for group **compass-test-5** whose Entra owner is `S.Vine@moneypenny.co.uk` (test account) shows the yellow warning **"Not Compass users (provision via Entra assignment first): S Vine (S.Vine@moneypenny.co.uk)"** — and the owner can't be selected. Steve then did exactly what the message says (added the account to the Compass Admin Entra group) and it changed nothing.

## Mechanism

Three layers, all working as coded:

1. **Schedule owners must be Compass `users` rows.** The form's owner picker is fed by `useUserDirectory()` (Compass users only), and `RecertScheduleOwner.user_id` FKs `users.id`. The owner-defaults endpoint (`access_recert.py` `owner_defaults()`) resolves the group's Entra owners via `_match_compass_user()` (case-insensitive UPN/mail vs `users.email` — casing is *not* the issue) and reports non-matches in `unresolved`.
2. **Compass user rows for Entra accounts are created only by role-gated JIT at first SSO sign-in** (`auth_sso.py` `_jit_create`, ADR 0046 amendment). Group membership alone never creates an account — so "provision via Entra assignment first" is misleading: the assignment is necessary but not sufficient; the person must also **sign in to Compass once** before they can be a schedule owner.
3. **Two extra traps on the sign-in path**: `derived_roles_for()` reads the *mirror* (`directory_group_members`), so the directory sync must run after the Entra add before a first sign-in derives roles; and it reads **direct** memberships only, so membership via a nested group derives nothing (same root cause as COM-300).

## Why this matters beyond wording

ADR 0047 §2 deliberately supports portal-only `recertifier` accounts and assignment emails — the natural population of group owners is people who have *never* opened Compass. Requiring a prior sign-in from every schedule owner defeats the design.

## Fix options

- **A — pre-provision (recommended, matches ADR 0047 intent):** when a schedule is saved (or defaults accepted) with a directory person who has no Compass account, create the `users` row then (auth_provider `entra`, `entra_object_id` set, roles derived from the mirror — or `recertifier` as the floor when none derive). Their later first sign-in then resolves by object id as normal. Owner picker gains a directory-search mode for these people.
- **B — minimal:** keep the constraint, fix the warning to state the real precondition ("has never signed in to Compass — membership of a mapped group lets their first sign-in create the account") and link the sign-in/mapping docs.
- Either way: audit the joiner event (the JIT hand-written ActivityLog pattern in `auth_sso.py` applies if A creates rows outside a request actor's flush), and note the mirror-lag + nested-membership (COM-300) interactions in the warning.

## Refs
- `app/backend/src/compass_api/api/v1/access_recert.py` — `owner_defaults()` (~L969)
- `app/backend/src/compass_api/tasks/recert.py` — `_match_compass_user()` (L82)
- `app/backend/src/compass_api/api/v1/auth_sso.py` — `_jit_create()` / `_resolve_user()`
- `app/backend/src/compass_api/core/role_resolution.py` — `derived_roles_for()` (direct memberships only)
- `app/frontend/src/access/RecertPage.tsx` — unresolved alert (~L391), `userOptions` from `useUserDirectory()` (L222)
- ADR 0046 (role-gated JIT), ADR 0047 §2 (owners + recertifier role), COM-300 (nested membership)