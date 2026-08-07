---
id: 01KZDRNXAD164609BQ978B0QAG
created: 2026-08-07T09:25:44.909784Z
updated: 2026-08-07T16:39:50.940138Z
type: task
title: Assist thread search + pagination — sidebar past 100 threads
project: 01KX671DATY39VW6GWK3M2T3DN
number: 604
sprint: snk16ew
comments:
- id: 01KZEHGMH05ZV700RMNGJ3QBVM
  author: Steve Vine
  at: 2026-08-07T16:39:46.464023Z
  text: |-
    Done — PR #525 (feature/ise-604-assist-thread-search).

    API: `q` search (thread title OR the text of any turn in it), keyset paging with cursor + has_more + next_cursor, filter-aware `total` on every page. Messages page BACKWARDS from the newest turn, citations re-resolved per page.

    Decisions:
    - ILIKE, not FTS. The search runs inside one owner's own threads — a few hundred rows, not a corpus — and FTS would cost a migration plus a second tsvector to keep in step for a set that small. Revisit only if a tenant's thread count makes it matter.
    - Keyset, not offset: a conversation started mid-paging shifts every offset by one and shows a row twice or not at all.
    - A malformed cursor is a 422, never a silent first page. Ignoring it would make a CLIENT bug look like a server that keeps handing back the top of the list — an infinite scroll that never advances and never errors.

    BUG FOUND WHILE BUILDING IT, worth remembering: THE TRANSCRIPT HAD NO TOTAL ORDER. `created_at` is server_default=now(), which in Postgres is the TRANSACTION timestamp, and stream_chat writes the question and its answer in ONE transaction — so the pair always shared a created_at to the microsecond and their relative order was whatever the planner felt like. An answer could render ABOVE its own question, and had been able to all along; nobody noticed because the whole conversation came back in one unpaged list. A page boundary across that tie could also drop or duplicate a row. Fixed with a rank that puts question before answer — not a heuristic, since ties can only occur INSIDE one turn (every later turn is a later request, hence a later transaction).

    UI: sidebar search box (debounced 200ms like the global palette) + "Load more (N of M)" — the count is there because the original bug was silence. Older turns behind an explicit "Load earlier messages", NOT scroll-triggered: the viewport already has two competing scroll behaviours (tail-follow + ISE-558's question anchor) and a third that prepends content while they run fights them for scroll position.

    SECOND TRAP: putting the search term in the react-query key made every keystroke re-enter isLoading, which blanked the whole page — including the search box being typed into. Fixed with placeholderData keeping the previous page. Caught by the new tests, not by inspection.

    Tests: 8 backend (seam crossed twice with no repeat/omission, total follows the filter, found by title, found by what was SAID, no-match is empty not everything, malformed cursor refused, tail-then-walk-back, short transcript whole) + 5 frontend (the off-screen count; the filter reaches the SERVER — a client-side filter over the loaded page would search 30 of 400 and look like it worked; "no conversations match" vs "no conversations yet" are different facts; clear restores; transcript tail-then-earlier).

    API types regenerated. Backend suite + ruff + mypy strict green; frontend 673/673 + tsc + eslint + prettier green.
assignee: steve
label: null
priority: medium
task_status: review
---
`GET /threads` is a bare `.limit(100)` newest-first — no search, no paging; older threads silently vanish from the sidebar.

- Search: filter param matching thread title and message content (Postgres FTS or ILIKE — follow the events-FTS pattern from mig 0073 if FTS); owner-scoped as ever.
- Pagination: keyset paging (created_at + id tiebreak, the established DESC pattern) with an explicit "has more" so nothing silently truncates.
- Messages endpoint: paginate long transcripts (load latest page, fetch older on scroll-up) — keeps the citation re-resolution behaviour per page.
- Sidebar: search box + infinite scroll / load-more.

Screen: AssistPage sidebar. Pairs with thread titles (ISE-600) — search over "New conversation" ×100 would be pointless.