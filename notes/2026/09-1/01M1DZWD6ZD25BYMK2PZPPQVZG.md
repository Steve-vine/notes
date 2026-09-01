---
id: 01M1DZWD6ZD25BYMK2PZPPQVZG
created: 2026-09-01T08:03:01.471385Z
updated: 2026-09-01T08:03:01.471385Z
type: task
title: an approver's roles can be edited again — a portal role they already hold freezes the whole list
priority: high
task_status: todo
label: bug
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 553
company: null
---
Found by Steve on staging, 2026-09-01, testing user administration.

**Symptom.** On Admin → Users, adding or removing a role for a local user does nothing and raises a red "Something went wrong". Three different accounts tried; every attempt answered 422.

**What is actually happening.** The Users screen refuses to save any role list containing a portal role — including one the account already holds and did not ask for. Most internal accounts hold one: naming somebody an approver on an approval area grants them `vendor_approver`, which is a portal role, and provisioning a vendor contact or a recertifier does the same. From the moment that grant appears, that person's roles cannot be edited at all.

That is precisely the failure COM-549 said it had avoided — "a portal role the account already holds passes through the Users screen rather than being refused … refusing the whole list because it is still there would make their roles uneditable from the moment they were named". The exemption was written and never wired up.

**Scale.** Staging carries 8 vendor approvers, 4 vendor contacts and 5 vendor admins among 23 grants. Every one of those accounts is currently read-only on the Users screen.

## Fix

- `api/v1/users.py` — `_validated_roles(db, slugs, held=None)` implements and documents the exemption; neither caller passes `held`, so the check collapses to "refuse any portal role". `update_user` should pass `held=set(user.roles)`. `create_user` is correct as it stands: a brand-new account may not be handed one.
- While in there, settle the other half of the same rule: can the browser *remove* a held portal grant? The picker offers portal roles as disabled options, so today the pill should stay put — but if it can be taken out by hand, the save succeeds and quietly revokes somebody's approver status, which is the mirror-image defect. Whichever way, the grant must only be changed from the screen that owns it (approval areas, vendor contacts, recertification).

## Why CI is green

Nothing constructs a **local** account holding a portal role. `test_users.py` covers viewer → analyst+assessor; `test_sso_mappings.py` covers a local account holding only `viewer`. Add:

- an internal local account holding `vendor_approver` can have a role added, and removed, with the `vendor_approver` grant surviving both;
- adding a portal role the account does **not** hold is still refused, with the message it has now.

## Related

The toast Steve saw is a second defect and has its own task — the server sent a clear sentence and the browser replaced it with "Something went wrong", which is why this took a log dive to identify rather than a screenshot.
