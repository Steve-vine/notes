---
id: 01M00BYZGX64YHBEKNDQPZJTVB
created: 2026-08-14T14:49:04.797126Z
updated: 2026-08-14T18:08:24.880816Z
type: task
title: searching the tag cloud finds tags outside the 200 shown
project: 01KX671DATY39VW6GWK3M2T3DN
number: 718
sprint: svc641e
comments:
- id: 01M00QBTG7X4V4B8SBEAD0HJN5
  author: Steve Vine
  at: 2026-08-14T18:08:19.975392Z
  text: |-
    Built and merged — PR #667, released to main 2026-08-14.

    `q` is a server parameter now: case-insensitive substring on the tag's label, applied to the whole RANKED pool. The shape that matters is a `ranked` CTE — the ranking happens once over the pool and the search filters its rows, so a match outside the hottest 200 still comes back. Filter-then-rank would only ever have searched the 200 that came back, which is the bug.

    Three things worth recording:

    1. **The original objection was answered, not accepted.** The reason `q` was client-side ("re-fetching would rebase the heat scale") was sound. Both denominators are now computed server-side from the top of the ranking BEFORE `q` is applied, returned on every row via scalar subqueries. `max_entity_count` was added alongside `max_alert_count` — ISE-716 derived the size denominator client-side from `items`, and a server-side search makes `items` the filtered set, so the size channel had the identical problem.
    2. **`%` and `_` had to be escaped.** A tag value is source-controlled text and so is a search term; `capacity:50%` exists in the estate and must find one tag, not all of them. Postgres takes `\` as the default LIKE escape, so no ESCAPE clause was needed. Pinned by a test asserting `q="%"` returns exactly the one tag whose value contains a percent sign.
    3. **Clear had to empty the box's own state.** The debounce keeps the term in local state ahead of `filters.q`; without resetting both, the pending timer wrote the cleared term straight back in. Caught by a test, not by reading.

    An empty or whitespace-only term is no search at all, never a filter matching nothing. Perf unchanged — still one statement, and the realistic-pool timing test is green.
assignee: steve
label:
- bug
priority: high
task_status: review
tech: null
---
The cloud's search box narrows only what was already fetched. `useTagCloud` deliberately keeps `q` out of the react-query key and the filter runs in the browser (`app/frontend/src/pages/TagCloudPage.tsx:59-61, 118`). The stated reason is sound — re-fetching would rebase the heat scale against the filtered subset as you type — but the consequence is not: with the pool truncated to 200 of 2,279, typing the name of a tag that exists on 64 entities returns **"No tag matches that filter."**

That is a wrong answer, not a truncated one. A tag you can name should always be findable.

Real case: `mp-geo:uk` and `mp-geo:us`, 32 entities each, both present in the pool, neither an alias, neither dead. Searching "mp-geo" on the Tags screen finds nothing.

**Add a server-side search.** A `q` param on `GET /api/v1/tags/cloud` matching `key` and `value` (case-insensitive, substring), applied inside `_CLOUD_SQL` before the `LIMIT` so a match outside the hottest 200 is still returned.

Keep the heat scale stable: `max_alert_count` must stay the denominator from the *unfiltered* cloud for the current window and system filter, not the max of the search results — otherwise the first matching tag always renders as the hottest thing in the estate. Return it independently of the filtered rows rather than deriving it from `items`.

Debounce the box once it re-fetches (the current comment explaining why it is undebounced stops being true). The empty state needs to distinguish "nothing in the estate matches" from "nothing on this screen matches".

**Done when:** typing `mp-geo` on the Tags screen finds both tags and they click through to their drilldowns, regardless of window or sort.