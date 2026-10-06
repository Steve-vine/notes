---
id: 01M489XGQ5KGE8YC4BVMJ12VZ5
created: 2026-10-06T09:50:02.469626Z
updated: 2026-10-06T14:30:10.80015Z
type: task
title: A person's Primary role is remembered — it shows on the person, and a mover changes it by name, moving the account to the new primary's OU
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 848
sprint: sme8esk
blocked_by:
- 01M487HTNKSMDP8RADDHH5YZX7
comments:
- id: 01M48SYE9CHMEAAC1ZRNSFRYAE
  author: Steve Vine
  at: 2026-10-06T14:30:09.964696Z
  text: |-
    Done — PR #854, merged to main (04dbae9). Not yet on staging; goes with the rest of the sprint.

    What changed for people
    - Everyone who holds a role has one Primary role — the one that decides where their account lives. The rest are Additional roles: they add access and never move anyone.
    - The mover form opens on what the person holds today, as Primary role + Additional roles. Changing the primary reads as its own line ("Primary role: Finance Manager → Payroll Clerk") with where the account will go underneath. The old primary leaves unless "Keep … as an additional role" is ticked.
    - Only a change of primary moves an account, and only if it isn't already where the new primary says.
    - Nobody can be left holding several roles with no primary — the mover form and the role page both ask.
    - Role page: "Primary" badge beside the people it places, a "Primary role only" switch, and — taking a primary from somebody who keeps several roles — a "New primary role" choice. A role that is anyone's primary can't be deleted until they have another.
    - A person's details list their roles, primary first and marked.
    - Role matrix: a "Primary role not set" notice with a "See who" list, while anyone is without one.

    Existing people
    Given a primary where there is only one answer: the role their joiner request named (if still held) → their only role → the one role whose OU their account sits in. Anyone else is "not set"; nothing moves, the next mover for them chooses.
    Staging prediction (read-only count, 2026-10-06): 5 people hold roles, each exactly one → all 5 get a primary; nobody left "not set".

    Decisions I took (say if any is wrong)
    - A mover may leave the primary unsaid only when there is one possible answer (it's kept, or one role is left); otherwise it's refused and asks.
    - The mover form is pre-filled from what they hold — it used to open empty, which is how a role got dropped by accident.
    - If AD refuses the move, the request shows Failed with Retry, and the retry does move the account (the primary is only recorded as changed once the account has gone).
    - ADR 0089 records this; it supersedes the line in ADR 0083 that said an account stays where its first role put it.

    Not done here
    - The Users list has no business-roles column — a person's roles are on their details pop-up. Say if you want a column and I'll raise a task.

    Smoke test
    1. Requests ▸ New mover ▸ pick someone with a role: the form shows their Primary role and any Additional roles.
    2. Change the Primary role: the "Primary role: A → B" line and the "account moves to …" line appear; submit, approve, and check the account's OU in ADUC.
    3. Change only Additional roles: "The account stays where it is".
    4. Role page ▸ Holders: Primary badge and the "Primary role only" switch.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Decided with Steve, 2026-10-06: *"The Primary role should be remembered for the user — it makes up part of their identity; then if they become a mover, it's clear what is changing. Additional roles simply provide additional access; the primary role defines the OU."*

Follows COM-845 (the joiner form asks for a Primary role and Additional roles). COM-845 treated "primary" as something that only matters on the day someone joins; this task makes it a lasting fact about the person and **replaces that decision**.

## Why

Today nobody can say which of a person's roles is the one that places them. When a mover loses the role whose OU they sit in, Compass picks the destination from their remaining roles in an order no-one can see or control. A move between jobs should read as exactly that: *primary role: Sales Executive → Support Analyst*.

## What people see

### One rule

- **Everyone who holds a business role has exactly one Primary role.** Any others are Additional roles.
- **The Primary role decides the OU** the account lives in. **Additional roles only add access** — their groups and shared mailboxes — and never move anyone.

### On the person, and on a role

- Wherever a person's business roles are listed (the person's details, the Users screen), the primary is marked **Primary** and listed first.
- On a role's page, the list of people who hold it marks those for whom it is their **Primary** role, and can be narrowed to just them.

