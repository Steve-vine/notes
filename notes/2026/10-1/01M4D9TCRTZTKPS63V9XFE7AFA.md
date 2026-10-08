---
id: 01M4D9TCRTZTKPS63V9XFE7AFA
created: 2026-10-08T08:24:32.282505Z
updated: 2026-10-08T09:13:46.658665Z
type: task
title: A leaver's notes say what actually happened — "Deleted in AD" when it was deleted, and a retry replaces the note from the failed run
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 861
sprint: sme8esk
comments:
- id: 01M4DBRC3ZPKC2WR0W42Y0STDM
  author: Steve Vine
  at: 2026-10-08T08:58:23.231616Z
  text: |-
    Done: PR #866, merged to main (4131ac7). Not deployed to staging yet; say when.

    **What changed:**
    - **Deleted reads as deleted.** When a hybrid leaver's account is deleted in AD, the note now reads *"Deleted in AD — Entra removes the cloud account at the next sync (up to 30 minutes)"*, not *"Disabled in AD…"*. That's true whether the delete happens on the day or later, on its scheduled date. A leaver who is only disabled keeps *"Disabled in AD — Entra follows at the next sync (up to 30 minutes)"*.
    - **A retry's note is its own.** When someone is retried, the note left by the failed run (e.g. *"The run stopped partway…"* or *"can't reach dc01"*) is cleared, and the note describes only the run that succeeded.

    **Proven by tests:**
    - a leaver deleted on the day ends with the "Deleted in AD" note
    - a leaver that failed while AD was unreachable and was then retried ends with only the new run's note

    All 2,014 access, AD, to-do and mailbox tests pass.

    **ACR-56 itself won't change.** Its note was written before this fix, and Compass doesn't rewrite history. The next hybrid leaver shows the new wording.

    **Smoke test (after deploy):** raise a hybrid leaver with "delete after 0 days" for a test account in a managed OU. Once it's Executed, the note should read *"Deleted in AD — Entra removes the cloud account at the next sync (up to 30 minutes)"* and nothing else.
- id: 01M4DCMHX26SE36MPZC9X54V8T
  author: Steve Vine
  at: 2026-10-08T09:13:46.658486Z
  text: '**Deployed to staging:** 4131ac7 (`staging-20261008-0912`), with the deploy and smoke check green. The API, worker, beat and frontend are on the new images, with no restarts. Only this fix shipped. Ready for the smoke test in the comment above.'
assignee: steve
label:
- bug
priority: low
task_status: review
---
Found in Steve's smoke test of ACR-56 (staging, 2026-10-08).

## What happened

ACR-56 (Abigail Sky) was a hybrid leaver set to delete after 0 days. The retry disabled her in AD, revoked her sessions and **deleted** her account. The request's note then read:

> *The run stopped partway (the worker was replaced while it waited on Kerberos) — Retry carries on from where it left off; Disabled in AD — Entra follows at the next sync (up to 30 minutes)*

Two things are wrong:
- It says **Disabled**, but she was deleted.
- The failed run's note is still there in front of the successful run's note.

## What should happen

- A hybrid leaver deleted in AD says *"Deleted in AD — Entra removes the cloud account at the next sync (up to 30 minutes)"*. One that's only disabled keeps *"Disabled in AD — Entra follows at the next sync (up to 30 minutes)"*.
- When a person is re-run (Retry), their note describes **this** run. A note left by the failed run is not carried forward.

## Notes (technical)

- Find where the leaver's AD-disable note is written, and where the zero-day `_delete_account` AD path runs. Replace the note when the delete succeeds in AD.
- Retry: find where `outcome_detail` is appended rather than set at the start of `_execute_subject` for a re-run subject. Reset it for a subject that isn't applied when its run begins.
- Tests: a hybrid zero-day leaver ends with the "Deleted in AD" note; a failed subject that's retried ends with only the new run's note.

**Done when:** both notes read correctly, in CI, merged to main.