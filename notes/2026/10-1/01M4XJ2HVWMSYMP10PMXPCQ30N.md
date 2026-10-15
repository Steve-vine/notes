---
id: 01M4XJ2HVWMSYMP10PMXPCQ30N
created: 2026-10-14T15:56:39.164927Z
updated: 2026-10-15T14:45:56.356523Z
type: task
title: 'ADR: who can send as or send on behalf of a list is governed like shared-mailbox access'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 952
sprint: s192kdq
comments:
- id: 01M4XKGZ157S463VAC88HG1CWR
  author: Steve Vine
  at: 2026-10-14T16:21:59.973165Z
  text: |-
    Done — PR #946, merged to main. **ADR 0106**, not 0105: 0105 went to membership rules (COM-946) first. The other four tasks say 0105 in their text; read that as 0106.

    What it decides, in short:
    - **Send as** and **send on behalf** on a list are governed the same way as shared-mailbox access. A role maps the right; Compass writes only rights some role maps; leavers lose them; why a person holds one is worked out the same way. People only, never groups. A right can be given without list membership.
    - **Send as** goes through Exchange Online for every list, including ones synced from AD.
    - **Send on behalf** goes where the list lives: Exchange for a cloud list, AD for an on-premises list in a managed OU, otherwise a to-do.
    - **Exchange's answer at the moment of writing decides.** If Exchange won't write a right because the list is mastered on-premises, the change becomes a to-do, not a failure. A person whose mailbox is on-premises also gets a to-do.
    - **AD only:** send on behalf is written in AD; send as is a to-do.
    - Membership rules (ADR 0105) don't apply to list rights.

    Still open, and stated in the ADR: whether Exchange accepts send as on a synced list. The rule is safe either way. The first real answer comes from COM-954's staging run.

    No setup change for Exchange or AD.
- id: 01M4XTA3PZVMDEZQN7K2XNJ9PS
  author: Steve Vine
  at: 2026-10-14T18:20:35.423577Z
  text: 'Evidence on the ADR''s open question, from staging''s first list read (2026-10-14 18:10): Exchange Online holds **745 send-as rights on 651 lists, 704 of them on lists synced from AD**. They''re real individual grants, all resolving to people. An AD-side send-as permission doesn''t sync up to Exchange Online, so these were set in Exchange Online on synced lists. That strongly suggests Exchange accepts send as on a synced list, as ADR 0106 assumed. It still isn''t proof that Compass''s own write is accepted; the joiner smoke test on COM-954 settles that.'
assignee: steve
label:
- brief
priority: medium
task_status: done
---
Part of the POC Tweaks sprint. Raised during the POC (Steve, 2026-10-14): a role should be able to give people **send as** and **send on behalf** on a distribution list. ADR 0080 left both out on purpose. This task writes the decision record that brings them in, and it gates the four tasks after it.

## What was decided (Steve, 2026-10-14)

- **Both rights**: *can send as* and *can send on behalf*. They are granted separately, the way *can open* and *can send as* are on a shared mailbox.
- **People only.** Neither right is granted to a group.
- **Lists and mail-enabled security groups**, the same governable surface as ADR 0080 §1. Microsoft 365 groups, dynamic groups and room lists stay out.
- **Someone whose mailbox is on an on-premises Exchange server** shouldn't exist. If one turns up, their change is a to-do (ADR 0079), not something Compass builds for.
- **Still out:** moderation, owners (ManagedBy) and delivery restrictions.

## What the ADR has to say

- **The same machinery as ADR 0076, one object kind over.** A role maps (list, right). A right is managed when some active role maps it, and Compass writes only managed rights. Why someone holds a right is derived as role-derived › exception › unattributed. A role edit brings its holders in line (ADR 0064). Leavers lose every managed right they hold.
- **Where each right lives, and so who writes it.** This is the part with no precedent:
  - **Send as** is an Exchange Online permission on the recipient (Add-/Remove-RecipientPermission). It is expected to be owned by the cloud even for a list synced from AD, so Compass writes it through Exchange for cloud *and* synced lists. ADR 0080 §3's "not synced from AD" check deliberately does **not** apply to this right. **Fallback:** if Exchange refuses it on a synced list, that change becomes a to-do (not a failure) and the mirror is untouched. The rule is safe whichever way Exchange answers; only the number of to-dos differs.
  - **Send on behalf** is the list's `publicDelegates` attribute. It is mastered wherever the list is: Exchange `GrantSendOnBehalfTo` for a cloud list, and AD for an on-premises one (synced up by Entra Connect). An on-premises list inside a managed OU is written by Compass in AD (ADR 0083 §3). Anywhere else (outside the managed OUs, or no AD connection in this setup) it is a to-do.
  - **A trustee whose mailbox is on-premises** (Exchange reports them as a mail user, not a mailbox): the cloud send-as grant does them no good, so their change is a to-do worded for on-premises Exchange.
  - **AD only** (ADR 0083, no Exchange Online): send on behalf is written in AD. Send as is a to-do, because it is an ACL on the AD object and Compass doesn't write ACLs.
- **The one write path holds.** Every change goes through the execution task, which is still grep-provably the only writer. A person's list rights join their mailbox and list-membership changes in the same Exchange session.
- **Amends ADR 0080 §Consequences** ("send-as, send-on-behalf … are not managed"), and amends the ADR 0076 mirror note that send-on-behalf is never managed. That note stays true for **mailboxes**.

## Notes (technical)

- Next free ADR number is **0105**.
- **Open fact:** does Exchange Online accept `Add-RecipientPermission -AccessRights SendAs` on a **dir-synced** list? Expected yes; it is unverified. Don't test it by writing to the staging tenant by hand. The fallback above makes the design safe whichever way it goes, and the first real answer comes from the staging smoke test of the roles task. If it turns out *no*, most of the estate's send-as becomes to-dos. Tell Steve then; it's his call whether AD-ACL writing is worth building.
- `Set-DistributionGroup -GrantSendOnBehalfTo` on a synced list is expected to be refused. The routing never sends it there, but the script treats that refusal as a to-do too, in case the mirror is stale.
- Exchange Recipient Administrator (ADR 0078) covers both cmdlets, so no setup change is needed. Say so in the Consequences.

**Done when:** ADR 0105 is merged.