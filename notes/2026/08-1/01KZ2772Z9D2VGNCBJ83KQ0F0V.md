---
id: 01KZ2772Z9D2VGNCBJ83KQ0F0V
created: 2026-08-02T21:48:54.633313Z
updated: 2026-08-05T12:33:43.360152Z
type: task
title: 'Estate: paginate the entity list, with a count and page-size picker on the filter row'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 494
sprint: sfv5yw0
comments:
- id: 01KZ2966HYH9HVXPBFTPAEGPH2
  author: Steve Vine
  at: 2026-08-02T22:23:22.685969Z
  text: |-
    Done — PR #433, merged to staging, staging CI green and deployed.

    Filter row carries "Showing 50 of 3,240 entities" right-aligned in FilterPanel's action slot with the page-size picker beside it (50/100/200/300/400/500, default 50, remembered). Strip below the table says "Showing records 51-100 of 3,240" alongside Mantine Pagination, following the EventsPage convention.

    ONE DESIGN CALL WORTH YOUR REVIEW: `limit` is opt-in on the API rather than defaulted. Three other callers read GET /api/v1/entities expecting every match — the Dashboards group picker, the Explorer search, the relationship search — and a default page size would have silently truncated all three. A group missing from a dropdown is not a bug anyone reports, it is one they work around. So they stay unbounded and only Estate pages; explicit limits are capped at 500.

    Two things I had to get right that were not in the ticket:

    Paging orders by created_at with `id` as a tiebreak. A sync discovers a whole fleet in one transaction, so created_at alone is not unique — without a stable second key an entity could appear on two pages or on neither. There is a backend test asserting consecutive pages are disjoint and together cover the set.

    Page-size changes deliberately do NOT reset to page 1 (as agreed) — the first record on screen stays on screen. That maths lives in lib/paging.ts with its own tests, because jsdom cannot lay out the Mantine dropdown that drives it; the page test seeds the persisted size instead, which is how this repo already handles comboboxes.

    Backend tests cover: total ignores the slice but tracks the filters, disjoint pages, reading past the end returns empty rather than erroring, the 500 cap, and limit=0 / offset=-1 being refused with 422 rather than silently coerced.
assignee: steve
label: null
priority: medium
task_status: done
---
The Estate list renders every entity it is given, and `GET /api/v1/entities` has no `limit`/`offset` — it returns the **whole estate** on every load and every filter change. Add pagination, and tell the operator what they are looking at.

## What to build

**1. Count + page size on the filter row, right-aligned.** Same row as "Search by name" and the Filters toggle. This is exactly what `FilterPanel`'s `action` slot is for (ISE-478) — it is right-aligned already and currently unused on this screen, so nothing needs restructuring.

- **"Showing X of Y entities"** — X is how many rows are on screen, Y is **how many records can be paged through under the current filter**. So Y moves as filters change; it is not a fixed estate-wide constant.
- **Page-size dropdown** to its right: **50 / 100 / 200 / 300 / 400 / 500**.

**2. Pagination strip below the table**, following the existing convention — `EventsPage.tsx` already does this with Mantine `Pagination` over an API `total`. Reuse that shape rather than inventing a second one.

The strip also carries a **record range**: "Showing records X-Y of Z" — e.g. `Showing records 51-100 of 3,240`. Same Z as the row count above; the range is what tells you where you are in the set rather than just how much of it you can see.

## Behaviour

- **Default page size 50**, remembered per screen in `usePersistedState` like the rest of the Estate filter state.
- **Any filter change resets to page 1** — otherwise a narrowing search strands the operator on an empty page 7 of a 2-page result. That includes the debounced name and tag boxes, not just the dropdowns.
- Changing page size should keep the operator near where they were rather than always snapping to page 1 — going 50 → 100 while on page 4 should land around the same records, not at the top. (If that proves fiddly, page 1 is an acceptable fallback; say so in the PR rather than doing it silently.)

## Backend

`GET /api/v1/entities` needs `limit` and `offset`, and `EntityList` needs a `total`. The count must be taken **after the filters and before the page slice** — that is what makes Y and Z mean "records I can page through right now" rather than a number that contradicts the pager sitting under it. Regenerate API types (`uv run python -m ISE_api.dump_openapi` + `npm run generate:api`).

Cap `limit` server-side the way the other list endpoints do (`min(limit, _MAX_LIMIT)`), so 500 is the UI's largest offer rather than the API's only defence.

## Why it matters

This is the screen that lists everything ISE knows about. It is the one most likely to be slow on a real estate, and the one where "am I seeing all of it?" is a question the UI currently cannot answer — there is no count anywhere on it.

Builds on the filter row from [[ISE-482]] / ISE-478.

## Acceptance

- The list pages, and the page size can be set from the dropdown (default 50).
- "Showing X of Y entities" sits right-aligned on the filter row; "Showing records X-Y of Z" sits on the pagination strip below the table.
- Both counts reflect the active filters and update as they change.
- Changing any filter returns to page 1.
- The API no longer returns the whole estate for a single screenful.