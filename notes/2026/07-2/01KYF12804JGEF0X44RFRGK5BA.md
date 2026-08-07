---
id: 01KYF12804JGEF0X44RFRGK5BA
created: 2026-07-26T10:55:50.276574Z
updated: 2026-08-07T09:40:51.728011Z
type: task
title: 'Repo retrieval: FTS search tools + read_repo_file drill-down'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 309
sprint: siyfhjg
blocked_by:
- 01KYF119J3JTFDKGWTQRSY9RXD
comments:
- id: 01KYHBQGBYYDDF41GKZAQVW48G
  author: Steve Vine
  at: 2026-07-27T08:40:41.598165Z
  text: |-
    Built 2026-07-27 → Review. PR #292 (stacked on #291, base feature/ise-308 branch), branch feature/ise-309-repo-retrieval. Migration is 0062 (0061 taken by 308).

    Migration 0062: GIN indexes ix_repo_file_fts (to_tsvector over coalesced summary+path) + ix_repo_commit_fts (message). GOTCHA: models_match compares ORM __table_args__ expr string to DB canonical — a complex coalesce/concat/varchar expr does NOT round-trip like finding.title does, so BOTH migration and models.py use Postgres's canonical rendering verbatim: to_tsvector('english'::regconfig, (COALESCE(summary, ''::text) || ' '::text) || COALESCE(path, ''::character varying)::text). Query in retrieval.py can stay natural (Postgres matches expression trees, not strings).

    retrieval.py: search_repo_knowledge(repo_id, limit) + search_commit_history(hours, repo_id, limit), standard {mode,results,truncated} envelope + _apply_rank stop-word fallback. retrieval_tools.py: +search_repo_knowledge/search_commit_history in RETRIEVAL_TOOLS (auto in issue-chat/investigation). assist_tools.py: read_repo_file(repo_id, path) in ASSIST_TOOLS, bound_payload-capped, read-only session, untrusted wrap, observes 'repo'. citations.py: CitationEntity += 'repo' → /repos/{id} (also added to GlobalSearch GROUP_LABEL frontend map — CitationEntity is a Record key). repos.context_block joins estate.investigation_context under 'repos' key. repos_api GET /repos/{id}/commits + commit search box on RepoDetailPage.

    Tests test_repo_retrieval.py (7): relevance rank, find-by-path (plain-word path, FTS tokenisation gap noted), stop-word→recent, commit rank+bound, read_repo_file content+unknown+observation-floor, context_block summary-not-content. Green: mypy 347, ruff, frontend build+prettier+eslint, migration models_match.
assignee: steve
label: null
priority: medium
task_status: done
---
The "index → search" half of the ADR 0050 contract — repos become findable, not trawlable.

**Migration 0061** (⚠ renumbered 2026-07-27 — Sprint 25 took 0056–0058): functional GIN indexes `to_tsvector('english', ...)` on `repo_file` (summary + path via coalesced expression) and `repo_commit` (message). **No pg_trgm / CREATE EXTENSION** (CNPG role limitation); index expression must match the query expression in code exactly.

**Backend** (`retrieval.py`): `search_repo_knowledge(db, query, repo_id=, limit=)` — ranked over file summaries/paths, returns repo, path, summary snippet; `search_commit_history(db, query, hours=, repo_id=, limit=)` — ranked over commit messages with files-touched, answering "what changed in recent releases". Both return the standard `{mode: relevance|recent, results, truncated}` envelope with the stop-word fallback. Tools appended to `RETRIEVAL_TOOLS` in `ai/retrieval_tools.py` (lands in issue-chat/investigation automatically); `read_repo_file(repo_id, path)` drill-down beside `read_document` in `ai/assist_tools.py`, `bound_payload`-capped, read-only session, content wrapped as untrusted. Citations entry (`citations.py`) so the model can link a repo/file (`/repos/{id}`).

**Operator-facing commit search** (UI brief §11): an FTS-backed commit search box on `/repos/:id` ("which commit touched the ingress") over the same `search_commit_history`, exposed via `repos_api.py`.

Also: repo summaries + freshness join `investigation_context` via a `repos.context_block(db, entity_ids)` (documents pattern — summaries ride free, full text never). If context bloat is a concern, keep the block summary-only and lean on search.

**Acceptance:** in issue chat, "what changed in recent releases of X?" returns a ranked bounded commit shortlist and the model can open one file's content — visible in the agent-run trace; truncation is honest; an operator gets the same answer from the commit search box on the repo detail page.

**Files:** new `migrations/*_0061_repo_fts.py`; mod `retrieval.py`, `ai/retrieval_tools.py`, `ai/assist_tools.py` (ASSIST_TOOLS allow-list), `citations.py`, `repos.py` (context_block), `estate.py` (investigation_context wiring), `models.py` (__table_args__ mirror), `repos_api.py`, `RepoDetailPage.tsx`; tests extend `test_retrieval.py` + assist-tools tests.

**Migration chain:** 0061 stacks after 0060; `ai/assist_tools.py`/`issue_chat.py` imports are a known conflict hotspot with the remediation-vertical task.