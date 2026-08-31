---
id: 01M1BKB5HFFGHC8082QJRQ80K9
created: 2026-08-31T09:45:24.783148Z
updated: 2026-08-31T09:45:24.783148Z
type: task
title: Roles become combinations of permissions an admin can define, not bundles frozen in code
label: improvement
assignee: steve
priority: medium
task_status: backlog
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 549
company: null
---
The role list has grown a module at a time and no longer reads as one system: Vendor Admin and Access Admin have nothing in common, there is an Access Manager but no Vendor Manager, and nobody can tell from the outside what any of them actually permits. The fix is to let an administrator define a role as a set of permissions — Datadog's shape — with **Admin** simply being the role with everything ticked.

**Compass is already half of the way there**, which is what makes this affordable. Nothing in the app asks "is this person an Access Manager?"; permission checks ask capability questions — can write access, can expedite access, can govern privileged access, can assess vendors — thirteen of them, and 47 of the ~50 backend checks go through that layer. Roles are already named bundles of capabilities. What is missing is that the bundles are frozen as sets in one Python file instead of being data, and that there are only thirteen capabilities to bundle.

This task builds the mechanism at today's granularity, so nothing changes for anyone on the day it lands. Splitting the thirteen into the permissions people actually want is its own task.

**What changes**
- A permission catalogue and a role-definition table. Today's roles are seeded as built-in definitions with exactly the capabilities they have now — same behaviour, now data.
- An administrator can create a custom role, tick its permissions, name it, and grant it. Built-in definitions stay editable-with-care or locked, decided in the design; **Admin cannot be edited into something that locks everybody out**, and nobody can remove their own last administrative grant.
- Entra group → role mappings point at role definitions, so a custom role can be granted by group membership like any other.
- The API tells the browser **what you may do, not who you are**. Today `auth/hooks.ts` re-implements the entire role→capability mapping in TypeScript — the same policy written twice, in two languages, kept in step by hand. That copy is deleted. The ~98 UI call sites asking `perms.canWriteAccess` don't change if the names hold.

**What must not become a tick-box** — some rules are relationships between a person and a particular record, and no permission matrix expresses them: the approver cannot be the requester; a break-glass change cannot be validated by whoever made it; a request touching a role-assignable group needs an Access Admin's name on the approval. These stay as rules enforced on top of permissions. The hazard of a permissions screen is that it *looks* able to express them — someone ticks "Approve Request" for everyone and assumes maker-checker is still handled. Whatever the screen says, it should not imply otherwise.

**Implementation**
- `models/user.py`: roles are a Postgres enum and the app is live, so grants must move from `user_roles.role` (enum) to role-definition rows. Same for `sso_group_role_mappings`. Migration needs care against a populated database — the transformation branch is the one CI never exercises (see the migrations blind-spot note); rehearse it locally against real-shaped data.
- The thirteen `can_*` properties become a lookup against the granted definitions' permission sets. Call sites are untouched.
- Convert the ~20 remaining places that check `is_admin` or a specific role directly. These bypass the capability layer and would silently ignore custom roles — they are the reason a half-done version of this is worse than none.
- `/me` returns the permission set; `auth/hooks.ts` reads it instead of deriving it. Regenerate `schema.d.ts`.
- New admin section for role definitions: list, create, edit, see who holds each.
- ~106 backend and ~46 frontend test files construct users by role; most only care that the user can do the thing, so they ride the seeded built-ins. Expect a long tail of fixture edits rather than rewrites.
- **ADR** — this supersedes the role model in ADR 0026 §5 and the per-module role decisions (0045 §9, 0049 §1, 0061 §5). Append a decision record; do not rewrite those.
