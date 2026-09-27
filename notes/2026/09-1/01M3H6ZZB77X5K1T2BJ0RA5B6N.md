---
id: 01M3H6ZZB77X5K1T2BJ0RA5B6N
created: 2026-09-27T10:36:25.319083Z
updated: 2026-09-27T10:36:59.096689Z
type: task
title: When AD is connected, waiting to-dos are carried out by Compass — and if AD goes away, they come back
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 783
sprint: sme8esk
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Part of the on-premises AD sprint (ADR in COM-773).

## What people see

- **When AD is first connected, or an OU is added to the managed list**, the to-dos Compass can now do itself are carried out and close by themselves, marked **Done by Compass**. Nobody clears the backlog by hand. The Actions list shrinks accordingly.
- **If AD becomes unreachable**, new changes fall back to to-dos, as today. The AD card's health badge and System status say why.
  - A change that was in flight when the connection dropped is retried a few times before it becomes a to-do.
  - Nothing is lost silently: every change ends **Applied** in AD or as a to-do.
- A to-do someone has already marked done by hand but that hasn't landed yet is left alone. The person's word stands until the next read confirms or returns it (ADR 0079).

## Notes (technical)

- Extend `manual_steps.converted_steps()` and `access_execute::_apply_converted_manual_steps` from "the object is now cloud-mastered" to "the object is now managed in AD" (COM-778's predicate). `resolved_by_compass` already exists.
- **Retry policy.** Retry transient LDAP errors (connection, timeout, busy) within the sweep. Persistent errors (no rights, no such object) become a step at once, with the reason.
- The 5-minute `sweep_due_access_work` is the trigger. No new timer.

**Done when:** on staging, to-dos raised while AD was disconnected are carried out once AD is connected and show *Done by Compass*. With the worker's route to the DC cut, a new leaver becomes an urgent to-do, and the badge goes red with a reason.