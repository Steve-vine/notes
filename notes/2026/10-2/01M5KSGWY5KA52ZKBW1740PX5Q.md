---
id: 01M5KSGWY5KA52ZKBW1740PX5Q
created: 2026-10-23T07:10:06.789759Z
updated: 2026-10-28T13:05:09.514316Z
type: task
title: The trust centre's visitor dates take "today" from UTC, so just after UK midnight a manager can be told today's date is in the past
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1269
assignee: steve
label:
- bug
priority: low
task_status: active
---
Found 2026-10-22 while fixing COM-1243. Same family as COM-1243 / COM-1267, but in the app, not a test.

**Chain:** independent (no migration, no API change)

## What happens

While British Summer Time is in force, between midnight and 01:00 UK time the trust centre's visitor screens still think it's yesterday (in winter UK time and UTC agree, so it doesn't happen):
- choosing "Access until" today (or the earliest allowed day) can be refused as being in the past;
- a new visitor's default access ("today + N days") lands a day early;
- anything else that uses the visitor module's "today" is a day behind.

## Why (technical)

`core/trust_centre_visitors.py` `today()` returns `datetime.now(UTC).date()`; every other "today" in Compass is the UK day since ADR 0121 (`core/time_zones.py`, as `core/trust_centre_documents.today()` already does via `local_today()`). Its uses: the default `access_until` (`today() + default_link_days`), the access-until validation, and the expiry checks.

## Fix

Make `today()` the deployment's day (`local_today()` / `time_zones.today_in(deployment_zone())`). Check the visitor tests with the clock at 23:30 UTC (time-machine), as COM-1243 did; `test_trust_centre_visitors.py` uses `today()` heavily.

**Done when:** at 23:30 UTC in summer (00:30 BST) a visitor's access can be set to the UK today, and the default access period counts from the UK day; the visitor tests pass at 23:30 UTC and at the real time.