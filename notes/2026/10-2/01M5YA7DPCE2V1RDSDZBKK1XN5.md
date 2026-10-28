---
id: 01M5YA7DPCE2V1RDSDZBKK1XN5
created: 2026-10-27T09:14:26.380845Z
updated: 2026-10-28T18:17:05.35059Z
type: task
title: Fix-by targets per severity are a rubric in Admin, and an owner is told when a vulnerability lands on them, when it is a week from due and when it is overdue
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1368
sprint: s6wypy5
blocked_by:
- 01M5YA6ZNQ5Q5CGV8DXB00MQ41
comments:
- id: 01M5ZK5Q0EWV6SXGM49E3HVX1R
  author: Steve Vine
  at: 2026-10-27T21:10:01.99797Z
  text: |-
    Built and merged: PR #1383.

    **What's there**
    - **Admin ▸ Rubrics ▸ Vulnerability fix-by targets**: days to fix each severity, with defaults of Critical 15, High 30, Medium 90, Low 180 and Informational none. Before saving, the window says how many open vulnerabilities will get a new date and how many become overdue. It then moves them all at once.
    - **The owner's Actions**:
      - "Fix VUL-12 on Payroll by 30 Dec 2026". It turns amber in the last week and red once overdue, and leaves when the vulnerability is fixed, accepted, a false positive or given to someone else.
      - "Review the acceptance of VUL-12" from a week before its review date.
    - The usual actions email carries both; there's no email per vulnerability.
    - `brief/rubrics.md` has the rubric as §9.

    **My calls**
    - **The defaults are still my proposal.** Please check them against the vulnerability-management policy before relying on them.
    - A severity with **no target** has no fix-by date, is never overdue, and isn't in anyone's Actions. Informational is like that by default.
    - Changing a target moves only **open** vulnerabilities. Fixed, accepted and false-positive ones keep the date they were judged against. Archived companies don't move.
    - An acceptance's review shows as **"Review the acceptance"** in the week before it lapses. After that, Compass reopens it (COM-1367) and it's a Fix action again. I didn't keep a separate "came back" action, because reopening already puts it in front of the owner.
assignee: steve
label:
- feature
priority: high
task_status: done
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