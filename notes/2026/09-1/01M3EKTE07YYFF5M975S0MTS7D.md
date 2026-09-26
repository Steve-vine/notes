---
id: 01M3EKTE07YYFF5M975S0MTS7D
created: 2026-09-26T10:22:51.911845Z
updated: 2026-09-26T10:23:16.992613Z
type: task
title: 'A synced account''s leaver is finished in AD: disabling, deleting and correcting the account become to-dos'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 763
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Stacks on COM-762, the manual-step mechanism.

1,441 of the 1,551 accounts on staging are synced from on-premises AD. For those accounts Compass can end the person's sessions, but Microsoft refuses to let the cloud disable, delete or edit them.

**Today it's worse than a half-done leaver.** The leaver disables the account first, and for a synced account that step is refused. So the leaver fails before it has ended sessions or removed a single group or mailbox. None of the leavers executed on staging so far were synced accounts, and one pending leaver is.

## What people see

A leaver for a synced account runs everything Compass *can* do immediately:
- ends sessions
- removes cloud group memberships
- removes mailbox access

The account steps become manual lines on the COM-762 to-do, marked urgent:

```
Finish leaver Sam Jones in AD
Leaver · request #230 · approved by Deb Wharton, 26 Sep
AD account: sjones

  Disable the account          waiting
  SG-Sales-Files     remove    waiting
  Sales UK list      remove    waiting

[ I've done this ]   [ Can't do this… ]
```

- **Disable** is confirmed when the refresh shows the account disabled.
- **A scheduled delete** (ADR 0066) becomes its own manual line when its time comes. It is confirmed when the account disappears from the tenant. The existing "a leaver's account still standing with a delete coming" action keeps working, pointing at the manual line.
- **An amendment's correction** to a synced account (name, job title, department) is also a manual line, confirmed when the refresh shows the new value.
- A synced account's leaver is **urgent**: emailed at once, overdue the next working day. That's because the person keeps their AD sign-in until someone acts, and the to-do says so.
- If an account is converted in place to cloud-managed before the line is done, Compass does it itself and closes the line (COM-762).

## Out of scope

- **Joiners.** A joiner still creates a cloud-only account. Whether a new starter in a hybrid tenant should instead be created in AD, as a manual step with Compass then picking up the synced account, is a separate question to raise with Steve. It is not decided here.

## Notes

- `_execute_leaver` (`tasks/access_execute.py`) PATCHes `accountEnabled` before `revokeSignInSessions`, and a refused PATCH raises out of the whole subject. For a synced account: revoke first, skip the PATCH, raise the manual line, then carry on with groups and mailboxes.
- Pick the branch from the mirror's `on_premises_sync_enabled`, re-checked at the write. A Graph "on-premises mastered" refusal from a stale mirror should turn into the manual line, not a failure.
- The COM-525 behaviour (mark the mirrored account disabled at the write) must not fire for a manual disable. The mirror learns it from the refresh.

**Done when:** a leaver for a synced account on staging ends sessions and removes cloud access straight away. It raises one urgent to-do covering the disable and any on-premises group changes. Disabling the account in AD closes the line once it has synced. A test with the fake Graph proves a refused disable no longer stops the rest of the leaver.