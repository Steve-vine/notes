---
id: 01M00BYMSEQ2KD84XTGYTEW7ZV
created: 2026-08-14T14:48:53.806177Z
updated: 2026-08-14T16:54:16.932273Z
type: task
title: the tag cloud sorts by entity count or alert count
project: 01KX671DATY39VW6GWK3M2T3DN
number: 717
sprint: svc641e
assignee: steve
label:
- feature
priority: high
task_status: todo
tech: null
---
Add a **Sort by** control to the tag cloud's `FilterPanel`, alongside Window and Integration: **Alert count** (today's behaviour, the default) or **Entity count**.

**This must be a server-side parameter, not a client-side reorder.** The cloud is capped at `CLOUD_LIMIT = 200` (`app/backend/src/ISE_api/api/v1/tags_api.py:53`) and the cap is applied by the SQL `ORDER BY` — so the sort chooses *which 200 tags come back*, not merely the order of a fixed set. Sorting in the browser would reshuffle the same 200 and leave every tag the current ordering excluded still invisible, which is exactly the bug that hid `mp-geo` (see the truncation task).

Backend: add a `sort` query param (`alerts` | `entities`) to `GET /api/v1/tags/cloud`, switching the `ORDER BY` in `_CLOUD_SQL` between:

- `alert_count DESC, entity_count DESC, t.key, t.value`  (alerts — current)
- `entity_count DESC, alert_count DESC, t.key, t.value`  (entities)

Keep the key/value tiebreak in both so paging and truncation stay deterministic. Regenerate the API types after the OpenAPI change (`uv run python -m ISE_api.dump_openapi` + `npm run generate:api`).

Frontend: `sort` joins `window` and `system_ids` in the `Filters` type and MUST be part of the react-query key in `useTagCloud` — unlike `q`, this one re-fetches. Persist it with the rest of the filter state (`filters:tag-cloud:v1`; bump the key if the shape change breaks stored state). Add it to `activeCount` only when it differs from the default, matching how `window` is handled. Carry it into the drilldown link alongside `window`/`system_id`.

Note `max_alert_count` is computed from the returned items, so under an entity sort the heat denominator is drawn from a different 200 — the colour scale rebases. That is correct (the scale describes what is on screen) but worth an explicit test.

**Done when:** switching to Entity count brings `mp-geo:uk` and `mp-geo:us` (32 entities each, 0 alerts) into view, on the 7d default window, where they are currently ranked 220 and 221 and never returned.