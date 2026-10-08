---
id: 01M4D9TCRTZTKPS63V9XFE7AFA
created: 2026-10-08T08:24:32.282505Z
updated: 2026-10-08T08:24:38.114438Z
type: task
title: A leaver's notes say what actually happened — "Deleted in AD" when it was deleted, and a retry replaces the note from the failed run
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 861
sprint: sme8esk
assignee: steve
label:
- bug
priority: low
task_status: active
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