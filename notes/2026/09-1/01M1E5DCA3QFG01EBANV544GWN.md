---
id: 01M1E5DCA3QFG01EBANV544GWN
created: 2026-09-01T09:39:40.483286Z
updated: 2026-09-01T11:16:51.694557Z
type: task
title: a portal role can be taken back, not only given
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 558
sprint: sz42uhw
comments:
- id: 01M1EAZAKPFBB6G2H60914105M
  author: Steve Vine
  at: 2026-09-01T11:16:51.446206Z
  text: |-
    Done — PR #567, merged to main (0e66f09), CI green including the full backend integration suite.

    **Vendor Contact: this screen owns it** (your decision, and migration 0163 clears its `granted_by`).

    Worth recording why the task's proposal changed. The note suggested the vendor's contacts card as its home; that premise does not hold:

    - `vendor_contacts` rows are names and phone numbers with **no link to a Compass account**, and the portal's vendor surface is keyed on vendor *ownership*, not on that card.
    - ADR 0049 §1 grants `vendor_user` to **most staff** — "kitchen assistants, cleaners and the like have no business in the register". It is the door somebody comes in by, not a fact about one vendor, so no relationship screen could own it.
    - A group mapping is a route, not an owner: the derived-role recompute only touches `auth_provider = 'entra'`, so a mapping can never take the grant off a **local** account — which all three stuck accounts are.

    So NULL `granted_by` means what it says, `_validated_roles` refuses only a portal role another screen owns (and names that screen), and the picker greys only those. The refusal and the grey now agree, and neither is a dead end.

    **Recertifier: released** (your decision). `_apply_owners` granted it inline and nothing ever gave it back. Both directions run through the new `core/portal_role_sync.py` — the `_sync_approver_roles` shape, reconciled on schedule create/update, on schedule delete, and on the instance completion that ends the work, with the hand-written activity-log line `user_roles`' composite key denies the audit listener. `has_recertification_work` asks about open **instances** as well as live schedules, so nobody loses the grant mid-attestation.

    Vendor Approver is deliberately unchanged — the approval area already reconciles it both ways, and letting this screen remove it would leave somebody listed as an approver without the role, exactly as you said.

    **Staging repair, once deployed:** the two Vendor Contact grants come off from Admin → Users. The Vendor Approver one comes off by removing that account from the approval area, which already worked.
assignee: steve
company: null
label:
- bug
priority: high
task_status: review
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
