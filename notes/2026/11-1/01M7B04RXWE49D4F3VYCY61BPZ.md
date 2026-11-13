---
id: 01M7B04RXWE49D4F3VYCY61BPZ
created: 2026-11-13T17:44:03.260783Z
updated: 2026-11-13T23:02:20.937626Z
type: task
title: 'A collected check''s capture covers its own period: a weekly check collects last week, and the captures build up into a history'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1799
sprint: spsp226
comments:
- id: 01M7B7SBVJTH4J6KRA1FMQD300
  author: Steve Vine
  at: 2026-11-13T19:57:38.03428Z
  text: |-
    Built — PR #1794 (feature/com-1799-capture-period). On the chain: migration 0838 (a capture's period) and API changes. New ADR 0153 (a capture has a period), ADR 0142 amended, CLAUDE.md lists 0153. COM-1800 (#1795) and COM-1801 (#1797) are stacked on it; I merge the three in order.

    What you'll see:
    - A collected check is either **records** (changes, tickets, sign-ins…) or a **snapshot** (how something is set up). The approval card says "Collects each week's changes, by created date" or "A snapshot of how it's set up".
    - A records check collects only its own period each run: yesterday (daily), the 7 days since its last period ended (weekly), or the last calendar month (monthly). Its first run collects only its first period, not history.
    - Each period's capture is its own entry, with its period, in the check's history and in the Evidence register; a new week doesn't replace last week. Missed periods are caught up one capture each.
    - A snapshot check works as before.
    - Held for review no longer holds a period's capture for its size or for being empty — only for fields appearing or going missing. A later held week no longer discards an earlier held one.
    - Collect now on a records check with nothing due says so, and when the next period will be collected.

    Choices:
    - The period uses the service's own "since" setting (from COM-1793) plus an optional "to"; then Compass keeps only items whose date falls in the period, for every read. Nothing service-specific.
    - Periods are whole days in UTC.
    - One run catches up at most 31 missed periods; the rest follow on the next hourly run.
    - Items with no readable date are left out; if no item has one, the check is Broken and nothing is kept. Polaris won't offer a records check without a usable date field.
    - **A check switched off and back on catches up the periods it missed while off.** Say if you'd rather it skipped them.
    - Existing live checks stay snapshots until recreated through Polaris.

    For you to check with FreshService (tests use a fake service): a recreated CHM.1 or CHM.7 proposes records by created date; its first weekly capture holds only last week's changes.

    Checks: ruff/mypy clean, unit 2241 passed, integration (new records-period tests incl. catch-up and the hold rule, plus collected checks, hold, audit, revalidate, design budget, Polaris), period arithmetic unit tests, no-service-names test, full vitest, drift clean. CI green.
- id: 01M7BJBK09BYB8M5YBEQGWSF78
  author: Steve Vine
  at: 2026-11-13T23:02:20.937428Z
  text: |-
    Pre-UAT: Couldn't check most of this. Only the snapshot side could be seen (staging build 2f72416b, E2E Test Company, as E2E Admin A).

    A records check needs a Collection integration account and Polaris to design it. E2E Test Company has neither (every Collection account on staging belongs to "Test Company"), so no weekly records check can be made here.

    What I could see:
    - The existing ACC.13 check is labelled as a snapshot. Its details say "A snapshot of how it's set up · … · Weekly", and its 5 earlier captures each read "as at 6 Nov 2026". It still works as before: no period, filed and downloadable.
    - On Checks ▸ Review the cards of the older proposals (New checks and Changes) say "A snapshot of how it's set up" above the reads.
    - ADR 0153 "a capture has a period" is in the repo and listed in CLAUDE.md.

    Couldn't check — Steve, on Moneypenny, once CHM.1 / CHM.7 are recreated through Polaris:
    - Polaris proposes "records" with a date field, and the approval card says "Collects each week's changes, by created date".
    - The first weekly capture holds only last week's changes, and its history row reads "6–12 Nov 2026".
    - Each later week is its own capture, in the check's history and in the Evidence register.
    - Collect now with nothing due says when the next period will be collected.
    - A quiet week (fewer or no items) is not held for review.
    - Missed weeks are caught up one capture each.

    Screenshots: ~/compass-uat/spsp226/COM-1801/ (history) and COM-1795/ (review cards)
assignee: steve
label:
- feature
priority: high
task_status: review
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