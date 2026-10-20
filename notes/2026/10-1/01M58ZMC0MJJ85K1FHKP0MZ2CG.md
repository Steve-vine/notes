---
id: 01M58ZMC0MJJ85K1FHKP0MZ2CG
created: 2026-10-19T02:25:13.236615Z
updated: 2026-10-20T15:55:34.671427Z
type: task
title: A role's Content card stops showing a round that is still running once the assignment is stopped and restarted for a later date
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1104
comments:
- id: 01M5CQJYKVYEA0M6HCFA092D3E
  author: Steve Vine
  at: 2026-10-20T13:21:35.867523Z
  text: |-
    Merged in PR #1149 at 13:21 UTC on 2026-10-20 (main 79a93188).

    After an assignment is stopped mid-round and restarted for a later date, a role's Content card keeps showing the round that is still running: Running, with its progress, beside the new Next opens date. Once that round's deadline passes it reads Scheduled until the restart's date.

    **The assistant:** restarting through it no longer says the earlier round "opened today" or that anyone was emailed. It says that round carries on to its deadline, and when the restart opens.

    **My calls:**
    - "Still running" means before the round's deadline, the same rule the card uses for any round. It does not run on to the last late joiner's own due date, so the card reads the same either way.
    - New holders still join only rounds opened since the restart. Nothing about who is asked has changed.

    **Checks:**
    - A new API test: stop mid-round → restart later → Running to the deadline, then Scheduled.
    - Two older assertions had pinned the old behaviour (Scheduled while the day's round still ran); updated.
    - `test_attestation_assignments.py`, `test_assistant_attestations.py` and `test_attestation_cycles.py`; ruff and mypy; CI green.
assignee: steve
label:
- bug
priority: low
task_status: done
---
Follow-up to sprint 78 (Attestations, ADR 0117). Noticed while building COM-1102, 2026-10-19; not yet seen on staging.

## What is wrong

On Access Control ▸ Roles ▸ a role ▸ Content: stop an assignment while its round is running, then restart it with a future assign date. The round that was already running still asks people up to their own due dates, as designed. But the row now shows only Scheduled and the new Next opens, and the "12 of 40 signed, 6 days left" progress disappears.

The Attestations ▸ Open tab still shows the round, so nothing is lost, but the role page reads as if nothing is running.

## Fix

While a round from before the restart is still running, the row should keep showing it: Running, with its progress, and the next opening alongside.

**Done when:** after stop → restart (future date) mid-round, the role's Content card shows the running round's progress until its last person's due date, then Scheduled.