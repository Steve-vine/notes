---
id: 01M5Y6NRC396D9N5S4NS8RABFB
created: 2026-10-27T08:12:21.763103Z
updated: 2026-10-27T08:28:23.596182Z
type: task
title: 'Compliance page: hovering a chart crashes the page ("This part of the page couldn''t be shown")'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1346
sprint: s4zhkvy
comments:
- id: 01M5Y7K3M4TADMAZEK0XMEV08G
  author: Steve Vine
  at: 2026-10-27T08:28:23.556464Z
  text: |-
    Done — PR #1362 merged (97d79152). Main's build is green. Not yet on staging.

    What changed: hovering a chart can no longer take the page down. If the hover label is handed a date it can't read, it shows "—" instead. The fix is in the shared date formatting, so it covers every chart (Compliance and System Status) and every date shown in Compass.

    To smoke-test once it's on staging: on Compliance, move the mouse across each chart, including the edges and the gaps between points. The page stays up.
assignee: steve
label:
- bug
priority: high
task_status: review
---
## What Steve saw (2026-10-27)

On Compliance (the old Timeline), the page shows "This part of the page couldn't be shown". Staging logged this twice at 08:10 GMT on /compliance: `RangeError: Invalid time value`, thrown from a chart tooltip's `labelFormatter`.

## Cause

The chart's hover label is sometimes asked to format a missing date (`Number(undefined)` gives NaN). The shared `toInstant` (time/format.ts) turns any number into a `Date` without checking it, so NaN becomes an Invalid Date. `Intl.DateTimeFormat.formatToParts` then throws. Every formatter in Compass (`formatDate`, `formatTime`, `formatDateTime`, `dateIn`) shares this path, so a stray value crashes the page instead of showing "—". The bug dates from COM-1184/1185, when the charts moved to the reader's date format.

## Behaviour

- Hovering any chart never crashes the page.
- A date that can't be read shows as "—", as text dates already do.

## Build

- `toInstant`: a number that isn't a valid time (NaN, Infinity, or out of range) gives null.
- Add a unit test in time/format.test.ts.