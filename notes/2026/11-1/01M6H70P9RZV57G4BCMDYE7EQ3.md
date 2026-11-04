---
id: 01M6H70P9RZV57G4BCMDYE7EQ3
created: 2026-11-03T17:23:54.296199Z
updated: 2026-11-04T07:45:34.038208Z
type: task
title: The feed filters by Published and Updated separately, each with a custom date range
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1544
sprint: s6xh9g1
comments:
- id: 01M6HF9RG01V1NJJR8R6X0K6YH
  author: Steve Vine
  at: 2026-11-03T19:48:40.064621Z
  text: |-
    Done (PR #1563, merged 2026-11-03). Not on staging yet.

    What people see now: "Date is" is gone. Security Feed ▸ Feed has two date filters side by side, Published and Updated, each with Any time, Last 24 hours, Last 7 days, Last 30 days, Last 12 months and Custom range. Custom range shows From and To date boxes; either end may be left open; dates are whole days in your time zone and the To day is included. With both set, an item must meet both (e.g. published in the last 12 months and updated in the last 7 days). Both go in the web address; Clear filters resets them; Mark all read and the CSV follow them. An old link like ?since=7d&date=published opens as Published "Last 7 days". "Updated" is the item's own date (COM-1538), not when Compass first saw it. Polaris's search keeps working on the older date filter, unchanged.

    Verified: server tests for a published range, both filters together and the old parameters; tests for day boundaries in the reader's zone and old links; screen tests for both filters in the address and Clear. Not yet tried in a browser — how the date boxes sit in the filter bar is worth a look.

    To check on staging: Published → Custom range 1–15 Oct; then Updated → Last 7 days with Published → Last 12 months; reload to see both kept.
assignee: steve
label:
- improvement
priority: medium
---
Asked for by Steve testing sprint 102 on staging (2026-11-03).

## Today

Security Feed ▸ Feed has one date filter (Any time, Last 24 hours, Last 7 days, Last 30 days, Last 12 months) and a "Date is" picker that says whether it applies to the published or the updated date. There's no way to choose a date range, or to filter on both dates at once.

## What people see

- The "Date is" picker is gone.
- Two date filters sit side by side: **Published** and **Updated**.
- Each offers: Any time, Last 24 hours, Last 7 days, Last 30 days, Last 12 months, **Custom range**.
- Choosing Custom range opens a from–to date picker. Either end may be left open ("from 1 Oct", "up to 15 Oct"). Dates are whole days in the reader's time zone, and the "to" day is included.
- When both are set, an item must meet both (e.g. published in the last 12 months *and* updated in the last 7 days).
- Both filters, including custom ranges, are in the web address like every other filter. Clear filters resets both, and "Mark all read" honours them.

**Technical:**
- The API already takes `since`, `date_field`, `date_from` and `date_to`, but against one date only. It needs separate published and updated params (e.g. `published_since`/`published_from`/`published_to` and `updated_…`).
- Updated means `item_updated_at()`, the item's own date (COM-1538), not when Compass first saw it.
- Keep the old `since`/`date_field` working for saved links, Polaris's search tool and the watch list counts, or move them over. Check `security_feed_search`'s date arguments while there.
- **Chain:** on the chain (changes the API, so schema.d.ts regenerates).

**Done when:** on staging, Published "Custom range" 1–15 Oct shows only items published in those days; Updated "Last 7 days" together with Published "Last 12 months" shows the intersection; the address bar round-trips both; "Date is" is gone; and an old link with `?since=7d&date=published` still works.