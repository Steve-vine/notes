---
id: 01KZ3R4J35DCMH0EAWK252X3DG
created: 2026-08-03T12:03:52.037394Z
updated: 2026-08-13T19:00:09.473314Z
type: task
title: Estate list screen ordering
project: 01KX671DATY39VW6GWK3M2T3DN
number: 509
order: 1.0
sprint: skxht3g
comments:
- id: 01KZ3VWTC8XY9AP9RKFD9NJXQF
  author: Steve Vine
  at: 2026-08-03T13:09:32.680203Z
  text: |-
    Done in PR #435 (feature/ise-509-estate-list-sorting).

    Replicates the Incidents list behaviour (ISE-208) exactly: the shared SortableTh header on all six columns (Type, Name, Integrations, Tags, First seen, Last seen) — click to sort, click again to flip, descending first, direction announced via aria-sort — with the sort remembered in its own storage key so "Clear filters" doesn't reset it, and a re-sort returning to page 1.

    Sorting is server-side (the list is paged since ISE-494): GET /api/v1/entities gains sort + dir params. Details worth knowing:
    - Default is first_seen desc — byte-identical to the previous fixed ordering, so the three callers that never pass sort (Dashboards picker, Explorer search, relationship search) are unaffected.
    - last_seen keeps never-seen entities at the end in both directions (Postgres DESC puts NULLs first by default).
    - Integrations sorts on distinct systems — the number the column shows — not alias rows.
    - id tiebreak in the same direction on every sort, since no column is unique.

    API types regenerated. Tests: backend test_list_sorts_by_every_column (every key, both directions, 422 on nonsense), frontend EstateSorting.test.tsx (5 tests incl. page-1 return from page 2). Full frontend suite (534 tests), build, eslint, prettier, ruff and mypy strict all green locally.
- id: 01KZ3XRQXWAKTP7T9PRHNG1125
  author: Steve Vine
  at: 2026-08-03T13:42:16.252072Z
  text: 'RELEASED to main 2026-08-03 (PR #435 merged, main 57691b5, no migration). Main CI green: full suite + production image build. Staging reset to main.'
assignee: steve
label: null
priority: medium
task_status: done
tech: null
---
On the estate list screen, add the capability to sort columns. Replicate the behaviour that already exists on the Incidents list screen