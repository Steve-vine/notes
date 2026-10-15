---
id: 01M4ZVTEVQR5DX8M7G420T3Z6E
created: 2026-10-15T13:25:28.567815Z
updated: 2026-10-15T13:25:33.074187Z
type: task
title: Retrying a leaver whose account the request has already deleted finishes, instead of failing at the first step
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 985
sprint: s192kdq
assignee: steve
label:
- bug
priority: high
task_status: active
---
Found on staging 2026-10-15 (Steve): leaver #68 for Abu Darby, retried after COM-971..973, failed with "AD could not read the account: the object is not there".

## What happens

An earlier run of this leaver deleted the account (the form asked for "delete straight away"), but the request still ended *Failed* (COM-971/972). Retry starts the leaver from the top, and its first step is to disable the account in AD. The account isn't there to disable, so the run fails at once and every retry does the same. Nothing after that step runs.

## What should happen

When this request has already deleted the account, a retry finishes:
- **Nothing is changed in any directory.** There is nothing left to take away: the account is gone, and the memberships, sessions and rights with it.
- **The person's job function is cleared,** as a leaver always does.
- **The outcome says so:** "The account was already deleted by this request — nothing left to take away".

## Notes (technical)

- "Already deleted" = `subject.account_deleted_at` is set, or the ledger holds a `user_deleted` change for this subject. Since COM-973 that row survives a run killed between the delete and the commit.
- Out of scope: an account someone else deleted before the leaver ran.