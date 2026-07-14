---
id: 01KXGTMPKXQ3JV2GER8N8P72X3
created: 2026-07-14T17:26:22.077679823Z
updated: 2026-07-14T17:26:30.323038345Z
type: task
title: Backend — decision fuzzy search (pg_trgm) + Declined status
label:
- brief
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 91
sprint: sk4616x
---
Backend for **M20 — Decisions**. Two focused enhancements to the existing decision-records feature (shipped M5, <issue id="0c85675f-5f5a-42e4-8a4f-d414c5bfcc7c" href="https://linear.app/stevevine/issue/DEV-459/decision-records-in-app">DEV-459</issue>/463/466): a **typo-tolerant fuzzy search** to surface previous decisions, and a new `declined` status. Design decided in **ADR 0029** (project repo) — implement to it. Library writes/reads gated per ADR 0026.

### Why (ADR 0029 context)

Decision records are numbered, append-only ADRs with a `proposed → accepted → superseded` lifecycle (`models/decision_record.py`). As the corpus grows the `/decisions` page (status filter only) gets hard to navigate, and the M6 global search (ADR 0021) is **FTS-only** — no typo tolerance. ADR 0021 explicitly deferred this: *"adding* `pg_trgm` *similarity is a follow-up — revisit then, not now."* M20 is that revisit. Separately, there's no way to record a decision that was **considered and rejected** — hence `declined`.

### Decisions (ADR 0029)

* **Enable** `pg_trgm` **(§1).** Built-in Postgres contrib extension; trigram similarity evaluated query-time like the existing FTS. No external infra (ADR 0005 holds).
* **Fuzzy search on the Decisions page (§2).** `GET /decisions` gains an optional `q` — trigram similarity over `number` (as text), `title`, `body_markdown`, ordered by descending similarity; composes with the existing `status`/link filters.
* **Global search becomes typo-tolerant (§3) — titles only.** Upgrade `api/v1/search.py`: FTS stays the **primary** matcher over body/prose columns; **trigram is added only on the short salient fields** (titles, names, `ref`s). A row matches if FTS matches **or** the title's trigram similarity clears a threshold; rank by `GREATEST(ts_rank, similarity)`. Do **not** run trigram over long body columns. Result shape/contract unchanged.
* `declined` **is a terminal status that stays visible (§4).** Add to the `decision_status` enum. A proposal considered and rejected — terminal alongside `superseded`, **not hidden** (stays in default listing, filterable, searchable). No enforced transition (status is already freely settable via update). Orthogonal to supersession — `superseded_by` flow unchanged.

### Checklist

- [ ] **Migration 0023** (down_revision `0022_editable_frameworks`): `CREATE EXTENSION IF NOT EXISTS pg_trgm`, and `ALTER TYPE decision_status ADD VALUE 'declined'` (add-only; not referenced in the same migration, so no transaction-block issue). No data backfill. Down-migration drops the extension (guard if other objects depend on it); note the enum value cannot be cleanly removed in Postgres — document, don't fail.
- [ ] `DecisionStatus` **enum** (`models/decision_record.py`): add `declined = "declined"`.
- [ ] `q` **param on** `GET /api/v1/decisions` (`api/v1/decisions.py`): optional `q`; when present, match by trigram similarity over `number::text`, `title`, `body_markdown` and order by descending `GREATEST(...)` similarity (replacing the default `number` order); compose with `status` and `target_type`/`target_id` filters. Keep `deleted_at IS NULL`. Empty/blank `q` → current behaviour. Stays `require_library_read`.
- [ ] **Global search trigram supplement** (`api/v1/search.py`): in the shared `_fts` helper (and the requirements join), add trigram matching on the short title/name/ref fields only — `match = FTS OR word_similarity(q, <title>) > threshold` (or `<title> % q`); rank `GREATEST(ts_rank, similarity)`. Leave body columns FTS-only. Retain/subsume the existing `ILIKE`-on-`ref` supplement. Pick a sensible threshold constant (tune against test fixtures); document it.
- [ ] **Tests**: fuzzy `/decisions?q=` returns typo'd matches (e.g. `chnage managment` → change-management ADR), similarity-ordered, and composes with `status`; global search tolerates a title typo across ≥1 non-decision entity and still ranks exact/FTS hits above fuzzy-only; `declined` round-trips through create/update, appears in default list, is filterable (`?status=declined`) and searchable; permission gating unchanged (viewer reads, assessor cannot write).
- [ ] Confirm migration applies cleanly on a DB at head `0022` (extension + enum value) and the test DB provisions `pg_trgm`.
- [ ] Regenerate OpenAPI schema for the frontend client (the `q` param).

Refs: ADR 0029 (this milestone), 0021 (FTS search; the deferred pg_trgm follow-up this discharges), 0013/0001 (decision records), 0026 (library read/write gate), 0005 (Postgres, no new infra), 0017 (IA).

Note: pill colour for `declined` is `gray` (neutral terminal) per ADR 0029 — see <issue id="de4c1dd4-2c55-4e27-84a9-5f03eabf32a3" href="https://linear.app/stevevine/issue/DEV-671/frontend-decisions-search-box-declined-status">DEV-671</issue>.

---
*Migrated from Linear [DEV-670](https://linear.app/stevevine/issue/DEV-670/backend-decision-fuzzy-search-pg-trgm-declined-status) · created 2026-06-27 · completed 2026-06-27*  
*Related to (Linear): DEV-459, DEV-671*