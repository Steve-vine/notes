---
id: 01M0FJ5C8M2JN6EP18JSCJW4M9
created: 2026-08-20T12:26:02.388217Z
updated: 2026-08-21T23:13:37.656803Z
type: task
title: Recert schedule owners can't include anyone who has never signed in — and the "provision via Entra assignment" warning tells them to do the wrong thing
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 317
sprint: s5gwx0s
comments:
- id: 01M0K9KVGFRKWWAYSR5PAX9NP7
  author: Steve Vine
  at: 2026-08-21T23:13:37.295508Z
  text: |-
    Fixed — PR #337, merged to main. No migration. Took **option A** (pre-provision).

    Naming a directory person as a schedule owner now creates their Compass account at that moment, with a floor of `recertifier` when the mirror derives no roles — the same portal-only role ADR 0047 §6 already auto-grants an owner who holds nothing else, so it grants what being an owner grants and nothing wider. An account they already have is used as it stands: naming someone an owner is not a reason to re-derive their privilege.

    `core/role_resolution.provision_directory_user` is now the single definition of how a directory person becomes a Compass account outside a sign-in, and **COM-324's `provision_mapped_users` is rewritten on top of it** rather than keeping a second copy. It takes an `actor_id`: given one, the audit listener writes the joiner event, so the self-attribution hack the actorless paths need is not duplicated where there *is* an actor — your "audit the joiner event" point, answered by attributing it to whoever named them.

    `RecertScheduleOwnerIn` now takes `user_id` **or** `directory_user_id`, and owners are deduplicated *after* resolution — the same person named once by each spelling is one owner, not two.

    **The warning is fixed by shrinking what it covers.** `owner-defaults` returns directory owners as offerable owners; `unresolved` now means only someone who cannot be an owner at all (a disabled or vanished directory account, or a disabled Compass one), and reads "Cannot be a schedule owner: …". The old "provision via Entra assignment first" text is gone — it was both the wrong instruction and, for the population ADR 0047 §2 is about, the usual case.

    The form also states the consequence before you save rather than after: "Saving creates an account, with the portal Recertifier role, and their review arrives by email — no sign-in needed first. Any wider access still comes from their mapped groups at the next directory sync, and only from direct memberships (COM-300)." That is the mirror-lag and nested-membership note you asked for, put where it is acted on.

    ADR 0046 gains a third amendment. The gate is unchanged — membership of a mapped group still decides who can *use* Compass — but a named, audited human act is now also a way an account comes into being.

    Smoke-test: compass-test-5's owner `S.Vine@moneypenny.co.uk` should now be selectable from the prefill, and saving should create the account. The owner picker also searches the directory directly, so any Entra person can be named.
assignee: steve
label:
- bug
- follow_up
priority: medium
task_status: review
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