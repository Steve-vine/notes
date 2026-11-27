---
id: 01M8EH2ASNF383C49AEJW51EP9
created: 2026-11-27T12:53:14.165899Z
updated: 2026-11-27T18:44:03.453573Z
type: task
title: At recertification, mailbox access held through a group is removed the way the reviewer chooses — take them out of the group, or take the group's access away
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2186
sprint: smq8t5s
blocked_by:
- 01M8EED1JWZH5K8NNQBTA6ZDGZ
comments:
- id: 01M8F54P3TZMCS88MPQC6QB1G9
  author: Steve Vine
  at: 2026-11-27T18:44:02.810081Z
  text: |-
    Done — merged to main in PR #2193. Not on staging yet; it goes with the sprint.

    What changes:
    - When a reviewer flags someone whose shared-mailbox access comes through a group, they choose how it goes, under "How should it go?":
      - "Remove them from Finance Team". Under it: what else that takes away (other groups, mailbox and list rights, apps, directory roles — only what nothing else still gives them), or "Takes nothing else away". Where a role gives them the group: "From role Finance — they'll be an exception without it".
      - "Take Finance Team's access to this mailbox away", e.g. "12 people lose Full Access to Accounts".
      - "Leave it to an access admin". This is the default; the row reads "No removal chosen — an access admin will decide how it goes".
    - The review's removals request shows the choice to the approver, marked "As the reviewer chose". The usual approval rules apply.
      - Taking someone out of a group that grants an Entra role, or one AD protects, needs an Access Privilege Approver.
      - Taking a group's access away, or leaving it to an admin, doesn't.
    - Compass carries out either choice:
      - Removing from the group is a normal membership change (Entra or AD, a to-do where Compass can't).
      - Taking the group's access away goes through Exchange; send on behalf follows COM-2174's routing.
      - Both are recorded, so neither comes back as an unrequested change. Two rows choosing the same group's access take it away once.
    - The internal review page shows each row's choice, read-only: owners flag in the portal.
    - Only shared-mailbox reviews offer the choice, since person-centred and group reviews don't show mailbox access.
    - Someone in the group only through a nested group: "Remove them from…" names their group inside the trustee group, one option per path.

    For Steve to check:
    - Wording, approver view: "remove from Finance Team (mailbox Accounts, held through the group)" and "Finance Team — take away Full Access to Accounts (12 people)". The flagged person stays in the Person column.
    - Taking a group's access away in Exchange passes the group itself. That hasn't been tried against real Exchange yet.
    - Before this change, a mailbox row reached through a role-granting or AD-protected group triggered the privileged rules even though Compass changed nothing. It now does so only when the reviewer chooses to remove the person from that group.
    - The evidence CSV has no column for the choice; it's in the row's history and the removal detail.

    Checks:
    - New integration tests cover the choices, approval and both ways of carrying them out.
    - Recert suites passed (55), and the unit suite passed.
    - Merging with this sprint's directory-role removals needed one combined change in the review-removal code, covered by those suites.
    - All CI jobs passed.
assignee: steve
label:
- feature
priority: medium
task_status: review
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