---
id: 01M3GVNNXR9Q2MHHT8VRM0A71K
created: 2026-09-27T07:18:33.656927Z
updated: 2026-09-27T08:26:51.432456Z
type: task
title: 'Access Control ▸ Admin: choose what is watched for unrequested changes — every kind of object, each one able to be switched off'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 771
sprint: ss8v7d0
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Requested by Steve, 2026-09-27.

Compass watches the directory for changes nobody requested through it, and raises each one on Validation. Some kinds of object are legitimately managed somewhere else. For example, Microsoft 365 groups are run by their team owners in Teams. For those, every change is noise.

On staging today: 2,456 membership items in the informational lane and 150 needing validation. Plus 65 group creations, 47 new accounts, 39 unprocessed leavers, 12 directory-role changes and 19 mailbox changes.

This task gives an administrator one place to say what is watched, with every kind of object on the list and every one able to be switched off.

## What people see

A new section on **Access Control ▸ Admin**, **"What Compass watches"**, beside *Extra fields*. It is a table: one row per kind of object, one switch per change that kind can have. A row's switch turns the whole row off or on.

| Kind of object | Changes that can be watched |
|---|---|
| **Accounts: members** | created · disabled or deleted without a leaver |
| **Accounts: guests** | created · disabled or deleted without a leaver |
| **Security groups** | created · deleted · member added · member removed |
| **Security groups that grant admin roles** | created · deleted · member added · member removed |
| **Dynamic security groups** | created · deleted · member added · member removed |
| **Microsoft 365 groups** | created · deleted · member added · member removed |
| **Dynamic Microsoft 365 groups** | created · deleted · member added · member removed |
| **Distribution lists** | created · deleted · member added · member removed |
| **Mail-enabled security groups** | created · deleted · member added · member removed |
| **Directory roles** | role assigned · role removed |
| **Shared mailboxes** | access granted · access removed |

- **Everything is on by default**, matching today's behaviour. Nothing changes until someone switches something off.
- **Switched off means not raised at all.** No item is raised in either lane. The ledger, the mirror and Compass's own writes are unaffected. Only the "nobody asked for this" item is suppressed.
- **Open items already raised** of a kind being switched off: the confirmation offers to close them as *"No longer watched — switched off by <name>"*, or leave them to be worked. The default is to leave them.
- **Two rows are risky to switch off:** *Security groups that grant admin roles* and *Directory roles*. The switch still works, but the confirmation spells out the risk: *"Compass will no longer tell anyone when someone gains administrator rights outside it."* A small warning pill stays on the row while it's off.
- **A managed group whose kind isn't watched.** If a business role maps a group of a kind that's switched off, the role editor says so on that group: *"Changes made outside Compass to this group aren't watched."* Off doesn't silently weaken what Compass governs.
- **Who can change it:** holders of *Explain or reverse an unrequested change* (`access.review_unrequested`), the people who own the queue. Everyone who can open the Admin tab sees the table read-only.
- **Every change is recorded** in the activity log: who, when, and what was switched.

## Out of scope

- Per-group or per-company exceptions (e.g. "watch every M365 group except these"). That's a later layer if needed.
- Watching kinds Compass doesn't detect today: device and contact memberships, groups nested in groups, and conditional access.

## Notes

- **Storage:** one small settings table (or a singleton row). Key = (object kind, change), value = on/off, with who and when. Seed nothing; a missing key means on.
- **Detection:** `_detect_unrequested`, `_detect_unprocessed_leavers`, `_detect_directory_role_changes` and `_detect_vanished_managed_groups` (`tasks/directory_sync.py`), and the mailbox watch (`tasks/mailbox_sync.py`), each ask one helper — `watched(kind, change)` — before `_add_item`. Classify a group by `group_type`, `membership_type` and `is_assignable_to_role`, and an account by `user_type`.
- **Carries an ADR:** amends ADR 0061 §6 (detection watches every mirrored group): what is watched becomes configuration, defaulting to everything, and the ledger stays complete regardless.
- Keep the list complete by construction: build the table from the same classification detection uses, and add a test that fails if a new `UnrequestedChangeKind` or `DirectoryGroupType` value has no row.

**Done when:** switching off *Microsoft 365 groups ▸ member added* stops new items for M365 membership adds on the next sync, while other kinds still raise. Switching off a risky row needs its confirmation, and the change is in the activity log. The completeness test is in place.