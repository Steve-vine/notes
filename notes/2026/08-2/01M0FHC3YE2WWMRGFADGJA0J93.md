---
id: 01M0FHC3YE2WWMRGFADGJA0J93
created: 2026-08-20T12:12:14.67019Z
updated: 2026-08-25T18:42:59.924581Z
type: task
title: Refresh the Graph token mid-crawl instead of once per pass
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 313
sprint: s5yxs5a
comments:
- id: 01M0FRV9WQRPQ7M5FEM4S4GCD5
  author: Steve Vine
  at: 2026-08-20T14:22:52.311481Z
  text: |-
    Implemented in PR #307 (feature/com-313-token-refresh, stacked on #306) — CI green.

    graph_get_all now accepts a TokenSource that re-resolves the bearer through the per-process cache before every page (login only near expiry); a 401 that slips through refreshes once and retries that page. Expiry margin 120s→150s, sized to cover one full page fetch. sync_directory passes a TokenSource. Unit tests for the refresh/no-refresh paths plus an integration test where the FakeTenant expires all tokens mid-crawl and the pass completes with exactly one re-login.
assignee: steve
company: null
label:
- bug
priority: high
task_status: done
---
`sync_directory` acquires one token at pass start (120s expiry margin, `core/graph.py:_get_token`) but the crawl now runs ~27 minutes — a token valid at the start expires mid-crawl and a members GET 401s, killing the pass (seen 2026-08-20 11:23:56).

Re-resolve the token through the existing per-process cache before each request (cheap when fresh), size the margin to cover one page fetch, and on a 401 refresh the token once and retry the request.