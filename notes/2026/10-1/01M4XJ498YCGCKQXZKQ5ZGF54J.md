---
id: 01M4XJ498YCGCKQXZKQ5ZGF54J
created: 2026-10-14T15:57:35.902748Z
updated: 2026-10-14T15:57:35.902748Z
type: task
title: A role can grant send as or send on behalf on a list — joiners, movers and leavers follow
assignee: steve
priority: medium
label: feature
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 954
---
Part of the POC Tweaks sprint; stacks on COM-953 (the read). This is the main piece: Compass starts writing these rights.

## What people see

- **Role editor.** A list already mapped to a role can carry two more ticks beside *member*: **can send as** and **can send on behalf**. Each is its own grant, the way *can open* and *can send as* are on a shared mailbox. A right can be granted without membership ("the team leads can send as sales@, but aren't on it"). Security groups and Microsoft 365 groups don't offer the ticks.
- **Joiners** get the rights their roles grant. **Movers** gain and lose them as their roles change, and keep an exception that a request gave them. **Leavers** lose every right Compass manages, whatever gave it to them.
- **Requests.** The rights show in **Gaining / Losing** with the same outcome pills as list membership, worded "Sales UK — can send as".
  - **Applied**: Compass made the change.
  - **Manual**: a to-do on the Actions list, worded for where it has to be done: "Let Sam Jones send on behalf of Sales UK, in AD", or "… in on-premises Exchange" for the rare person whose mailbox is still on-premises.
- **A role edit** brings its holders in line (ADR 0064), and the preview counts these too: "gives 3 people send as on Sales UK".
- **The list's page** (COM-953) now says which role grants each sender, or *Exception*.
- **The boundary is the same as for membership.** Compass changes a right on a list only when some active role maps *that right on that list*. Senders nobody mapped are shown and left alone.

## Where each change goes (ADR 0105)

| | Cloud list | Synced from AD, in a managed OU | Synced from AD, outside one / no AD connection |
|---|---|---|---|
| **Send as** | Exchange | Exchange* | Exchange* |
| **Send on behalf** | Exchange | Compass writes it in AD | To-do |

\* If Exchange refuses send as on a synced list, that change becomes a to-do and the subject doesn't fail. **This staging run is the first real answer to ADR 0105's open fact. Record it here and on the ADR task.**

## Notes (technical)

- **Role mapping.** A new `business_role_list_rights` table (role, group, kind), audited row by row like `business_role_mailboxes`. The mapping rule is the list's (ADR 0080 §1: governable, in the mirror, not vanished). Next migration after COM-953's.
- **Requests.** Carry them on the subject beside the mailbox grants (`join_list_rights` / `leave_list_rights`, or generalise the mailbox columns if it's cleaner). The ledger gains `list_right_granted` / `list_right_revoked`, naming the list and kind.
- **Derivation.** `governed_list_rights`, keyed (person, list, kind): role-derived › exception › unattributed (ADR 0076 §4). The hourly pass re-derives; the write stamps it.
- **Exchange write.** Extend `set_list_membership.ps1` or add `set_list_rights.ps1`, called from `tasks/access_execute.py` only, in the **same session** as the person's list-membership and mailbox changes.
  - Send as: `Add-/Remove-RecipientPermission -AccessRights SendAs -Confirm:$false`.
  - Send on behalf (cloud lists only): `Set-DistributionGroup -GrantSendOnBehalfTo @{Add=…}/@{Remove=…} -BypassSecurityGroupManagerCheck`.
  - The script re-checks the recipient type at the write (ADR 0080 §3), **except** the "not synced" test for send as. It reports a synced-object refusal as `manual`, not `failed`.
  - It also checks the trustee's `RecipientTypeDetails`; a `MailUser` (mailbox on-premises) is reported as `manual_onprem_exchange`.
  - Already granted / not there counts as done.
- **AD write.** `ad_writer.add_public_delegate` / `remove_public_delegate`: `MODIFY_ADD`/`MODIFY_DELETE` on `publicDelegates` with the user's DN, idempotent like `add_member`. Managed-OU check as for membership (ADR 0083 §3).
- **To-dos.** Through the ADR 0079 mechanism, confirmed by observation (the next read, COM-953) and never by a tick. Extend the to-do's wording builder for the new kinds.
- **One rule, all callers.** Mapping refusal, propagation, coverage proposals and the leaver path all read one "is this (list, kind) managed" helper; don't re-derive it in each caller.
- **Tests.** FakeExchange for grant/revoke/idempotent/synced-refusal-to-manual; AD writer against the Samba test DC (integration); a leaver removing an unmapped-but-managed right; a mover keeping an exception; the propagation preview.

**Done when:** on staging, a role mapping *send as* on one cloud list and *send on behalf* on one on-premises list, given to a joiner, grants send as through Exchange and either writes the on-behalf in AD (managed OU) or raises the to-do. The list's page shows both, attributed to the role, after the next read. A leaver for the same person removes both the same way. Also on staging: send as on one synced list, with Exchange's answer recorded.