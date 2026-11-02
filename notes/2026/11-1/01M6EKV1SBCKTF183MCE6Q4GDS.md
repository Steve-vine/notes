---
id: 01M6EKV1SBCKTF183MCE6Q4GDS
created: 2026-11-02T17:10:17.643713Z
updated: 2026-11-02T17:11:34.78762Z
type: task
title: Exploited or Critical matches land in My actions — one action per item for the company's Security Feed managers, done when someone confirms it (and raises it) or marks it not relevant
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1523
sprint: s6xh9g1
assignee: steve
label:
- feature
priority: medium
task_status: todo
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