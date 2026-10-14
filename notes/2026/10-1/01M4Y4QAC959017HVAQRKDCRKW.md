---
id: 01M4Y4QAC959017HVAQRKDCRKW
created: 2026-10-14T21:22:33.993878Z
updated: 2026-10-14T21:22:46.185926Z
type: task
title: Setup says what list changes really need, in Exchange and in AD — and a missing AD right for send on behalf becomes a to-do, not a failure
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 969
sprint: s192kdq
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Found in the COM-954/958 smoke tests (Steve, 2026-10-14). Everything now works on staging except send on behalf of an on-premises list:
- **Exchange:** list membership and send on behalf on cloud lists only worked once an **Exchange role group** gave the app *Security Group Creation and Membership*. The Entra role Exchange Administrator alone never exposed the override, even after two hours. Send as on an on-premises (synced) list applied through Exchange, which settles ADR 0106's open question.
- **AD:** adding someone to the on-premises list CAF Team worked. Send on behalf failed: "AD refused to let them send on behalf of the list: Compass's account has no rights there". The account `moneypenny.local\compass-ad` may write a group's `member` in the managed OUs, but not its `publicDelegates`.

## What people see

- **Access Control ▸ Admin ▸ Active Directory, managed OUs.** Each OU's rights line also says whether Compass can change **who sends on behalf** of its lists. If it can't: "Compass can't change who sends on behalf of lists in Distribution Groups — give its account rights there".
- **Send on behalf of an on-premises list in an OU where Compass lacks that right becomes a to-do**, not a failure. This is ADR 0083 §4's "not set up" rule, which is how a missing `member` right already behaves.
- **Exchange setup page and Test connection** name the Exchange role group step, with the Cloud Shell commands that worked. The red message names *Security Group Creation and Membership* as what's missing, not just Exchange Administrator.
- **AD setup notes** list the `publicDelegates` delegation beside `member`.

## Notes (technical)

- `core/ad_scope.ou_rights`: add `can_change_senders` = `_may_write(..., "publicDelegates")` on the sampled groups. Store it on `ad_managed_ous`; it needs a migration, next is 0258, and existing rows get NULL (unknown) until the next rights check. `ad_management` for a send-on-behalf write reads it, so `list_rights.route` gives `manual` where it is False.
- `tasks/access_execute._list_right_in_ad` and the recert path: a `LDAPInsufficientAccessRightsResult` on `publicDelegates` turns into the to-do (raise the step) rather than failing, in case the stored rights are stale.
- ADR 0107: add an amendment (Exchange role group is what makes lists work for an app; the Entra role alone didn't). README `scripts/exchange/README.md` step 3b with the two commands. ADR 0083 setup notes: the `publicDelegates` delegation.

**Done when:** on staging, the OU rights line says whether send on behalf can be changed. Without the delegation, send on behalf of CAF Team becomes a to-do. With it, Compass applies it.