---
id: 01KXGSJB53W6RRYBV73SY88RKD
created: 2026-07-14T17:07:36.227935729Z
updated: 2026-07-14T17:07:48.098756215Z
type: task
title: 'Search API: cross-entity search'
label:
- brief
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 50
sprint: sd2bf6k
comments:
- id: 01KXGSJPR2TE3E3SVX467MBKRD
  author: Steve Vine
  at: 2026-07-14T17:07:48.098603894Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-17 22:03 UTC]
    **Done — in review.** PR [#47](https://github.com/Steve-vine/compass/pull/47) (`steve/dev-467-search-api`). First M6 brief; implements ADR 0021.

    **What was built**
    - `GET /api/v1/search?q=&company=&limit=` — Postgres FTS (`websearch_to_tsquery`/`ts_rank`) across the shared library (domains, controls, content, decisions, frameworks + requirements) + the company's risks/gaps when `company` is given; `ILIKE` for control/requirement refs. Typed, ranked, deep-linkable results; blank `q` → empty; soft-deleted excluded. No migration, no new infra.
    - Vendored ADR 0021 into `data/decisions/` so the import hook seeds it as decision record 21 (bumped the decisions-test expectation 20 → 21).

    **Decisions made on the fly** — a small `_fts` helper drives the per-entity queries; risks/gaps are company-filtered in SQL (not post-filtered); requirements join their framework for the slug + name and deep-link to the framework page; gaps link to `/gaps` (no per-gap route). `snippet` is a truncation; `ts_headline` deferred.

    **Checks** — green locally: `ruff check .`, `ruff format --check .`, `mypy src`, `pytest` (31), `pytest -m integration` (123, incl. 6 new search tests).

    UI follow-up: [DEV-468](https://linear.app/stevevine/issue/DEV-468).
---
The backend behind the global search box (ADR 0017), implementing ADR 0021: one Postgres-FTS endpoint over the existing tables. No migration (query-time `tsvector`), no new infra.

**Agreed approach (planned 2026-06-17).**

- [ ] `GET /api/v1/search?q=&company=&limit=` (any auth). Blank `q` → `{results:[], total:0}`. `company` (uuid, optional): includes per-company entities (risks, gaps) scoped to it; absent → shared library only.
- [ ] **Mechanism**: per-entity config `(model, text cols, optional ref col, type, target)`. Per entity: `to_tsvector('english', concat_ws(...)) @@ websearch_to_tsquery('english', q)` [OR `ref ILIKE %q%` for control/requirement], `deleted_at is null`, order by `ts_rank` desc, ~10 each; merge, sort by rank, cap at `limit` (default 20). `snippet` = truncated text (~140 chars); `ts_headline` deferred.
- [ ] **Entities + targets**: domain `/domains/{slug}`; core_control (ref/title/desc) `/controls/{ref}`; content_item (title/body) `/content/{slug}`; decision (title/body) `/decisions/{number}`; framework `/frameworks/{slug}`; requirement (joined to framework) `/frameworks/{slug}`; risk *(company)* `/risks/{id}`; gap *(company)* `/gaps`.
- [ ] Flat ranked `results` list (UI groups by `type`) + `total`. Excludes soft-deleted.
- [ ] `api/v1/search.py` + `SearchResult`/`SearchResponse` schemas + router registration. **No migration.**
- [ ] **Vendor ADR 0021** into `data/decisions/0021-*.md` so the import hook seeds it as decision record 21.
- [ ] Tests (`tests/test_search.py`, real-Postgres): a match per type; control-ref match; company scoping; ranking/cap; blank-`q` empty; soft-deleted excluded.

Refs: ADR 0021 (search approach), 0017 (IA), 0005 (Postgres). Out of scope → <issue id="1eb128de-8914-46dd-912a-fd4a9f5e238f" href="https://linear.app/stevevine/issue/DEV-468/search-ui-top-bar-box-results">DEV-468</issue> (UI); pg_trgm/GIN deferred (ADR 0021).

---
*Migrated from Linear [DEV-467](https://linear.app/stevevine/issue/DEV-467/search-api-cross-entity-search) · created 2026-06-17 · completed 2026-06-17*