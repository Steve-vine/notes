---
id: 01KYF11QWQ2PD71RN5NKJV5KEQ
created: 2026-07-26T10:55:33.783223Z
updated: 2026-07-26T10:57:14.320117Z
type: task
title: Repo claims → proposals queue (extract/diff/withdraw + ClaimsModal)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 308
sprint: siyfhjg
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
Extracted resource/entity references from repo comprehension feed the estate graph as proposed claims — the ISE-299 requirement.

**Backend**: new `repo_claims.py` mirroring `document_claims.py` — extract entity/edge/tag claims from repo + file summary source text (`extract-repo-claims` agent, cheap tier, config seeded in 0057 or via ai_limits resolver); anchoring lives in code not prompt (ISE-222 lesson): `_resolve` three-outcome (resolved / unknown → entity proposal / ambiguous → dropped with reason), setting-like and machine-name guards, MAX_CLAIMS cap, verbatim `passage` required. `proposals.raise_proposal(source_kind="repo")` — check `PROPOSAL_SOURCE_KINDS` needs `"repo"` appended (models.py constant + any check constraint; if constrained, fold into migration 0057 coordination with the ingest task). Diff rules identical to documents: still stated → re-raise; stale + proposed → withdrawn; stale + confirmed → needs_review. `withdraw_all` on repo deregistration/deletion. Accounting into `repo.last_extraction` (column exists from 0057).

**Frontend**: ClaimsModal + ExtractionAccounting on ReposPage (clone from DocumentsPage).

**Acceptance:** a repo whose helm values name a known service raises an edge proposal visible in the Proposals queue, attributed to the repo with its passage; removing the file withdraws the proposed claim; confirmed claims flip to needs_review, never silently vanish.

**Files:** new `src/ISE_api/repo_claims.py`, `tests/integration/test_repo_claims.py`; mod `tasks/repos.py` (extract call after summarise, gated on changed), `ai/agents.py`, `models.py` (source kind), `proposals.py` if source-kind handling is switch-shaped, `repos_api.py` (GET claims), `ReposPage.tsx`. No migration (rides 0057's columns — coordinate the source-kind constraint with the ingest branch if one exists).