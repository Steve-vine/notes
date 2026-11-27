---
id: 01M8EH2ASNF383C49AEJW51EP9
created: 2026-11-27T12:53:14.165899Z
updated: 2026-11-27T15:43:14.433564Z
type: task
title: At recertification, mailbox access held through a group is removed the way the reviewer chooses — take them out of the group, or take the group's access away
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2186
sprint: smq8t5s
blocked_by:
- 01M8EED1JWZH5K8NNQBTA6ZDGZ
assignee: steve
label:
- feature
priority: medium
task_status: active
---
**On the chain** (migration for the reviewer's choice on a review row; API). Builds on COM-2178 (refusals become to-dos).

Steve's decision (27 Nov 2026): close the last judgement gap in recertification. Today, when a reviewer flags someone who opens or sends as a shared mailbox **because a group they're in has that access**, the row reads "Compass cannot remove access held through a group — an access admin will". An admin then has to decide what to do and do it by hand.

## What people see
- **Choosing the removal:** flagging a row whose access comes through a group asks the reviewer to choose one of two:
  - **Remove them from *Finance Team*.** Under it, what else that group gives them: "also takes away: 3 other groups' worth of access, Accounts mailbox (send as), Finance SharePoint…". If the group is one a business role gives them, it says so ("from role Finance — they'll be an exception without it").
  - **Take *Finance Team*'s access to this mailbox away.** Under it, how many people that affects: "12 people lose Full Access to Accounts".
- **No choice made:** a reviewer who doesn't choose leaves it to an access admin, as today. Their row says so.
- **Approval:** the choice goes into the review's removals request, and the approver sees it:
  - "C Forster — remove from Finance Team (mailbox Accounts, held through the group)"
  - "Finance Team — take away Full Access to Accounts (12 people)"
  - The usual approval rules apply. A group that grants an Entra role, or that AD protects, follows the privileged rules (Access Admin, or Access Privilege Approver when Compass makes it itself, COM-2181).
- **Carrying it out:**
  - **Removing from the group** is a group membership change, made by Compass in Entra or AD by the usual routing (a to-do where it can't, COM-2178).
  - **Taking the group's access away** is made by Compass through Exchange, as for direct mailbox access.
  - Either way the row closes when the next read shows the access gone.
- **Person-centred and group reviews** that show mailbox access through a group get the same choice.

## Notes (technical)
- **Rows:** `RecertInstanceItem` rows for shared-mailbox access with `group_names` / `holder_label` (`mailbox_row_may_be_by_hand` in `tasks/access_execute.py`, the note in `PortalRecertReviewPage.tsx` and the internal review page).
  - Add `removal_choice` (`remove_from_group` / `remove_group_access` / null) and the group chosen when there's more than one path. One row per path already exists; follow it.
- **Removals request:** `core/recert_requests.py` turns a choice into the matching change:
  - `member_removed` on the group for the person;
  - `mailbox_access_revoked` with the group as trustee, using Exchange `Remove-MailboxPermission` / `Remove-RecipientPermission` with the group's identity (`exchange_scripts/set_mailbox_access.ps1`).
  - Send on behalf through a group follows the COM-2174 routing.
- **"What else it takes away":** reuse the person's popup data (groups held through that group, mailbox and list rights through it). The count of affected people comes from the mirror's effective members.
- **Ledger:** stamp both kinds so neither comes back as an unrequested change.

**Done when:** on staging, in a shared-mailbox review with a holder through a group:
- the reviewer can choose either removal, and sees the side effect;
- the approver sees the choice;
- after approval, Compass makes it (or raises a to-do), and the row closes on the next read.

(Taking a group's access away on a real mailbox may need Couldn't check if no safe test mailbox exists.)