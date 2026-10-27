---
id: 01M5YA7DPCE2V1RDSDZBKK1XN5
created: 2026-10-27T09:14:26.380845Z
updated: 2026-10-27T09:14:26.380845Z
type: task
title: Fix-by targets per severity are a rubric in Admin, and an owner is told when a vulnerability lands on them, when it is a week from due and when it is overdue
priority: high
task_status: todo
assignee: steve
label: feature
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1368
---
Sprint 91, Vulnerabilities - Register (ADR in COM-1362). Builds on COM-1367.

## What people see

- **Admin ▸ Rubrics ▸ Vulnerability fix-by targets:** days to fix each severity.
  - Defaults: Critical 15, High 30, Medium 90, Low 180, Informational none.
  - These are my proposal, to be checked against the vulnerability-management policy before staging.
  - Changing a target recalculates the fix-by date of every open vulnerability of that severity. The window says how many will move and how many become overdue.
- **The owner's Actions** (Overview ▸ Actions, and the User Portal for owners without an internal role):
  - **"Fix VUL-12 on <system> by <date>"** appears when a vulnerability is assigned to them.
  - The action turns amber a week before the fix-by date and red when overdue.
  - It leaves their actions when the vulnerability is fixed, accepted, a false positive or reassigned.
  - An accepted vulnerability past its review date comes back as **"Review the acceptance of VUL-12"**.
- **Email** follows the actions, as every derived action does: the usual digest, not one email per vulnerability.

## Who can do what

- Changing the rubric needs whoever can change rubrics today.
- Actions go to the owner.

## Notes (technical)

- Declare an action source (ADR 0055); don't write a notify().
- The rubric joins `brief/rubrics.md` with its defaults.
- Recalculation in one statement per severity, audited as one change.

**Chain:** on the chain (migration: rubric + seed; API).

**Done when:**
- the rubric is editable and moves dates;
- an owner sees the action appear, go amber, go red and clear;
- the digest carries it.