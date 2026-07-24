---
id: 01KY4F24P5AN3FDYRE06723MAG
created: 2026-07-22T08:28:48.19765Z
updated: 2026-07-24T07:17:34.998827Z
type: task
title: Incidents sorting
project: 01KX671DATY39VW6GWK3M2T3DN
number: 208
sprint: sohzsw2
comments:
- id: 01KY4TA4V0RJWTR5SHWJSMMY7X
  author: Steve Vine
  at: 2026-07-22T11:45:24.832108Z
  text: |-
    Done — PR #191 (feature/ise-208-incidents-sorting), branched from main and independent of the other two.

    All nine columns are sortable asc/desc, remembered like the filters, defaulting to ID descending so new incidents stay at the top — as specified. Worth noting the ui-brief already promised a "filterable/**sortable** table" for this screen, so this is the unbuilt half of a stated capability rather than new scope.

    **Server-side, deliberately.** The list is paged at 100, so a client-side sort would only ever order the page it happened to be given. New `sort` + `dir` query params on `GET /api/v1/issues`, validated by regex at the edge — an unknown key is a 422 rather than a silently default-ordered list that hides the caller's bug. No other list endpoint in the app had a sort param, so this sets the convention.

    **The three columns that aren't simple columns:**
    - Severity and status sort by their **rung**, not their spelling — a SQL CASE over `ISSUE_SEVERITIES`/`ISSUE_STATUSES`. Alphabetical would put `critical` before `low`, which is worse than useless because it looks sorted.
    - System and assignee sort on the joined **name**, not the UUID an operator never sees.
    - Alert status is derived per row in `build_issue_reads`, not stored, so the derivation is rebuilt in SQL including the silenced-overrides-status rule (ISE-163).

    All three joins are LEFT — a manual incident has no signal, an unassigned one no user, and neither may drop out of the queue. Absences sort last.

    **Ties, which the task didn't mention but matter here.** Every sort now ends with `Issue.number` as a tiebreaker. Every column except ID is non-unique, and the queue is paged *and* polls every 15s, so without one an incident could appear on two pages or on neither. There's a test that pages a tied sort and asserts no row is served twice and none is missed. This also closes a latent version of the same bug — the old hardcoded `created_at DESC` had no tiebreaker either.

    **"Remember this setting like the filters" — done, but in its own key** (`sort:issues:v1`), not inside the `Filters` object. Ordering is not a filter: "Clear filters" means "show me everything again", not "put my columns back", and folding sort in would also have made the filters-are-active check say yes to a plain re-sort. Both behaviours are pinned by tests. Flagging it because it's a small departure from the literal "like the filters".

    **New shared `components/SortableTh.tsx`** — the first sortable table in the app, so it's a component rather than one screen's markup; Signals and Estate are the obvious next callers. Direction is carried by `aria-sort` on the cell rather than appended to the button's accessible name, which keeps every existing `getByRole('columnheader', {name})` query stable (`IssueAlertStatus.test.tsx` has one). A fresh column starts descending — severity, raised and ID all have their interesting end at the top.

    **No ADR.** ADR 0036 says "the queue keeps one ordering — newest first — and one row per incident", but its load-bearing decision is *children are listed flat, not nested*, and that's untouched: still flat, still one row per incident, still newest-first by default. Making the ordering user-chosen implements a stated brief rather than taking a new architectural decision. Calling it out since it does brush against that sentence.

    **Tests** — 10 backend integration (`test_issue_sorting.py`) covering default, reversal, severity-by-rung, title, raised, all 9 columns × 2 directions, 422s for bad key and bad direction, sort surviving filtering, tied paging, unassigned rows; 7 frontend (`IssueSorting.test.tsx`) covering the default request params, descending-first, flip-on-repeat-click, aria-sort tracking, all 9 headers being buttons, persistence across visits, and clear-filters leaving sort alone.

    Backend 849 passed, ruff + mypy strict clean; frontend 279 passed, lint/build clean; OpenAPI types regenerated.
assignee: steve
priority: medium
task_status: done
---
Allow the incident list screen to be sorted by each column (Ascending or descending).  Remember this setting like the filters, by default it should be descending by ID so that new incidents appear at the top.