---
id: 01M8EH1WB7QY4DH2HF42C3QCS9
created: 2026-11-27T12:52:59.367614Z
updated: 2026-11-27T22:31:18.37303Z
type: task
title: A joiner Compass can't create becomes a "create this account in AD" to-do — and the joiner carries on once the account appears
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2185
sprint: smq8t5s
blocked_by:
- 01M8EED1JWZH5K8NNQBTA6ZDGZ
comments:
- id: 01M8F0X3J37NCYD7GETZC86YR5
  author: Steve Vine
  at: 2026-11-27T17:30:00.131432Z
  text: |-
    Done — merged to main in PR #2197. Not on staging yet; it goes with the sprint.

    What changes:
    - A joiner no longer fails when Compass may not create the account in AD (the role's OU isn't ticked, Compass's account can't create accounts there, or AD refuses). Instead:
      - It raises an urgent to-do: "Create Grace New's account in AD — in OU=Staff,… as grace.new@…".
      - The to-do lists the details Compass would have written and why it's manual. It's in Actions and emailed at once, like a leaver step.
      - The request reads Waiting on manual steps, and the person reads "Waiting for the account to be created in AD — whoever creates it sets its first password and hands it over".
    - The next AD read (every 5 minutes) that finds an account with that sign-in name picks it up, and the joiner carries on: groups, shared mailboxes, list rights and licences, by the usual rules. In hybrid, the cloud side follows once the account reaches Entra, as for any joiner made in AD.
    - The account's creation is recorded as requested, so it never shows as an unrequested "account created".
    - No one-time password is shown for an account Compass didn't create.
    - Can't do this fails the joiner with its reason, as any to-do does.
    - The joiner form says under the role when an admin will be asked to create the account, instead of refusing it. It still refuses when there's nowhere to put them (no OU and no default).
    - If the account is created under a different sign-in name, the to-do stays open saying what it's looking for. The request's sign-in name can be corrected as usual.

    Checks:
    - New tests:
      - With no right to create: the form says so and raising is allowed. Approving makes the to-do, with nothing created and the request waiting. Once the account appears in AD, the AD read picks it up, gives its group, completes the request, and records the creation as requested.
      - When AD refuses: a to-do, and Can't do this fails it with the reason.
    - AD joiner suite: 14 passed.
    - To-do and AD suites: 44 passed.
    - Unit suite: passed.
    - All ten CI jobs passed.

    For pre-UAT on staging: needs a test OU in E2E Test Company without the create right. If staging has none, that part is Couldn't check.
- id: 01M8FA02S6AS24DB5HQ1ZNRZ7C
  author: Steve Vine
  at: 2026-11-27T20:08:54.821544Z
  text: |-
    Pre-UAT on staging 30786db4f: Passed (the line under the role, where Compass can create); Couldn't check (an OU without the create right).

    Steps and what I saw, as E2E Access Manager: New request ▸ Joiner, Primary role "E2E Starter" (the only role offered). Under the role it reads "Created in MyBusiness › Users › UK › Non PA › Security Users", and the summary on the right repeats it. I pressed Cancel ▸ Discard changes; nothing was submitted.

    Couldn't check:
    - the line saying an admin will be asked to create the account (the E2E Starter role's OU allows creating accounts);
    - the urgent "Create … account in AD" to-do;
    - the account being picked up on the next AD read and the joiner finishing its groups.
    For Steve: point a test role at an OU Compass's account can't create users in (or an unticked OU) and open the joiner form. The line under the role should say an admin will create it. Submitting and approving it is then the real check.

    Screenshot: ~/compass-uat/sprint-128/COM-2185/01-joiner-form-role-line.png
assignee: steve
label:
- feature
priority: medium
task_status: done
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