---
id: 01M1E5DCA3QFG01EBANV544GWN
created: 2026-09-01T09:39:40.483286Z
updated: 2026-09-01T10:46:14.903496Z
type: task
title: a portal role can be taken back, not only given
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 558
sprint: sz42uhw
assignee: steve
company: null
label:
- bug
priority: high
task_status: active
---
Found by Steve on staging, 2026-09-01, following COM-553 and COM-557: two local accounts hold Vendor Contact (Portal) and Vendor Approver (Portal), and there is no way to take either off them.

The Users screen refuses, correctly — those grants belong to the screen that owns the relationship. The problem is that for two of the three portal roles, **that screen does not exist**.

| Role | Granted by | Taken back by |
| --- | --- | --- |
| Vendor Approver (portal) | naming somebody an approver on an approval area | coming off every area's approver list — automatic, and logged |
| Vendor Contact (portal) | an Entra group mapping, or the Users screen before COM-549 closed it | **nothing** |
| Recertifier (portal) | provisioning a recertification assignee | **nothing** |

So Vendor Approver is fine — Steve's approver account can be fixed today by removing them from the approval area. Vendor Contact and Recertifier are one-way doors: once an account holds one, no screen in Compass will remove it. On staging that is two accounts today; it is every vendor contact and every recertifier ever provisioned from here on.

It also means an account can be stranded **outside**. An account holding nothing but portal roles lands on `/portal` and never sees internal Compass. Grant Vendor Contact to a colleague by accident — through a group mapping, which COM-557 shows takes no confirmation — and there is no undo: they are outside, and the only screen that could bring them back refuses to touch the role.

## What changes

Every portal grant needs an owner that can revoke as well as confer.

- **Vendor Contact** — give it the owning screen it never had. Nothing in the app grants it to an individual today: it arrives from a group mapping or from history. The vendor's contacts are the natural home, so portal access for a contact is granted and withdrawn there, the way an approver's is on the approval area.
- **Recertifier** — provisioning grants it and nothing releases it. The obvious rule is the same shape as the approver's: held while they have recertification assignments, released when the last one is done or withdrawn. Worth confirming that is what we want rather than a permanent grant — a recertifier who attests once a year would lose and regain it, and that may be right or may be noise.
- **The Users screen keeps its refusal but stops being a dead end.** A greyed-out portal pill should say where the grant comes from and link there, which is the same fix COM-557 asks for.

Whether the Users screen should be allowed to remove a portal role as a last resort is a fair question, and I would say no for Vendor Approver — it would leave somebody listed as an approver on an area without the role, out of step until the next edit resyncs it. The answer is an owning screen for each, not an override on this one.

## Implementation

- `approval_areas.py` `_sync_approver_roles` is the pattern to copy: reconcile "who is listed" against "who holds the role" on every edit, both directions, with a hand-written activity-log line (`user_roles` has a composite key, so the audit listener cannot see it).
- `access_recert.py:1018` grants `recertifier` as a floor on provisioning and never revokes.
- Nothing anywhere grants or revokes `vendor_user` on an account — the grep is empty outside the group-mapping path. That is the gap in one line.
- Staging repair: two accounts need the grants removed by hand once there is a screen that can do it.
