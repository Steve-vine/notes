---
id: 01KYF11QWQ2PD71RN5NKJV5KEQ
created: 2026-07-26T10:55:33.783223Z
updated: 2026-08-06T08:34:41.510696Z
type: task
title: Repo claims → proposals queue (extract/diff/withdraw + ClaimsModal)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 308
sprint: siyfhjg
blocked_by:
- 01KYF119J3JTFDKGWTQRSY9RXD
comments:
- id: 01KYHAY38Q4DMWFWCE03BPA9K9
  author: Steve Vine
  at: 2026-07-27T08:26:48.983755Z
  text: |-
    Built 2026-07-27 → Review. PR #291 (stacked on #290, base feature/ise-307 branch), branch feature/ise-308-repo-claims.

    MIGRATION DECISION: 308 needed a source_kind constraint change (source_kind IS DB-constrained via 0044), so it took its OWN migration 0061 rather than folding into 0060 — cleaner than editing 307's in-review migration. This shifts ISE-309→0062 and ISE-311→0063 (both unbuilt). Chain now 0059(306)→0060(307)→0061(308)→0062(309)→0063(311).

    Migration 0061: proposal.repo_id (FK SET NULL) + ix_proposal_repo; source_kind constraint (ck_proposal_source_kind_valid — naming-convention prefix, NOT source_kind_valid) gains 'repo'; seeds extract-repo-claims (a000d) + task_type CHECK. repo_claims.py mirrors document_claims.py, IMPORTS its anchoring primitives (_resolve/_entity_type/_SETTING_LIKE/_MACHINE_NAME/_MIN_DISTINCTIVE_NAME/_EDGE_TYPES/ClaimOutcome/MAX_CANDIDATE_ENTITIES) so guard logic is one path. Source text = repo.summary + file summaries (_repo_comprehension_text in ai/agents). Diff keyed on Proposal.repo_id; still-stated→re-raise, stale+proposed→withdrawn, stale+confirmed→needs_review flagged; failed run never diffs. candidate_entities via RepoTag neighbourhood + one hop. extract-repo-claims agent (RepoClaim subclasses DocumentClaim). Sweep extracts AFTER drain phase (summaries must exist first), gated on changed. deregister_repo withdraws first. GET /repos/{id}/claims + last_extraction on RepoRead. ClaimsModal + ExtractionAccounting on ReposPage.

    Tests test_repo_claims.py: claim→proposal quoting repo+passage, withdrawn/flagged/no-diff-on-failure, deregister withdraws, candidate scoping. Green: full mypy (345), ruff, frontend build+eslint, migration+ai-config-seed(+3 task types now)+worker tests.
assignee: steve
label: null
priority: medium
task_status: done
---
Extracted resource/entity references from repo comprehension feed the estate graph as proposed claims — the ISE-299 requirement.

**Backend**: new `repo_claims.py` mirroring `document_claims.py` — extract entity/edge/tag claims from repo + file summary source text (`extract-repo-claims` agent, cheap tier, config seeded in migration 0060 or via ai_limits resolver); anchoring lives in code not prompt (ISE-222 lesson): `_resolve` three-outcome (resolved / unknown → entity proposal / ambiguous → dropped with reason), setting-like and machine-name guards, MAX_CLAIMS cap, verbatim `passage` required. `proposals.raise_proposal(source_kind="repo")` — check `PROPOSAL_SOURCE_KINDS` needs `"repo"` appended (models.py constant + any check constraint; if constrained, fold into migration 0060 coordination with the ingest task). Diff rules identical to documents: still stated → re-raise; stale + proposed → withdrawn; stale + confirmed → needs_review. `withdraw_all` on repo deregistration/deletion. Accounting into `repo.last_extraction` (column exists from 0060).

**Frontend**: ClaimsModal + ExtractionAccounting on ReposPage/RepoDetailPage (clone from DocumentsPage).

**Acceptance:** a repo whose helm values name a known service raises an edge proposal visible in the Proposals queue, attributed to the repo with its passage; removing the file withdraws the proposed claim; confirmed claims flip to needs_review, never silently vanish.

**Files:** new `src/ISE_api/repo_claims.py`, `tests/integration/test_repo_claims.py`; mod `tasks/repos.py` (extract call after summarise, gated on changed), `ai/agents.py`, `models.py` (source kind), `proposals.py` if source-kind handling is switch-shaped, `repos_api.py` (GET claims), `ReposPage.tsx`. No migration (rides 0060's columns — coordinate the source-kind constraint with the ingest branch if one exists).