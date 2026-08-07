---
id: 01KZDRNXAD164609BQ978B0QAG
created: 2026-08-07T09:25:44.909784Z
updated: 2026-08-07T09:25:44.909784Z
type: task
title: Assist thread search + pagination — sidebar past 100 threads
assignee: steve
task_status: backlog
priority: medium
project: 01KX671DATY39VW6GWK3M2T3DN
number: 604
---
`GET /threads` is a bare `.limit(100)` newest-first — no search, no paging; older threads silently vanish from the sidebar.

- Search: filter param matching thread title and message content (Postgres FTS or ILIKE — follow the events-FTS pattern from mig 0073 if FTS); owner-scoped as ever.
- Pagination: keyset paging (created_at + id tiebreak, the established DESC pattern) with an explicit "has more" so nothing silently truncates.
- Messages endpoint: paginate long transcripts (load latest page, fetch older on scroll-up) — keeps the citation re-resolution behaviour per page.
- Sidebar: search box + infinite scroll / load-more.

Screen: AssistPage sidebar. Pairs with thread titles (ISE-600) — search over "New conversation" ×100 would be pointless.