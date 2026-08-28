---
id: 01M101ZV5WGQGNVVR9TD1MS85F
created: 2026-08-26T22:10:29.180727Z
updated: 2026-08-28T00:13:21.403383Z
type: task
title: 'Access Admin: privileged groups become governable, behind a named gate'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 451
sprint: snq23hz
comments:
- id: 01M12VDHGXWP8Q4BEW68PY2WFB
  author: Steve Vine
  at: 2026-08-28T00:13:21.305177Z
  text: |-
    Done — merged to main as 3e3a32e (PR #467). Full CI green first time.

    **You can grant privileged access through Compass now, and only with an Access Admin's name on it.**

    **The gate.** A fourth role `access_admin` (`_ACCESS_PRIVILEGE = {admin, access_admin}`). A request needs one as its approver when it grants or removes a role-assignable group, or acts on an account holding a directory role. `core/privileged_access.py` answers that one question for the three places that ask it — approval, the response body, and the write — and it returns **reasons, not a boolean**: *"This change touches privileged access (grants Entra directory roles: Privileged Admins) — the approver must hold the Access Admin role."* A message with no subject is one that gets worked around.

    `AccessRequestOut` carries `privilege_reasons` and `privileged_approved`, so a reader knows before they try to approve.

    **Approver ≠ requester still binds on top**, tested — the gate says *which* second person, never that a second person is no longer needed.

    **Break-glass narrows only here**, as a new capability set rather than a narrowing of `_ACCESS_EXPEDITE`. Tested both ways: an engineer's privileged break-glass is refused, and the same engineer's ordinary break-glass still executes.

    **The matrix stays closed**, `business_roles.py` untouched, with a test.

    One thing worth flagging: `account_holds_privilege` also catches a case §5.4 never could — a directory role assigned **straight to a person**. That refusal predates the directory-role mirror (COM-444), so it only ever saw the group route.

    **How the §5 mitigations still bind** (as asked): one write path unchanged, no new Graph call sites. Maker-checker *strengthened* — privilege now needs a second person **and** a named role. Protected-object re-checks kept, with the two halves read from different places on purpose: whether a group grants directory roles is re-read from the mirror **at the write** (that flag can be turned on after an approval — there is a test for exactly that window); whether an Access Admin approved is read from the **request**, because it is a recorded fact about a decision, and re-deriving it from the approver's current roles would silently re-open or re-close an already-decided request when somebody's roles change. Protected accounts: a refusal became an approval, still a visible per-subject outcome. The full trail unchanged — `privileged_approved` sits on the audited row beside `decided_by`.

    Two tests were rewritten rather than patched, because their premise is what this reverses: `test_a_privileged_group_is_still_refused` and `test_privileged_account_is_refused`. The latter's replacement runs the leaver ADR 0045 blocked — the departing administrator — and asserts the account is disabled and its sessions revoked.

    Frontend: the role joins the picker and the SSO mapping vocabulary; the group picker now offers role-assignable groups labelled "— grants directory roles", with an orange alert once one is picked.
assignee: steve
company:
- moneypenny
label:
- feature
priority: high
task_status: review
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