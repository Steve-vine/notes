---
id: 01M3EKW1410EHV5F7PWDD2QGYP
created: 2026-09-26T10:23:44.257383Z
updated: 2026-09-26T13:18:48.439034Z
type: task
title: 'A role can grant a distribution list or mail-enabled security group: joiners, movers and leavers follow'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 764
sprint: ss8v7d0
blocked_by:
- 01M3EKSWCQXD122FVEKD7Z3A66
- 01M3EED7B5TF8P33ER3ADC33H8
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Stacks on COM-762 (manual steps) and COM-755 (Compass holds Exchange Recipient Administrator and guards its own Exchange writes).

A business role maps security groups and shared mailboxes today. It can now also map **distribution lists** and **mail-enabled security groups**. "Sales gets the sales-team@ list." They behave exactly like a group: joiners get them, movers gain and lose them, leavers lose them, and an ad-hoc membership request can name one.

Compass already sees every list and who is in it. The 15-minute directory refresh reads them from Entra, external contacts included. So there's nothing new to mirror. What's new is that a role can map them and that Compass can write to them. Graph can't change a mail-enabled group's membership, so cloud lists are changed through the Exchange connection (ADR 0075). On-premises lists become manual steps (COM-762).

**Carries an ADR** (next free number). It widens ADR 0045 §3/§5's governable surface from "plain assigned security groups" to "assigned security, distribution and mail-enabled security groups". The last two are written through Exchange, and on-premises ones by hand. It states what stays out:
- Microsoft 365 groups
- dynamic groups
- role-assignable groups
- room lists

## What people see

- **Role editor.** The groups picker offers distribution lists and mail-enabled security groups beside security groups. Each carries a type pill (as on the Groups tab) and an **On-premises** pill where it applies. Nothing changes for security groups.
- **Requests.** A list shows in **Gaining / Losing** like any group, with the same outcome pills. A cloud list is **Applied** by Compass. An on-premises list is **Manual — in AD** and goes on the COM-762 to-do. The to-do's wording follows what it holds: "Add Sam Jones to 1 on-premises group and 2 lists".
- **Ad-hoc membership request.** The target picker offers lists. Today it refuses them as "not a security group".
- **The list's own page** (Groups tab ▸ a list) names the roles that grant it, like a group's page.
- **A role edit** brings its holders in line (ADR 0064) for lists too, and the preview counts them: "adds 3 people to Sales UK".

**The boundary is the same as for groups.** Compass writes only to a list that some active role maps. Anything else it sees and leaves alone. An attempt on an unmanaged list is refused and recorded as a per-subject outcome. The check is repeated at the write, not trusted from the approval (ADR 0045 §5). External contacts on a list are never touched. A role adds and removes people only.

## Out of scope

- Send-as or send-on-behalf on a list.
- Moderation, owners (ManagedBy) and delivery restrictions.
- Creating or deleting lists (the group create/delete requests stay security-only).

## Notes

- **Exchange write path.** `Add-/Remove-DistributionGroupMember -BypassSecurityGroupManagerCheck`, identity by `ExternalDirectoryObjectId`. It is called only from the JML execution task, keeping ADR 0045 §5's one-write-path property, which must stay grep-provable. Batch a person's list changes into the same Exchange session as their mailbox changes (one session per run, ~10–20 s to open).
- **Idempotency.** "Already a member" on add and "not a member" on remove are success, not failure.
- **The guard COM-755 adds** ("refuse unless `SharedMailbox`") gains a sibling for lists. Refuse unless `RecipientTypeDetails` is `MailUniversalDistributionGroup` or `MailUniversalSecurityGroup` and `IsDirSynced` is false. Check it against the mirror in the task *and* in the script, because the mirror can be stale. A dir-synced hit at the write turns into a manual line, not a failure.
- **Room lists.** These are distribution groups in Exchange, and possibly in Graph too. Keep them out of the picker; check how the mirror classifies one.
- **Mirror at the write.** Update `directory_group_members` when Compass writes, so the screen doesn't wait for the next refresh (as COM-739 did for mailboxes).
- **Callers.** `business_role_groups.mapping_refusal`, `DirectoryGroup.governable`, the membership-request refusals in `api/v1/access_requests.py`, `role_propagation` and `coverage_proposals` all read the one rule. Change the rule, not the callers.

**Done when:** on staging, a role mapped to one cloud list and one on-premises list, given to a joiner, adds the person to the cloud list through Exchange. The on-premises list goes on the to-do. A leaver removes both the same way. An ad-hoc request can add someone to a cloud list, and a list no role maps is refused.