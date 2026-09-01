---
id: 01M1BKB5HFFGHC8082QJRQ80K9
created: 2026-08-31T09:45:24.783148Z
updated: 2026-09-01T13:55:51.95533Z
type: task
title: Roles become combinations of permissions an admin can define, not bundles frozen in code
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 549
sprint: sz42uhw
blocked_by:
- 01M1BKBQ5NMRRJVYXQ78C96TQE
comments:
- id: 01M1BXNH4MSGV850V3NHPGB5JK
  author: Steve Vine
  at: 2026-08-31T12:45:50.09993Z
  text: |-
    Shipped 2026-08-31. PR #559, merged as 8fff166. ADR 0067. Deployed to staging and smoke-tested by Steve.

    The migration against staging's real data: alembic at 0160, 12 role definitions, 95 permission ticks, 23 grants preserved with zero orphaned, user_role enum dropped. Nobody's access changed — 8 vendor approvers, 5 vendor admins, 4 admins, 4 vendor contacts, 1 access manager, 1 access reviewer, all carried over.

    Rehearsed against a populated database before pushing — the branch CI never exercises, since it only ever migrates an empty one. That caught two real defects the test suite could not have: op.bulk_insert cannot bind sa.func.now() as a parameter, and the timestamp columns needed server_default=sa.text("now()"). The downgrade round-trips too, dropping grants that name a custom role, which it says it does.

    Decisions taken during the build that the task did not settle:

    - "Administrator" is now "holds every permission in the catalogue", not "holds a role called Admin". The ~10 is_admin sites are genuine overrides (revert an offboarded vendor, override a criticality, purge a vendor, read a joiner's one-time passwords) and none is a job anybody would define a role around. Defining it this way means a custom role with everything ticked is an administrator, so they cannot silently ignore custom roles — which was the task's worry about leaving them as-is.
    - Report-definition delete stayed on is_admin rather than the write permission this router is guarded by. Deleting is deliberately narrower than writing: a shared library where anyone who can write can delete anyone's work is one people stop putting work into.
    - The portal boundary rides on an is_portal flag on the role, not a hard-coded slug list, so it survives a rename. A portal role the account already holds passes through the Users screen rather than being refused — a vendor manager named as an approver picks up vendor_approver from the approval-area screen, and refusing the whole list because it is still there would make their roles uneditable from the moment they were named.
    - Admin's tabs are filtered by permission rather than one isAdmin gate. A role that only manages users has a Users tab to reach; gating the section on being an administrator would have made that grant unreachable — the API allowing a call the screen never offered.

    Scale, for the record: 175 files. 38 permissions, ~400 guard sites, ~150 frontend call sites. Backend 381 unit + 1532 integration green, frontend 961 green.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
The role list has grown a module at a time and no longer reads as one system: Vendor Admin and Access Admin have nothing in common, there is an Access Manager but no Vendor Manager, and nobody can tell from the outside what any of them actually permits. The fix is to let an administrator define a role as a set of permissions — Datadog's shape — with **Admin** simply being the role with everything ticked.

**Compass is already half of the way there**, which is what makes this affordable. Nothing in the app asks "is this person an Access Manager?"; permission checks ask capability questions — can write access, can expedite access, can govern privileged access, can assess vendors — thirteen of them, and 47 of the ~50 backend checks go through that layer. Roles are already named bundles of capabilities. What is missing is that the bundles are frozen as sets in one Python file instead of being data, and that there are only thirteen capabilities to bundle.

Builds the 34 permissions agreed in COM-550, grouped Playbook · Posture · Vendor Management · Access Control · Admin. That task settles the list, this one makes it real. Do them in that order so there is never an intermediate release carrying a half-granularity catalogue in its API.

## Decided (2026-08-31)

- **Permissions are global.** A role grants the same thing in every company; no per-company grants.
- **Admin is the only built-in role**, holding everything. Every other role is defined by an administrator. Admin cannot be edited into something that locks everyone out, nobody can drop their own last Admin grant, and the system refuses to be left with no Admin at all.
- **Today's roles migrate as ordinary editable roles**, not built-ins: each becomes a role definition holding exactly the permissions it has now, so nobody loses access on the day it lands. They can then be renamed, merged or deleted like anything else. Deleting a role in use says how many people it affects first.
- **Portal access stays a structural boundary.** Vendor contacts and recertifiers reach `/portal` and never the internal app, whatever any role says; their portal abilities sit outside the custom-role system and cannot be mixed into a custom role.
- **Write implies view within its area**, with a separate View permission per area for read-only roles. A role that can act on what it cannot see is unbuildable.

## What changes

- A permission catalogue and a role-definition table, seeded with COM-550's permissions.
- An administrator can create a role, tick its permissions, name it, and grant it.
- Entra group → role mappings point at role definitions, so a custom role can be granted by group membership like any other.
- The API tells the browser **what you may do, not who you are**. Today `auth/hooks.ts` re-implements the entire role→capability mapping in TypeScript — the same policy written twice, in two languages, kept in step by hand. That copy is deleted. The ~98 UI call sites asking `perms.canWriteAccess` change only where a permission has been split.

## What must not become a tick-box

Some rules are relationships between a person and a particular record, and no permission matrix expresses them: the approver cannot be the requester; a break-glass change cannot be validated by whoever made it; a request touching a role-assignable group needs an Access Admin's name on the approval. These stay as rules enforced on top of permissions. The hazard of a permissions screen is that it *looks* able to express them — someone ticks "Approve an access request" for everyone and assumes maker-checker is still handled. The screen must not imply otherwise.

## Implementation

- `models/user.py`: roles are a Postgres enum and the app is live, so grants move from `user_roles.role` (enum) to role-definition rows. Same for `sso_group_role_mappings`. Migration needs care against a populated database — the transformation branch is the one CI never exercises (see the migrations blind-spot note); rehearse it locally against real-shaped data.
- The `can_*` properties become a lookup against the granted definitions' permission sets. Where COM-550 splits a capability, the call sites it guarded split with it — `can_write_access` alone guards ten places in `access_requests.py` that are now six different permissions.
- Convert the ~20 places that check `is_admin` or a specific role directly. These bypass the capability layer and would silently ignore custom roles — they are why a half-done version is worse than none. Most become "manage …" permissions from the Admin group.
- `/me` returns the permission set; `auth/hooks.ts` reads it instead of deriving it. Regenerate `schema.d.ts`.
- New admin section for roles: list, create, edit, see who holds each, with the dangerous permissions marked as COM-550 describes.
- ~106 backend and ~46 frontend test files construct users by role. Most only care that the user can do the thing; expect a long tail of fixture edits rather than rewrites.
- **ADR** — supersedes the role model in ADR 0026 §5 and the per-module role decisions (0045 §9, 0049 §1, 0061 §5). Append a decision record; do not rewrite those.
