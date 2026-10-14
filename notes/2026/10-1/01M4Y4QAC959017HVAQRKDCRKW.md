---
id: 01M4Y4QAC959017HVAQRKDCRKW
created: 2026-10-14T21:22:33.993878Z
updated: 2026-10-14T21:58:48.962483Z
type: task
title: Setup says what list changes really need, in Exchange and in AD — and a missing AD right for send on behalf becomes a to-do, not a failure
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 969
sprint: s192kdq
comments:
- id: 01M4Y6HP900JPWNCPATW2YX28T
  author: Steve Vine
  at: 2026-10-14T21:54:26.719848Z
  text: |-
    Steve made the AD change (2026-10-14) as a Delegate Control on the domain root for `moneypenny.local\compass-ad`, through AD Users and Computers rather than a script. Send on behalf of CAF Team then applied on Retry. So the setup notes should give **the GUI steps**, not the dsacls block:
    1. Right-click the domain ▸ Delegate Control ▸ add the account ▸ common tasks: *Create, delete, and manage user accounts*, *Reset user passwords and force password change at next logon*, *Modify the membership of a group*.
    2. Delegate Control again ▸ custom task ▸ Group objects ▸ Property-specific ▸ **Write publicDelegates**.

    Steve considered built-in groups instead (Domain Admins too broad; Account Operators legacy and signs in to DCs) and chose the delegation.
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Found in the COM-954/958 smoke tests (Steve, 2026-10-14). Everything now works on staging except send on behalf of an on-premises list:
- **Exchange:** list membership and send on behalf on cloud lists only worked once an **Exchange role group** gave the app *Security Group Creation and Membership*. The Entra role Exchange Administrator alone never exposed the override, even after two hours. Send as on an on-premises (synced) list applied through Exchange, which settles ADR 0106's open question.
- **AD:** adding someone to the on-premises list CAF Team worked. Send on behalf failed: "AD refused to let them send on behalf of the list: Compass's account has no rights there". The account `moneypenny.local\compass-ad` may write a group's `member`, but not its `publicDelegates`.

**Steve's decision (2026-10-14):** no per-OU delegations; that defeats a central account and is fragile. Compass's AD account is given **everything Compass writes, once, on the domain root**, inherited by every OU. Compass's own boundary (writes only inside the OUs ticked on the Admin tab, ADR 0083 §5) is what limits it.

## What people see

- **The AD setup notes give the one delegation** (below), as a block a domain admin pastes on a DC, with a sentence on what each line is for.
- **Access Control ▸ Admin ▸ Active Directory, managed OUs.** Each OU's rights line also says whether Compass can change **who sends on behalf** of its lists. If not, it says so and points at the setup notes.
- **Send on behalf of an on-premises list where Compass lacks that right becomes a to-do**, not a failure (ADR 0083 §4 "not set up"), the way a missing `member` right already behaves.
- **Exchange setup page and Test connection** name the Exchange role group step, with the Cloud Shell commands that worked. The red message names *Security Group Creation and Membership*.

## The delegation (domain root, inherited)

Everything Compass writes in AD (ad_writer): group `member` and `publicDelegates`; create, delete and move user accounts; user attributes (enable/disable, names, sign-in name, the admin-chosen joiner fields, pwdLastSet); reset password at creation.

```
set ROOT=DC=moneypenny,DC=local
set ACCT=MONEYPENNY\compass-ad
rem Lists and groups: who is in them, and who can send on their behalf
dsacls "%ROOT%" /I:S /G "%ACCT%:WP;member;group"
dsacls "%ROOT%" /I:S /G "%ACCT%:WP;publicDelegates;group"
rem Accounts: create, delete, and move between OUs
dsacls "%ROOT%" /I:T /G "%ACCT%:CCDC;user"
rem Accounts: change their details, enable or disable, and set the first password
dsacls "%ROOT%" /I:S /G "%ACCT%:WP;;user"
dsacls "%ROOT%" /I:S /G "%ACCT%:CA;Reset Password;user"
```

Protected accounts and groups (adminCount=1: Domain Admins and the like) don't inherit delegated rights, so Compass can't change them even inside a ticked OU. That's intended; the notes should say so.

## Notes (technical)

- `core/ad_scope.ou_rights`: add `can_change_senders` = `_may_write(..., "publicDelegates")` on the sampled groups. Stored on `ad_managed_ous`; migration 0258 (or the next free), existing rows NULL until the next rights check. A send-on-behalf write reads it, so `list_rights.route` gives `manual` where it is False.
- `tasks/access_execute._list_right_in_ad` and the recert path: `LDAPInsufficientAccessRightsResult` on `publicDelegates` becomes the to-do rather than a failure, in case the stored rights are stale.
- ADR 0107: an amendment (the Exchange role group is what makes lists work for an app). ADR 0083 §5: an amendment, the central delegation is the recommended shape (Steve). `scripts/exchange/README.md` step 3b.

**Done when:** on staging, after the delegation, send on behalf of CAF Team is applied by Compass, and the OU rights line says Compass can change senders.