---
id: 01M00BYMSEQ2KD84XTGYTEW7ZV
created: 2026-08-14T14:48:53.806177Z
updated: 2026-08-14T20:05:29.156119Z
type: task
title: the tag cloud sorts by entity count or alert count
project: 01KX671DATY39VW6GWK3M2T3DN
number: 717
sprint: svc641e
comments:
- id: 01M00NG3P9XP6XVM2QH628GMNX
  author: Steve Vine
  at: 2026-08-14T17:35:43.30531Z
  text: |-
    Built and merged — PR #666, released to main 2026-08-14.

    Server-side `sort` (`alerts` | `entities`) switching two literal `ORDER BY` clauses, both keeping the `t.key, t.value` tiebreak. `sort` is a key into a fixed dict and the query param is pattern-bound to that same key set, so no operator text reaches the SQL — a bind parameter cannot express an `ORDER BY`.

    Frontend: in the react-query key (unlike `q` at the time), persisted, counted in `activeCount` only when non-default, carried into the drilldown link.

    Two things beyond the task:

    1. **The truncation badge had to become sort-aware.** Under an entity sort "Showing the 200 hottest tags" is simply untrue, and the badge is exactly where an operator learns which control reaches what was dropped. (ISE-720 then rewrote it again, dropping the number now the true total is stated beside it.)
    2. **The rebase test needed `CLOUD_LIMIT` monkeypatched to 1** to be worth anything. With the real cap the two rankings return the same tags in a small fixture, so `max_alert_count` was trivially equal under both sorts and the assertion proved nothing. Patched down, the two sorts genuinely return different tags and the denominator visibly follows the survivors.

    No migration. `_CLOUD_SQL` became a `.format()` template on `{order_by}` only.
assignee: steve
label:
- feature
priority: high
task_status: done
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