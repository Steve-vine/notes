---
id: 01KZ2772Z9D2VGNCBJ83KQ0F0V
created: 2026-08-02T21:48:54.633313Z
updated: 2026-08-02T21:48:54.633313Z
type: task
title: 'Estate: paginate the entity list, with a count and page-size picker on the filter row'
priority: medium
task_status: backlog
label: improvement
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 494
---
The Estate list renders every entity it is given, and `GET /api/v1/entities` has no `limit`/`offset` — it returns the **whole estate** on every load and every filter change. Add pagination, and tell the operator what they are looking at.

## What to build

**1. Count + page size on the filter row, right-aligned.** Same row as "Search by name" and the Filters toggle. This is exactly what `FilterPanel`'s `action` slot is for (ISE-478) — it is right-aligned already and currently unused on this screen, so nothing needs restructuring.

- **"Showing X of Y entities"** — how many rows are on screen, against the number the query matches.
- **Page-size dropdown** to its right: **50 / 100 / 200 / 300 / 400 / 500**.

**2. Page controls below the table**, following the existing convention — `EventsPage.tsx` already does this with Mantine `Pagination` over an API `total`. Reuse that shape rather than inventing a second one.

## Backend

`GET /api/v1/entities` needs `limit` and `offset`, and `EntityList` needs a `total`. The count must be taken **after the filters and before the page slice** — a total that ignores the filters would make "Showing 50 of 12,000" a lie the moment anyone types in the search box. Regenerate API types (`uv run python -m ISE_api.dump_openapi` + `npm run generate:api`).

Cap `limit` server-side the way the other list endpoints do (`min(limit, _MAX_LIMIT)`), so 500 is the UI's largest offer rather than the API's only defence.

## Decisions I would make unless told otherwise

- **"of Y" means matching, not estate-wide.** With filters on, the denominator is the number of rows the current query matches — the population the pager actually moves through. A whole-estate denominator would leave "Showing 50 of 12,000" sitting above a 3-page result.
- **Default page size 100**, remembered per screen in `usePersistedState` like the rest of the Estate filter state. Today's behaviour is unbounded, so any default changes what people see on first load — 100 keeps the screen useful without shipping the estate down the wire.
- **Changing any filter resets to page 1.** Otherwise a narrowing search strands the operator on an empty page 7 of a 2-page result.

## Why it matters

This is the screen that lists everything ISE knows about. It is the one most likely to be slow on a real estate, and the one where "am I seeing all of it?" is a question the UI currently cannot answer — there is no count anywhere on it.

Builds on the filter row from [[ISE-482]] / ISE-478.

## Acceptance

- The list pages, and the page size can be set from the dropdown.
- The count reflects the active filters and updates as they change.
- Changing a filter returns to page 1.
- The API no longer returns the whole estate for a single screenful.