---
id: 01KYF119J3JTFDKGWTQRSY9RXD
created: 2026-07-26T10:55:19.107372Z
updated: 2026-08-05T12:33:32.78156Z
type: task
title: Change-driven repo ingest + comprehension sweep (head-SHA poll, repo/file summaries)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 307
sprint: siyfhjg
blocked_by:
- 01KYF10Q72XPZAHFH1KMDCF611
comments:
- id: 01KYHA5W69KH530QSKAQZJ0440
  author: Steve Vine
  at: 2026-07-27T08:13:35.305741Z
  text: |-
    Built 2026-07-27 → Review. PR #290 (stacked on #289, base feature/ise-306 branch), branch feature/ise-307-repo-comprehension.

    Migration 0060: repo comprehension columns (head_sha, summary, last_synced_at/last_changed_at, fetch_error, last_extraction JSONB); repo_file (content+hash+kind+summary+skipped_reason, uq(repo_id,path)); repo_commit (message/author/committed_at/files_touched, uq(repo_id,sha)); seeds cheap-tier summarise-repo (a000b) + summarise-repo-file (a000c) + extends task_type CHECK. Added `content` col to repo_file so summariser + read_repo_file (309) read from cache like Document.content.

    Connector: repo_head_sha/repo_tree/repo_changed_paths/repo_file/repo_commits over build_client. Sweep tasks/repos.py (Beat sync-repos hourly + worker include): per-repo head-SHA cadence gate (repo_sync_interval_hours=1); on SHA change compare→touched allowlisted paths→re-comprehend only those; repo summary re-runs only when a summary-input kind (readme/iac/helm/k8s/dockerfile/ci) moves (corrected §3); lockfiles deterministic dep-set, never summarised; TWO db commits (fetch durable before summaries); per-sweep summary budget (repo_summary_batch_size=25) drains via a summary=="" pending query so big repos spread across ticks; 40k char size cap skips-with-reason; never raises. AgentDeps gained repo_id/repo_file_id; agents RepoSummary/RepoFileSummary untrusted-content wrapped; PER_TASK_RUN_MAX_TOKENS entries.

    Frontend: RepoDetailPage renders summary + dependency set + per-file summaries; Repos row shows comprehension phrase (comprehended/draining N of M/pending/gone). OpenAPI regen.

    Tests test_repo_comprehend.py: first-sweep allowlist-only, no-op reads nothing, push re-comprehends only touched, removed dropped, lockfile parse, summarise sets summary, classify_kind + _parse_lockfile units. Updated test_ai_config_api seed set (+2) and age_phrase test (now timestamp-based). Green: full mypy (342), ruff, frontend build+prettier+eslint, migration+worker-registration tests.
assignee: steve
label: null
priority: medium
task_status: done
---
The ADR 0050 "comprehend at write time" core.

**Migration 0060** (⚠ renumbered 2026-07-27 — Sprint 25 took 0056–0058): `repo_file` (repo_id, path, kind, size, content_hash, summary, skipped_reason, `uq(repo_id, path)`), `repo_commit` (repo_id, sha unique per repo, message, author, committed_at, files-touched JSONB); add `repo.head_sha` / `summary` / `last_synced_at` / `last_changed_at` / `fetch_error` / `last_extraction` JSONB (last_extraction added here so the claims task needs no migration); seed cheap-tier AI model configs `summarise-repo` + `summarise-repo-file` (documents-migration pattern).

**Connector** (`connectors/github.py`): head-ref, tree, compare, file-content, commits fetch methods.

**Sweep** (`tasks/repos.py sync_repos_task`, Beat + `worker.py include`): per-repo cadence gate (`settings.repo_sync_interval_hours`, default 1) — one head-ref call per repo per tick. On SHA change: compare API → touched paths → re-summarise only allowlisted touched files; refresh repo summary only if a summary input changed (README/manifest class); append new commits (initial depth 200, incremental after); **two DB commits per repo — fetch made durable before summaries are attempted** (the documents-sweep resilience rule; NOT "survives two sweeps" — see the ADR §3 correction); never raises. **Cost bounds:** allowlist (IaC: `*.tf`, helm values, k8s manifests, `Dockerfile*`; CI: `.github/workflows/*`; docs: `*.md`), per-file size cap (~40k chars, larger skipped with recorded reason), per-sweep summary cap (~25 — a big repo drains across sweeps); lockfiles parsed deterministically for the dependency set, never summarised. Hash decides `changed`, documents-style.

**AI** (`ai/agents.py`): `RepoSummary` + `RepoFileSummary` with untrusted-content prompt wrappers; per-task token caps in `ai/engine.py`.

**UI** (per UI brief §11): Repos row gains summary + freshness (`age_phrase`) + comprehension status (comprehended / draining "N of M files" / gone). **Repo detail page `/repos/:id`** (brief supersedes the earlier modal idea): repo summary, tree manifest, per-file summaries, dependency set from lockfiles — every panel states freshness; `gone` labelled degraded, not hidden. (Commit search box on this page arrives with the retrieval task.)

**Acceptance:** after the sweep a registered repo shows its AI summary and file summaries on the detail page; in tests, a simulated push re-summarises only touched allowlisted paths and a version-equivalent no-op does not spend.

**Files:** new `migrations/*_0060_repo_comprehension.py`, `tasks/repos.py`, `tests/integration/test_repo_comprehend.py`, `pages/RepoDetailPage.tsx`; mod `connectors/github.py`, `models.py`, `ai/agents.py`, `ai/engine.py`, `worker.py` (include + beat — guarded by `test_worker_task_registration.py`), `settings.py`, `repos.py`, `repos_api.py`, `ReposPage.tsx`, `App.tsx`, OpenAPI regen.

**Risk noted:** GitHub rate limit 5k/hr — tree API is one call; only allowlisted files fetched; caps spread onboarding.