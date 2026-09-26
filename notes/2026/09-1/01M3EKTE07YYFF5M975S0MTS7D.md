---
id: 01M3EKTE07YYFF5M975S0MTS7D
created: 2026-09-26T10:22:51.911845Z
updated: 2026-09-26T13:56:22.730586Z
type: task
title: 'A synced account''s leaver is finished in AD: disabling, deleting and correcting the account become to-dos'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 763
sprint: ss8v7d0
blocked_by:
- 01M3EKSWCQXD122FVEKD7Z3A66
comments:
- id: 01M3F01BPPAQ5JMZMQYZHRW1F0
  author: Steve Vine
  at: 2026-09-26T13:56:21.84652Z
  text: |-
    Done — PR #774, merged to main (d97bff1).

    A leaver for an account synced from AD no longer fails at its first step.

    - **Sessions end first**, then cloud groups and mailbox access are removed as before. **Disable the account** becomes an urgent to-do, together with any on-premises group removals, shown as *Finish leaver … in AD*. The cloud is never asked to disable a synced account. If the mirror didn't know the account was synced, it learns from Graph's refusal and raises the to-do instead of failing.
    - **Deletion** (the scheduled delete): the clock starts when Compass *sees* the disable, not when the request ran. When the date comes, the to-do is **Delete …'s account in AD** (digest, not urgent). It closes once the account is gone, and until then the request reads *Delete pending*.
    - **Amendments:** a new name or sign-in name for a synced account becomes a *Correct the account* to-do. The usage location is still written directly, because the cloud owns it.
    - **Recorded for the audit trail:** each confirmed disable, delete or correction gets its ledger row (user_disabled / user_deleted / user_updated), so a person's disable in AD is never reported as an unprocessed leaver.
    - **Converted in place:** an account switched to cloud-managed before its to-do is done is disabled, corrected or deleted by Compass on the sweep, with the same privilege gate.

    Joiners are unchanged; they still create cloud-only accounts. That's the open question from the task.

    Smoke test: approve the pending leaver for the synced account on staging. Sessions end, cloud access goes, and *Finish leaver … in AD* appears on Actions. Disable the account in AD; after AD Connect and the next Compass sync, the step reads Applied.

    Not deployed yet: staging goes out once all five tasks are merged.
assignee: steve
label:
- feature
priority: high
task_status: review
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