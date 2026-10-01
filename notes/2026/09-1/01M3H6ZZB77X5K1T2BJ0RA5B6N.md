---
id: 01M3H6ZZB77X5K1T2BJ0RA5B6N
created: 2026-09-27T10:36:25.319083Z
updated: 2026-10-01T07:00:53.234593Z
type: task
title: When AD is set up, or an OU is added, waiting to-dos are carried out by Compass
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 783
sprint: sme8esk
blocked_by:
- 01M3H6YPXKZTV2DX50WBS58NBF
- 01M3H6Z02EKHPKBJJ0GF9PBTQ0
comments:
- id: 01M3HX84SEJJ5KBS8BHHJ6HHG5
  author: Steve Vine
  at: 2026-09-27T17:05:21.710529Z
  text: |-
    Done — PR #793 (stacked on #792).

    - Every 5 minutes Compass looks at the waiting to-dos. It carries out any it can now make in AD, because AD has been connected or the OU has been ticked: group membership, disable, delete, name correction.
    - Each one closes as "Applied by Compass" in the to-do's history, and the person it was assigned to has nothing left to do.
    - A to-do someone has already marked done by hand is left alone.
    - If AD refuses, the to-do stays with its person and Compass tries again on the next pass.

    Tests: a to-do raised before its OU was ticked is carried out on the next pass (in AD, then applied by Compass), and a to-do already marked done is untouched.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Part of the on-premises AD sprint (ADR in COM-773).

**The rule (Steve, 2026-09-27):**
- If something breaks, the change becomes a **retry**.
- If Compass isn't set up to make the change, it becomes a **manual to-do**.
- If the change isn't allowed, it **stays not allowed** in Compass.

## What people see

- **When AD is first set up, or an OU is added to the managed list,** Compass carries out the to-dos it can now do itself. They close by themselves, marked **Done by Compass**, so nobody has to clear the backlog by hand, and the Actions list shrinks.
- **If AD is set up but a change fails** (the domain controller is unreachable, it times out, AD returns an error), the change does **not** become a to-do. The person on the request shows **Failed** with the reason and a **Retry**, exactly like a cloud change that fails today. The AD card's health badge and System status say what's wrong.
- **An OU is ticked but Compass's account has no rights there.** The card already flags this (COM-778). Changes in that OU count as *not set up*, so they become to-dos until the rights are fixed or the OU is unticked.
- **A to-do someone has already marked done by hand,** but that hasn't landed yet, is left alone. The person's word stands until the next read confirms it or sends it back (ADR 0079).

## Notes (technical)

- Extend `manual_steps.converted_steps()` and `access_execute::_apply_converted_manual_steps` from "the object is now cloud-mastered" to "the object is now managed in AD". This is COM-778's predicate, which includes the stored rights check. `resolved_by_compass` already exists.
- **Routing is decided before the write:**
  - managed in AD → LDAP;
  - not → step.
- **Failures at the write:**
  - LDAP connection, timeout, busy or refused → `AccessSubjectOutcome.failed` with detail, the same path as `GraphError`/`ExchangeError` today (`access_execute.py` ~L2050);
  - review removals → `removal_failed`.
  
  Never fall back to a step at write time.
- The existing request **Retry** (`POST /access-requests/{id}/retry`) and the review-removal retry cover AD as they do Graph. Check that both re-run only what didn't land.
- The trigger is the 5-minute `sweep_due_access_work`. No new timer.

**Done when:**
- On staging, to-dos raised before AD was set up are carried out once it is, and show *Done by Compass*.
- With the worker's route to the DC cut, a new leaver shows **Failed** with a reason and a Retry, not a to-do. The badge goes red. Once the route is restored, Retry completes it.