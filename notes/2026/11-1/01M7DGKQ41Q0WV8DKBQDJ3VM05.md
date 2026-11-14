---
id: 01M7DGKQ41Q0WV8DKBQDJ3VM05
created: 2026-11-14T17:10:19.009548Z
updated: 2026-11-14T17:10:29.032498Z
type: task
title: Checks ▸ Overview's "Needs attention" counts failing checks, matching All checks (it says 7 where All checks says 6)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1832
sprint: spsp226
assignee: steve
label:
- bug
priority: low
task_status: todo
---
## What happened

Seen in Claude's pre-UAT pass on staging (53965a3b, 2026-11-14), E2E Test Company. Checks ▸ Overview's **Needs attention** says "7 checks failing", while the All checks headline says "13 checks: 3 passing · 6 failing · 0 no rule · 4 can't tell". The 7 looks like a count of controls with a failing check, not of checks: "No dormant accounts" covers both IDM.5 and IDM.6, so one failing check is counted twice. Not caused by sprint 116's work.

## What people see

- Needs attention says how many **checks** are failing, the same number as All checks ("6 checks failing"). If it's useful to say how many controls they touch, it says so in its own words ("6 checks failing, across 7 controls").
- Clicking it opens All checks filtered to Failing, showing that same number.

## Done when

- In E2E Test Company, Needs attention and the All checks headline agree on the number of failing checks.
- A test covers one failing check mapped to two controls being counted once.

**Independent.** Not started; logged at Steve's request on 2026-11-14.