---
id: 01KYF12804JGEF0X44RFRGK5BA
created: 2026-07-26T10:55:50.276574Z
updated: 2026-07-27T07:25:55.650274Z
type: task
title: 'Repo retrieval: FTS search tools + read_repo_file drill-down'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 309
sprint: siyfhjg
blocked_by:
- 01KYF119J3JTFDKGWTQRSY9RXD
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
The "index → search" half of the ADR 0050 contract — repos become findable, not trawlable.

**Migration 0061** (⚠ renumbered 2026-07-27 — Sprint 25 took 0056–0058): functional GIN indexes `to_tsvector('english', ...)` on `repo_file` (summary + path via coalesced expression) and `repo_commit` (message). **No pg_trgm / CREATE EXTENSION** (CNPG role limitation); index expression must match the query expression in code exactly.

**Backend** (`retrieval.py`): `search_repo_knowledge(db, query, repo_id=, limit=)` — ranked over file summaries/paths, returns repo, path, summary snippet; `search_commit_history(db, query, hours=, repo_id=, limit=)` — ranked over commit messages with files-touched, answering "what changed in recent releases". Both return the standard `{mode: relevance|recent, results, truncated}` envelope with the stop-word fallback. Tools appended to `RETRIEVAL_TOOLS` in `ai/retrieval_tools.py` (lands in issue-chat/investigation automatically); `read_repo_file(repo_id, path)` drill-down beside `read_document` in `ai/assist_tools.py`, `bound_payload`-capped, read-only session, content wrapped as untrusted. Citations entry (`citations.py`) so the model can link a repo/file (`/repos/{id}`).

**Operator-facing commit search** (UI brief §11): an FTS-backed commit search box on `/repos/:id` ("which commit touched the ingress") over the same `search_commit_history`, exposed via `repos_api.py`.

Also: repo summaries + freshness join `investigation_context` via a `repos.context_block(db, entity_ids)` (documents pattern — summaries ride free, full text never). If context bloat is a concern, keep the block summary-only and lean on search.

**Acceptance:** in issue chat, "what changed in recent releases of X?" returns a ranked bounded commit shortlist and the model can open one file's content — visible in the agent-run trace; truncation is honest; an operator gets the same answer from the commit search box on the repo detail page.

**Files:** new `migrations/*_0061_repo_fts.py`; mod `retrieval.py`, `ai/retrieval_tools.py`, `ai/assist_tools.py` (ASSIST_TOOLS allow-list), `citations.py`, `repos.py` (context_block), `estate.py` (investigation_context wiring), `models.py` (__table_args__ mirror), `repos_api.py`, `RepoDetailPage.tsx`; tests extend `test_retrieval.py` + assist-tools tests.

**Migration chain:** 0061 stacks after 0060; `ai/assist_tools.py`/`issue_chat.py` imports are a known conflict hotspot with the remediation-vertical task.