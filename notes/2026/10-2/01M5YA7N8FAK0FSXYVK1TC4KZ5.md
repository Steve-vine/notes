---
id: 01M5YA7N8FAK0FSXYVK1TC4KZ5
created: 2026-10-27T09:14:34.127939Z
updated: 2026-10-27T09:19:30.89394Z
type: task
title: Many vulnerabilities at once — choose rows in the Register to assign an owner, comment, mark fixed, call false positive or accept them together
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1369
sprint: s6wypy5
blocked_by:
- 01M5YA6ZNQ5Q5CGV8DXB00MQ41
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint 91, Vulnerabilities - Register (ADR in COM-1362). Builds on COM-1367.

A scan can bring in hundreds of rows. Nobody should have to open each to give it an owner.

## What people see

- **Tick boxes on Register rows**, with "select all N matching" for the whole filtered set, not just the page.
- **A bar of actions for the chosen rows:**
  - Assign owner;
  - Comment;
  - Mark fixed (hand-recorded and pen-test rows only; others are skipped and counted);
  - False positive;
  - Accept;
  - Raise one risk for all of them.
  - Each asks once for the reason or review date and applies it to every row.
- **Before applying**, the window says how many it will change and how many it will skip, and why. For example: "12 recorded by you can't be accepted by you".
- **Grouped by issue**, choosing an issue row chooses its vulnerabilities on every system.

## Who can do what

The same as one at a time: work vulnerabilities, and accept vulnerabilities for Accept. The second-person rule applies row by row.

## Notes (technical)

- One bulk endpoint per action, each row through the same transition function, in one transaction.
- One activity entry per row, grouped under one bulk operation.
- Cap at 1,000 rows per call; the UI batches above that.

**Chain:** on the chain (API).

**Done when:**
- 300 rows can be assigned and accepted in two steps;
- the skipped counts are right;
- each row's History shows the change.