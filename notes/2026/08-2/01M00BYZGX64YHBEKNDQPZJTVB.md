---
id: 01M00BYZGX64YHBEKNDQPZJTVB
created: 2026-08-14T14:49:04.797126Z
updated: 2026-08-14T14:49:48.433868Z
type: task
title: searching the tag cloud finds tags outside the 200 shown
project: 01KX671DATY39VW6GWK3M2T3DN
number: 718
sprint: svc641e
assignee: steve
label:
- bug
priority: high
task_status: backlog
tech: null
---
The cloud's search box narrows only what was already fetched. `useTagCloud` deliberately keeps `q` out of the react-query key and the filter runs in the browser (`app/frontend/src/pages/TagCloudPage.tsx:59-61, 118`). The stated reason is sound — re-fetching would rebase the heat scale against the filtered subset as you type — but the consequence is not: with the pool truncated to 200 of 2,279, typing the name of a tag that exists on 64 entities returns **"No tag matches that filter."**

That is a wrong answer, not a truncated one. A tag you can name should always be findable.

Real case: `mp-geo:uk` and `mp-geo:us`, 32 entities each, both present in the pool, neither an alias, neither dead. Searching "mp-geo" on the Tags screen finds nothing.

**Add a server-side search.** A `q` param on `GET /api/v1/tags/cloud` matching `key` and `value` (case-insensitive, substring), applied inside `_CLOUD_SQL` before the `LIMIT` so a match outside the hottest 200 is still returned.

Keep the heat scale stable: `max_alert_count` must stay the denominator from the *unfiltered* cloud for the current window and system filter, not the max of the search results — otherwise the first matching tag always renders as the hottest thing in the estate. Return it independently of the filtered rows rather than deriving it from `items`.

Debounce the box once it re-fetches (the current comment explaining why it is undebounced stops being true). The empty state needs to distinguish "nothing in the estate matches" from "nothing on this screen matches".

**Done when:** typing `mp-geo` on the Tags screen finds both tags and they click through to their drilldowns, regardless of window or sort.