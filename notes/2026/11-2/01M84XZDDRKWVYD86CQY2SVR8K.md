---
id: 01M84XZDDRKWVYD86CQY2SVR8K
created: 2026-11-23T19:26:25.720339Z
updated: 2026-11-23T19:27:18.253226Z
type: task
title: 'Restore option 3, part 1: open a copy beside live Compass, read-only, and see for each record whether it is missing, changed or the same'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2121
sprint: szwetpq
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
ADR 0169 §7, §8.

**Chain:** on the chain — migration + API.

**What people see**

- On a copy, **Open to compare** opens it beside live Compass. Nothing goes offline and nobody else is affected.
- The Admin browses by area: Content, Controls, Assessments, Gaps, Risks, Decisions, Vendors, Inventory, Registers and evidence details.
- Each record shows **Missing**, **Changed** or **Same** against today, filterable, with changes side by side in screen words.
- An opened copy says when it will close, and closes itself after 24 hours. It can be closed sooner. Only one is open at a time.
- People, roles, access requests, tokens, credentials, settings and logs are not shown.

**Done when**

- With a copy open, live Compass carries on normally, and nothing can write to the opened copy.
- A record deleted since the copy shows Missing, an edited one shows Changed with its differences, and an untouched one shows Same.
- A company-scoped record is shown only for the company it belongs to, and Restricted records stay restricted.
- After 24 hours the opened copy is gone from the database, including if a worker restarted in between.
- A copy from an older schema either opens brought up to date or says clearly why it can't.

**Technical notes**

- Restore into a temporary schema in the same database (see COM-2118), read through a read-only connection or transaction. Exclude secrets from what is loaded where possible: encrypted credential columns and token hashes have no reason to be there.
- Watch disk: an opened copy roughly doubles the database for up to 24 hours. Check free space first.
- Drive the areas from one catalogue, one entry per area, so adding an area is configuration of that list.
- Respect Restricted and company scoping by reusing each area's existing read rules, not a parallel set.