---
id: 01KYF1493VK0VPP13NC8CG52TQ
created: 2026-07-26T10:56:56.955808Z
updated: 2026-08-05T19:02:30.39581Z
type: task
title: 'AI remediation ends in a PR: repo context in remediation + end-to-end vertical'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 313
sprint: siyfhjg
blocked_by:
- 01KYF12804JGEF0X44RFRGK5BA
- 01KYF13F3CRZFEKBVBWNHJ9F65
comments:
- id: 01KYHDFWV23KGEDBYMAEZKWQ0H
  author: Steve Vine
  at: 2026-07-27T09:11:29.378316Z
  text: |-
    Built 2026-07-27 → Review. PR #296 (stacked on #295, base feature/ise-312 branch), branch feature/ise-313-remediation-pr. No migration. Closing vertical of Sprint 26.

    Context: repo comprehension already rides into diagnose/propose via investigation_context (309) → bound_investigation_context preserves the "repos" key. Added TWO deps.db-backed tools to ai/tools.py (search_repo_knowledge, read_repo_file) → DIAGNOSIS_TOOLS (so diagnose+propose+analyse-issue get them; PROPOSAL_TOOLS = DIAGNOSIS_TOOLS + get_action_catalogue). WHY new variants: the chat retrieval_tools/assist_tools versions use read_only_session (session_factory) which single-shot runs DON'T have — these use deps.require_db() (the run's shared session). Guarded UUID parsing (TestModel passes garbage args → return note not raise; this was the fix for the run-failed test). Prompt: propose-remediation system prompt gained a paragraph — prefer open_pull_request when infra-code-shaped + registered repo covers entity, read actual file content, never invent.

    Proof test_github_remediation_vertical.py (TestModel stub via build_model monkeypatch): incident→open_pull_request ProposedChange (T2, governed, no AI privilege); drafted params run through GitHubConnector.act with mocked build_client → executed + PR URL; protected_targets:[repo] → create_proposal raises ProtectedTargetError → _persist_drafts records discarded_drafts (not exception). Updated hardcoded tool-set assertions in test_ai_propose + test_ai_diagnose (+search_repo_knowledge, +read_repo_file). integration-connectors brief: GitHub row + DoD note. Green: mypy 352, ruff, all AI suites (46 tests: propose/diagnose/analyse/evidence/concurrency/vertical). No frontend/OpenAPI.
assignee: steve
label: null
priority: medium
task_status: done
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