### Moving someone

The mover form shows the person as they are and as they will be, in the same two fields as the joiner form:

- **Primary role** — pre-filled with their current one. Change it to move them.
- **Additional roles** — pre-filled with their current ones. Add or remove freely.
- **Changing the primary:** the old primary role is **removed** unless the requester chooses to keep it as an additional role — the form says which, in words ("Sales Executive will be removed" / "kept as an additional role"). Under the new primary the form says where the account will go: "Moves to Staff › Support".
- **Changing only additional roles** changes access and nothing else; the form says the account stays where it is.
- The before-and-after summary on the form, on the request, and for the approver names the primary change on its own line, apart from the access changes.
- A person can't be left holding additional roles with no primary: removing the primary means naming another. Removing every role leaves them with none, and the account stays where it is.

### What happens to the account

- **Primary changed → the account moves to the new primary role's OU** (or the default OU on Admin ▸ Integrations ▸ Active Directory if that role names none). This happens wherever the account sits now, as long as Compass manages both the OU it's in and the OU it's going to.
- If either isn't one Compass manages, the account is **left where it is** and the request says so — the role change still goes through.
- Already in the right OU → nothing moves.
- Entra ID only: there is no OU; the primary is still recorded and shown.

### From a role's page

- **Add people** to a role: it becomes an **additional** role for each of them — unless the person holds no roles yet, in which case it becomes their primary.
- **Remove someone** from a role that is their primary: the prompt asks which of their remaining roles becomes the primary, and says the account will move. With no roles left, they simply hold none.
- **Deleting a role** that is anyone's primary is refused, listing who — they need a new primary first.

### People who already hold roles

Nobody has a primary recorded today. On the day this ships:

- A person with **one** role: that role is their primary.
- A person with several, where **exactly one** of those roles names the OU their account is in: that one.
- Anyone else: **Primary: not set**. Nothing moves and nothing breaks; the first mover request for them must choose one, and a screen on the role matrix lists who still needs one so they can be worked through.

## What changes from today

- Today a mover's account moves **only** if it sits in the OU of a role being removed, and the destination is picked from the remaining roles by an invisible order. From now on it moves **when, and only when, the primary role changes**, to that role's OU.
- Today a mover form is one list, "Roles after this change". It becomes Primary role + Additional roles.

## Decisions taken (say if any is wrong)

- **The old primary is removed by default** when the primary changes — a move between jobs usually means leaving the old one — with an explicit choice to keep it as additional.
- **The account follows the primary even if it was placed somewhere else by hand** (within the OUs Compass manages). "The primary role defines the OU" is the rule; a hand-placed account is brought back into line the next time its primary changes — not before, and never by a change to additional roles.
- **Setting a primary for the first time on someone already in the right OU moves nothing.**
- **A role that is someone's primary can't be deleted** until they have another.
- **Not in this task:** a mover's account details (department, job title, manager) are not rewritten from the new primary role's default values (COM-843). That would be the natural next step — say if it's wanted and it becomes a follow-on.
- **Not in this task:** a Primary-role column in access reports and recertification. Follow-on if wanted.

## Notes (technical)

