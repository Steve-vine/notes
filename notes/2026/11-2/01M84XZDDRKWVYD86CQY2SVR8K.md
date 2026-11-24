---
id: 01M84XZDDRKWVYD86CQY2SVR8K
created: 2026-11-23T19:26:25.720339Z
updated: 2026-11-24T05:32:05.042374Z
type: task
title: 'Restore option 3, part 1: open a copy beside live Compass, read-only, and see for each record whether it is missing, changed or the same'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2121
sprint: szwetpq
blocked_by:
- 01M84XYDAWZQWZPVAJZXP43KNA
comments:
- id: 01M860MCW5BVKCAEWGSTRH6MHX
  author: Steve Vine
  at: 2026-11-24T05:32:04.869525Z
  text: |-
    Merged: #2116, f3487e70c, 24 Nov 05:31 GMT. Migration 0908_opened_copies. Not on staging yet: the sprint deploys together. ADR 0173 (opening a copy to compare) is Proposed, for Steve to read.

    Built: Restore ▸ Open to compare. An Admin opens a copy beside live Compass, read-only, with nothing going offline. They browse Content, Controls, Assessments, Gaps, Risks, Decisions, Vendors, Inventory, Registers and evidence details, seeing each record as Missing, Changed or Same, with changes side by side. The copy closes itself after 24 hours, and only one is open at a time.

    What's never loaded: people, roles, access requests, tokens, credentials, settings and logs. For a copy at today's version they're skipped as it's read, so they never reach the database. An older copy has to load whole to be brought up to date, and everything outside the list is dropped before it can be read.

    Decisions made in the build:
    - Evidence from incidents, data subject requests and contracts is left out, because who may see it depends on records that aren't in the copy.
    - A full restore closes an open copy rather than being blocked by it, so a forgotten comparison never stops an emergency restore.
    - Compass can't see the database's free disk, so the dialog shows the estimated need. A deployment can set a limit that refuses an open that won't fit.
    - Opening and closing are recorded in the activity log. Opening asks for no reason.
    - The backup worker now updates by stopping before starting, so two never overlap.

    Tested: 48 opened-copy tests plus the restore, Keep audit logs, recovery, hold and maintenance suites (303 in all) on real Postgres with Compass's real permission shape. Writes are refused on both sides, live data is unchanged by opening and closing, and a restricted register stays hidden from someone who isn't the Admin. An independent review found 11 issues and 10 were fixed. The 11th, two backup workers overlapping during an update, was fixed by the stop-first update.

    Couldn't check yet: the screen in a browser, and a production-sized database.

    For the release: free database disk for about one more copy of those areas while a copy is open.
assignee: steve
label:
- feature
priority: medium
task_status: review
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