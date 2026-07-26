---
id: 01KYF1493VK0VPP13NC8CG52TQ
created: 2026-07-26T10:56:56.955808Z
updated: 2026-07-26T10:56:56.955808Z
type: task
title: 'AI remediation ends in a PR: repo context in remediation + end-to-end vertical'
label: feature
priority: medium
assignee: steve
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 313
---
The closing vertical: an incident on a tagged entity can end in a reviewed GitHub PR instead of a direct infra change.

`get_action_catalogue` already exposes the `open_pull_request` spec to `run_proposal`, so the mechanics come nearly free — this task is context + prompt + proof:
- Ensure the remediation/diagnosis surfaces see repo context for the affected entities (repo summaries + freshness via the repos context block; retrieval tools available so the draft can cite actual file content read through `read_repo_file` / `search_repo_knowledge`).
- Prompt guidance where needed (`ai/tools.py` / remediation prompt): when the fix is infrastructure-code-shaped and a registered repo covers the entity, prefer drafting `open_pull_request` over direct mutation; the draft must name the file(s) and base the content on retrieved file state, never invented content.
- End-to-end integration test: incident on a tagged entity → AI drafts an `open_pull_request` proposed change citing a repo file → approver approves → executor opens the PR (mocked client). Inadmissible drafts (unregistered repo, protected target) become recorded discards, not exceptions (existing `_persist_drafts` behaviour).
- Update `docs/briefs/integration-connectors.md` with the GitHub integration row + DoD checklist tick.

**Acceptance:** demo path on staging — an incident's AI remediation proposal is a reviewable `open_pull_request` draft with sensible file contents grounded in the repo's actual files, and approving it yields a PR whose URL is on the change record.

**Files:** mod `repos.py` / `estate.py` (context assembly, if not fully landed by the retrieval task), `ai/remediation.py`, `ai/tools.py` (prompt guidance), `docs/briefs/integration-connectors.md`; new/extended `tests/integration/test_github_remediation_vertical.py`. No migration.

**Conflict note:** shares `ai/` import surfaces with the retrieval task — land after it.