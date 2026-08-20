---
id: 01M0FHC3YE2WWMRGFADGJA0J93
created: 2026-08-20T12:12:14.67019Z
updated: 2026-08-20T12:12:59.087075Z
type: task
title: Refresh the Graph token mid-crawl instead of once per pass
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 313
sprint: s5yxs5a
assignee: steve
label:
- bug
priority: high
task_status: todo
---
`sync_directory` acquires one token at pass start (120s expiry margin, `core/graph.py:_get_token`) but the crawl now runs ~27 minutes — a token valid at the start expires mid-crawl and a members GET 401s, killing the pass (seen 2026-08-20 11:23:56).

Re-resolve the token through the existing per-process cache before each request (cheap when fresh), size the margin to cover one page fetch, and on a 401 refresh the token once and retry the request.