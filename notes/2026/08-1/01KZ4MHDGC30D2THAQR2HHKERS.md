---
id: 01KZ4MHDGC30D2THAQR2HHKERS
created: 2026-08-03T20:20:13.452952Z
updated: 2026-08-03T20:20:18.167199Z
type: task
title: Estate Explorer search silently discards every match past the 20th
project: 01KX671DATY39VW6GWK3M2T3DN
number: 523
sprint: skxht3g
assignee: steve
label:
- bug
priority: medium
task_status: backlog
---
Reported from functional testing: the Estate Explorer search box only shows 20 results.

## The dropdown is already scrollable — that is not the bug

`EstateExplorerPage.tsx:79-95` already sets `maxHeight: 360` + `overflowY: 'auto'`, with the comment *"Cap the dropdown and scroll the overflow (ISE-268): 20 results must not run off the bottom of the viewport."* Scrolling works today.

The actual cause is one line above it:

```ts
// EstateExplorerPage.tsx:50
const results = (matches?.items ?? []).slice(0, 20)
```

Results 21+ are **thrown away client-side**. No amount of scrolling can reveal them, because they were never rendered. The comment on line 49 — *"the dropdown scrolls past what fits"* — describes the intent the slice contradicts.

## The server is not the constraint

`GET /api/v1/entities` returns **every** match. `limit` is opt-in and defaults to `None` (`api/v1/entities.py:673`), and the docstring calls this out explicitly:

> `limit` is deliberately **opt-in**: three other callers (the Dashboards group picker, **the Explorer search**, the relationship search) read this endpoint expecting every match, and a default page size would silently truncate them — a group missing from a dropdown is not a bug anyone reports, it is one they work around.

The backend was built to serve exactly this case. The frontend then truncated it anyway.

## Same bug, second site

`RelationshipsCard.tsx:252` does `.slice(0, 8)` on the same endpoint — that is the "relationship search" the docstring names. Identical fix, tighter cap. Fold it into this task rather than leaving a known twin.

## Proposed fix

Deleting the slice is the one-line version, but an unbounded dropdown renders one `Button` per match into the DOM, and a 2-character query against a large estate could return thousands. Better, and barely more work:

1. Pass an explicit `limit` (100?) to the query.
2. Use the `total` the endpoint already returns — computed **before** the slice, precisely for this — to render a footer line: *"showing 100 of 347 — refine your search"*.
3. Keep the existing `maxHeight` + `overflowY` so the 100 scroll.

That turns silent truncation into visible truncation, which is the actual defect: an operator currently has no way to know the thing they searched for exists but sits at position 21.

## Definition of done

Searching the Estate Explorer for a term matching more than 20 entities lets the operator scroll to any of them, and — where a cap still applies — the UI says so instead of silently dropping matches. Same for the relationship search on the entity detail page.

## Testing note

Whatever cap lands, assert on **what the operator can reach**, not on the array length — the ISE-515 lesson. A test that checks `results.length === 100` passes happily while the 101st match is invisible with no indication it exists.
