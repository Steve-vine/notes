---
id: 01M7B04RXWE49D4F3VYCY61BPZ
created: 2026-11-13T17:44:03.260783Z
updated: 2026-11-13T17:55:40.961466Z
type: task
title: 'A collected check''s capture covers its own period: a weekly check collects last week, and the captures build up into a history'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1799
sprint: spsp226
assignee: steve
label:
- feature
priority: high
task_status: active
---
Steve, 2026-11-13, after approving the first FreshService checks for Moneypenny. The CHM.1 change register captured all 1,632 changes ever made. CHM.7 opens every change to read its approvals, and it will do that again every week (about 30 minutes and FreshService's rate limit each time). The readable page shows only the first 1,000 rows, so the auditor may not see the review period (18 Jan to 18 Apr 2027) at all.

## What people see

- A check that collects **records** (changes, tickets, approvals, threats, sign-ins) collects only its **own period** on each run. A weekly check collects the 7 days since its last period ended, a daily check 1 day, a monthly check the month. Each capture carries its period ("6–12 Nov 2026") and when it was taken.
- Captures **build up**: each one is its own entry in the check's history and in the Evidence register. A new week doesn't replace last week. An auditor's period is covered by the weeks inside it.
- A check that shows **how something is set up** (form fields, policies, group members, configuration profiles) stays a snapshot "as at" the day it ran. It keeps today's behaviour: nothing new is filed when it hasn't changed, and "still true on" moves forward.
- Polaris says which kind each check is when it designs one. For a records check it also says which date field the period applies to. The approval card shows both: "Collects each week's changes, by created date" or "A snapshot of how it's set up".
- **Held for review** doesn't hold a period capture just because its count differs from last week's (a quiet week is normal). It still holds on fields appearing or going missing.
- Missed runs are caught up: if the worker was down for two weeks, the next run collects each missed week as its own capture, so the history has no holes.

## Decisions (made, say if wrong)

- The period is expressed in configuration, never per service (ADR 0147 §9). A read names the service's own "from" (and optional "to") parameter, extending ADR 0148's `since`, plus the date field Compass trims to. This lets a service that only takes "since" still give exactly the period.
- The first run of a new records check collects only its first period. It doesn't collect history; a custom range (separate task) does that.
- The eight Moneypenny checks already live (CHM.1, CHM.3, CHM.4, CHM.7, IMA.5) keep their existing captures as "everything up to 13 Nov 2026". They are recreated through Polaris as records or snapshot checks once this ships.
- This needs an ADR: a capture has a period. It amends ADR 0142 §3–§4.

## Done when

- A weekly records check run on schedule files one capture for exactly the last 7 days, using the service's own date filter where it has one, and Compass trims to the period by the named date field.
- A snapshot check behaves as today.
- Missed periods are caught up one capture each.
- Held-for-review ignores the count change for period captures.
- Polaris's design form asks for the kind and the date field, and the Review card shows them.
- There's an ADR.
- Tests cover period arithmetic (daily, weekly, monthly, catch-up), trimming, and the hold rule.
- No service-specific code (the COM-1696 test passes).

**On the chain** (migration: a capture's period; API).