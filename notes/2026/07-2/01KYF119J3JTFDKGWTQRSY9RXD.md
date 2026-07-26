---
id: 01KYF119J3JTFDKGWTQRSY9RXD
created: 2026-07-26T10:55:19.107372Z
updated: 2026-07-26T12:36:57.602376Z
type: task
title: Change-driven repo ingest + comprehension sweep (head-SHA poll, repo/file summaries)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 307
sprint: siyfhjg
blocked_by:
- 01KYF10Q72XPZAHFH1KMDCF611
assignee: steve
label: null
priority: medium
task_status: backlog
---
The ADR 0050 "comprehend at write time" core.

**Migration 0057**: `repo_file` (repo_id, path, kind, size, content_hash, summary, skipped_reason, `uq(repo_id, path)`), `repo_commit` (repo_id, sha unique per repo, message, author, committed_at, files-touched JSONB); add `repo.head_sha` / `summary` / `last_synced_at` / `last_changed_at` / `fetch_error` / `last_extraction` JSONB (last_extraction added here so the claims task needs no migration); seed cheap-tier AI model configs `summarise-repo` + `summarise-repo-file` (documents-migration pattern).

**Connector** (`connectors/github.py`): head-ref, tree, compare, file-content, commits fetch methods.

**Sweep** (`tasks/repos.py sync_repos_task`, Beat + `worker.py include`): per-repo cadence gate (`settings.repo_sync_interval_hours`, default 1) — one head-ref call per repo per tick. On SHA change: compare API → touched paths → re-summarise only allowlisted touched files; refresh repo summary only if a summary input changed (README/manifest class); append new commits (initial depth 200, incremental after); two commits per repo (fetch durable before summaries attempted); never raises. **Cost bounds:** allowlist (IaC: `*.tf`, helm values, k8s manifests, `Dockerfile*`; CI: `.github/workflows/*`; docs: `*.md`), per-file size cap (~40k chars, larger skipped with recorded reason), per-sweep summary cap (~25 — a big repo drains across sweeps); lockfiles deterministic-only, never summarised. Hash decides `changed`, documents-style.

**AI** (`ai/agents.py`): `RepoSummary` + `RepoFileSummary` with untrusted-content prompt wrappers; per-task token caps in `ai/engine.py`.

**UI**: Repos screen row gains AI summary + freshness (`age_phrase`) + "comprehension in progress (N of M files)" honesty while a large repo drains; repo detail (modal or drawer) lists comprehended files with summaries.

**Acceptance:** after the sweep a registered repo shows its AI summary and file summaries in the UI; in tests, a simulated push re-summarises only touched allowlisted paths and a version-equivalent no-op does not spend.

**Files:** new `migrations/*_0057_repo_comprehension.py`, `tasks/repos.py`, `tests/integration/test_repo_comprehend.py`; mod `connectors/github.py`, `models.py`, `ai/agents.py`, `ai/engine.py`, `worker.py` (include + beat — guarded by `test_worker_task_registration.py`), `settings.py`, `repos.py`, `repos_api.py`, `ReposPage.tsx`, OpenAPI regen.

**Risk noted:** GitHub rate limit 5k/hr — tree API is one call; only allowlisted files fetched; caps spread onboarding.