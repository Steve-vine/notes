---
id: 01M8EH1WB7QY4DH2HF42C3QCS9
created: 2026-11-27T12:52:59.367614Z
updated: 2026-11-27T12:52:59.367614Z
type: task
title: A joiner Compass can't create becomes a "create this account in AD" to-do — and the joiner carries on once the account appears
assignee: steve
priority: medium
label: feature
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2185
---
**On the chain** (migration for a new to-do kind). Builds on COM-2178 (to-dos say why they're manual; ADR 0182).

Steve's decision (27 Nov 2026): under the sprint's principle, Compass makes every change its account has the rights for and raises a to-do for the rest. Joiners are the one exception left. If Compass can't create the account in AD (no right to create accounts in the role's OU, or AD refuses), the joiner **fails** outright (`_join_in_ad`: "there is no to-do to fall back to").

## What people see
- **When Compass can't create the account,** the joiner doesn't fail. It raises a to-do: "Create Sam Jones's account in AD — in OU=Finance,OU=Users,… as sam.jones@moneypenny.co.uk". The to-do gives everything the admin needs:
  - name and sign-in name;
  - the OU;
  - the joiner details Compass would have written (job title, department, manager, office…);
  - why it's manual (e.g. "Compass's account can't create accounts in this OU").
- **It's urgent:** the joiner's start date is close. It appears in Actions straight away and is emailed at once, like a leaver step.
- **The request waits:** it reads *Waiting for the account to be created in AD*.
- **Picked up automatically:** when the next AD read (every 5 minutes) finds an account with that sign-in name, Compass adopts it, as it already does for an account that exists before a joiner runs. It then carries on with the rest of the joiner itself: the details it can still set, groups, shared mailboxes, list rights and licences, each by the usual rules.
- **Password:** the admin sets the first password when they create the account and hands it over themselves. Compass shows no one-time password for an account it didn't create. The request says so.
- **"Can't do this":** if the admin uses **Can't do this**, with a reason, the joiner fails with that reason, as any to-do does today.
- **Duplicate names:** if someone creates the account with a different sign-in name, Compass can't match it. The to-do stays open and says what it's looking for. The admin can correct the request's sign-in name through the usual correction.

## Notes (technical)
- New `ManualStepAction.account_create`, carrying the desired attributes in `desired` and the target OU DN. The reason comes from COM-2178's `why_manual`.
- In `_join_in_ad`, the refusal paths raise the step instead of `GraphError`:
  - `new_starter_refusal` for a missing create right or an unmanaged OU;
  - AD's insufficientAccessRights on create.

  Configuration errors that no person can fix by hand still fail: no OU set for the role, a manager who has gone.
- The AD read closes the step when `find_user_by_upn` matches. The joiner then resumes from the point after creation. Check the joiner's continuation and its wait for the account to sync to Entra both handle a resumed subject.
- The ledger stamps the adopted account's creation as requested, so it doesn't come back as an unrequested "account created".
- Actions title wording sits alongside COM-2177's.

**Done when:** on staging, a joiner for E2E Test Company whose role's OU Compass may not create accounts in:
- raises a "Create … in AD" to-do;
- once an account with that sign-in name exists in AD, is adopted on the next read, and the joiner finishes its groups.

(Needs a test OU without the create right; use the E2E joiner "Compass Test" pattern.)