- **ADR first.** This supersedes two sentences of ADR 0083 §6 — "Someone holding several roles stays in the OU of the role they joined with, and is moved only when that role is replaced" and "A move between roles with different OUs moves the account, but only when both OUs are managed" — and adds a concept (a remembered primary) the role model doesn't have (ADR 0045 §4). Write `decisions/NNNN-*.md` superseding those paragraphs; don't edit 0083.
- Storage: who holds what is `directory_user_business_roles` (`models/directory_user_business_role.py`, one row per person × role, unique on the pair, with the request that put it there). Add `is_primary` with a partial unique index — at most one primary row per (company, directory user). Holdings are written by `business_role_holdings.set_held_roles` (`core/business_role_holdings.py`), called from the joiner and mover paths in `tasks/access_execute.py`; it needs the primary passed in and must set it in the same transaction as the role set.
- Joiners: `_join_in_ad` / the Entra joiner record the subject's `primary_business_role_id` (COM-845) as the holding's primary. Joiners created between COM-845 and this task shipping are backfilled from that field on their request subject — more reliable than the inference below, so apply it first.
- Backfill (migration, in order): (1) from joiner request subjects' `primary_business_role_id`; (2) single-role holders; (3) holders whose `ad_dn` parent equals the `new_starter_ou` DN of exactly one held role; (4) leave the rest with no primary. CI migrates a fresh DB only — run this against a copy of staging and record the counts per rule in the PR. Revision id ≤ 32 chars.
- Mover API: the mover subject already carries the full resulting role set (`business_role_ids`, or the delta form `add_business_role_ids` / `remove_business_role_ids`, COM-534 — `models/access_request.py:371-388`). Add `primary_business_role_id` to the mover subject, required when the resulting set is non-empty, must be in the resulting set. Record the person's primary **when raised** alongside `held_business_role_ids`, so the request can show the change after the fact.
- Mover execution: replace `_move_to_new_role_ou` (`access_execute.py:1401`) — no more "sits in a lost role's OU" test, no id-sorted `new_starter_ou` walk. If the primary changed: target = that role's OU else the setup default (the single-role function COM-845 adds); move when `innermost_managed_ou` covers both the account's current parent and the target; otherwise leave it and note which side isn't managed. Route from configuration, never health; a write-time refusal is Failed + Retry (the sprint's "can't do it" rule). The multi-role `new_starter_ou` walk then has no callers — delete it.
- Changes made by hand in AD (an account dragged to another OU, detected by the AD read) do **not** change the recorded primary — the primary is Compass's statement of intent, the DN is where the account is.
- Mover form: `MoverDiff` in `RaiseRequestModal.tsx:701` ("Roles after this change", `:772`) → the same Primary / Additional pair as the joiner block; share the component with COM-845. `EmptyMoverConfirm` (`:642`) still covers "remove everything". The "Moves to …" line reuses COM-845's per-role resolved-OU data.
- Role page: `Holders`, `AddHoldersModal`, `RemoveHolderModal`, `DeleteRoleModal` in `RoleDetailPage.tsx` (these raise mover requests — the notice is `useRaisedNotice`); `ImpactList` should show a primary change and the resulting move. Person: `UserDetailModal.tsx`, and the roles shown on `UsersPage.tsx`.
- Coverage proposals and anything else that writes holdings (`business_role_holdings`) must keep the invariant: a non-empty set has exactly one primary. Proposals that add a role add it as additional; one that would remove a primary must be raised as a mover naming a new one, not applied silently.
- "Who still needs a primary" is a filter over holders with roles and no primary row — on the Role matrix, guarded like the matrix.
- API change → regenerate `schema.d.ts`, run the drift script.

## Done when

- A person's primary role is recorded at joining, shown on the person and on the role's list of holders.
- A mover request shows and edits Primary and Additional roles; changing the primary moves the account to the new primary's OU (when both OUs are managed) and says so; changing additional roles never moves it.
- Add / remove from a role's page keeps exactly one primary per person; a role that is anyone's primary can't be deleted.
- Existing holders are backfilled by the rules above; the rest read "not set" and are listed.
- The ADR is written.
- Tests: the invariant (one primary per non-empty set) through joiner, mover, role-page add/remove, role delete and coverage paths; mover execution for primary changed / unchanged / target unmanaged / current OU unmanaged / already there / hand-placed account; the backfill rules in order; the mover form and the request's before-and-after.
- Smoke-tested on staging: move someone's primary between two roles with different managed OUs and check the account in ADUC; then add and remove an additional role and check it didn't move.