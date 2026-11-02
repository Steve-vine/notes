---
id: 01M6EKV1SBCKTF183MCE6Q4GDS
created: 2026-11-02T17:10:17.643713Z
updated: 2026-11-02T22:12:41.23386Z
type: task
title: Exploited or Critical matches land in My actions — one action per item for the company's Security Feed managers, done when someone confirms it (and raises it) or marks it not relevant
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1523
sprint: s6xh9g1
blocked_by:
- 01M6EKSK3GGHY1E8J0FQPE60NV
- 01M6EKW2GXSF3TJDYAKWX14ZFP
comments:
- id: 01M6F54QGY6QM7MA9ZCTAVA68P
  author: Steve Vine
  at: 2026-11-02T22:12:40.605908Z
  text: |-
    Done. Merged to main (PR #1541). It isn't on staging yet: the whole sprint goes there together once every task is in Review.

    What people see in **My actions** (and so on the Actions screen, in the user portal and in the action emails):
    - A match that is **known exploited** or **Critical**, and still needs a person, becomes one shared action for the company's Security Feed managers:
      - Type **Security Feed**, action **Review: affects us?**;
      - titled with the item's id and title;
      - no single owner.
    - Its status says why it's there:
      - "known exploited · CISA due 21 Nov";
      - "critical";
      - "changed since marked not relevant: it is now known to be exploited".
    - It's due on **CISA's date** when CISA has set one. Otherwise it's due **7 days** after the match (exploited) or **14 days** (Critical).
    - **Not relevant** closes it.
    - **Confirming without raising** keeps it open as "confirmed: raise a vulnerability or risk". Raising a vulnerability or risk then closes it.
    - An item marked not relevant that **comes back** reopens the same action, saying what changed. Its due date now counts from the day it came back (fixed in COM-1531, so it doesn't arrive already overdue).

    Built differently from the task: the 7- and 14-day periods are set on **Admin ▸ Actions**, as the two Security Feed action kinds, rather than as a Security Feed rubric. That keeps them with every other action's due period.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Sprint 102, Security Feed (ADR 0139 §9, COM-1510).

## What people see

When an item **matches** a company (Possibly affects us, or Versions not stated) **and** is **known exploited** or **Critical**, the company's Security Feed managers get **one action**:
- Type **Security Feed**;
- Action **Review: affects us?**;
- the item's id and title;
- why it's urgent ("Known exploited · CISA due 21 Nov").

The action **due date** is CISA's due date if there is one, otherwise 7 days for known-exploited and 14 days for Critical.

The action **closes itself** when anyone confirms the item **and** raises a vulnerability or risk from it, or marks it not relevant. Confirming without raising leaves it open, as "Confirmed: raise a vulnerability or risk".

An item that **comes back** (changed since marked not relevant, COM-1520) and qualifies opens a new action, saying what changed.

It appears in the Actions screen, in the user portal's Actions, and in the daily actions email, like every other action (ADR 0137).

## My calls

- The action goes to **every** Security Feed manager of the company, as one shared action (ADR 0137: one action per thing). Whoever acts closes it for all.
- The due dates (7 and 14 days) sit in Admin ▸ Rubrics ▸ Security Feed review targets, editable.

## Notes (technical)

- Declare an **action source** (ADR 0055/0137, `core/actions` source registry). Don't write a `notify()`: the queue and the mail are derived.
- The source's query is the company's matches with status in (possibly, versions_not_stated, confirmed-not-raised) and (`known_exploited` or severity = critical). Assignees are the holders of *Manage security feed* for the company.
- Add the rubric rows to the rubrics brief and seed them.

**Chain:** on the chain (migration + API).

**Done when:** on staging in E2E Test Company:
- a known-exploited match appears in the admin's My actions with CISA's due date;
- marking it not relevant clears it;
- a Critical match that's confirmed without raising stays open as "Confirmed: raise…".