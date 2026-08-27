---
id: 01M101ZV5WGQGNVVR9TD1MS85F
created: 2026-08-26T22:10:29.180727Z
updated: 2026-08-27T23:33:06.142852Z
type: task
title: 'Access Admin: privileged groups become governable, behind a named gate'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 451
sprint: snq23hz
assignee: steve
company:
- moneypenny
label:
- feature
priority: high
task_status: active
---
Stacks on COM-449/COM-450. Part 5 of COM-446 — and the part that reverses a decision ADR 0045 made deliberately, so it does not start before the ADR lands.

Groups that grant Entra directory roles are refused everywhere today: at matrix-mapping time and again at execution. That refusal is exactly why the only way to make somebody an administrator is to bypass Compass entirely — no approval, no ledger, and no detection afterwards.

## What changes for the reader

**You can grant privileged access through Compass, and only with an Access Admin's name on it.**

## Scope

**A fourth access role: `access_admin`.** Joins `access_manager`, `access_engineer` and `access_reviewer` in `models/user.py` — an add-only enum migration, in the read and write capability sets, and in the Admin ▸ Users role picker.

**The approval gate.** A request touching any role-assignable group needs an **Access Admin** as its approver. Not merely a second person — a second person holding this role. Approver ≠ requester still binds on top.

**Expedite narrows, but only here.** Only an Access Admin or an Admin may expedite a request that touches a privileged group. Access Engineers keep ordinary break-glass for everything else — out-of-hours infrastructure work is untouched. This is a new capability set, not a change to `_ACCESS_EXPEDITE`.

**The matrix stays closed.** Role-assignable groups remain refused at matrix-mapping time, permanently. A business role must never grant administrator rights as a side effect of a joiner — privilege is always an exception, always with a name against it. `business_roles.py:105` keeps its refusal exactly as written.

**Privileged accounts stop being refused.** ADR 0045 §5.4 refuses to act on anyone holding a directory role. Once privilege is governable that is inconsistent, and it blocks running a leaver against a departing administrator — the moment you most need one. It becomes an Access Admin approval instead of a refusal.

**Execution.** `_writable_group_ids` currently refuses on `is_assignable_to_role`. It now refuses unless the request carries an Access Admin approval, re-checked at execution time — the flag can change between approval and write, and the double gate is the point (ADR 0045 §5.3).

## Watch for

This widens what the app identity can do at write scope, which is the escalation path §5 exists to close. The mitigations must visibly still hold: one write path, maker-checker, the full trail. Say in the PR how each still binds.

## Tests

Integration tests: a privileged request approved by an access_manager is refused; by an access_admin, executes; expedited by an access_engineer, refused; a group turning role-assignable between approval and execution is refused at the write; matrix mapping still refuses; a leaver against a privileged account executes with Access Admin approval and is refused without.