---
id: 01KYF13F3CRZFEKBVBWNHJ9F65
created: 2026-07-26T10:56:30.316871Z
updated: 2026-07-27T07:25:59.617424Z
type: task
title: Governed open_pull_request action (T2, write PAT, atomic Git Data API commit)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 312
sprint: siyfhjg
blocked_by:
- 01KYF0YRDYEB840R68SE6J6NPK
assignee: steve
label: null
priority: medium
task_status: todo
---
The actionable capability: instead of mutating infrastructure directly, ISE can open a reviewed GitHub PR.

Add `"actions"` to the GitHub connector's capabilities. `action_catalogue()` gets one spec:
- **`open_pull_request`** — tier **T2** (always human-approved in ISE; deliberately cheaper than direct infra mutation because a second human gate sits at GitHub review), `reversible=True`, rollback note "close the PR / delete the branch". Params (JSON Schema, `additionalProperties: false`): `repo` (full_name), `base_branch` (optional, defaults to the repo default), `head_branch`, `title`, `body`, `commit_message`, `files[{path, content}]` minItems 1. `target_fields=["repo"]` so per-System `risk_policy.protected_targets` can deny-list repos/branches (the k8s-shaped defaults don't apply).
- **No `merge_pull_request`** — explicitly not shipped (ADR 0051 says why).

`_execute`: refuse `head_branch == base_branch` and unregistered repos; create branch + one atomic commit via the Git Data API (blobs → tree → commit → ref — a multi-file PR is one commit) + open the PR; return the PR URL in the ActionResult so the change record links it. Runs through the untouched propose→approve→execute machinery: `resolve_action` validates at proposal AND execution, executor uses `write_credential_ref` — no write PAT ⇒ clean `failed` with a clear message, never falls back to the read credential.

**Acceptance:** an operator proposes `open_pull_request` from the catalogue, an approver approves (T2 separation of duties), execution opens a PR (mocked client in tests) and the executed change links the PR URL; without a write credential the change fails cleanly; a protected repo is refused regardless of approval.

**Files:** mod `connectors/github.py`; new `tests/integration/test_github_pr_action.py` (mirror resolve_action + `test_change_executor.py` patterns). No migration — parallelisable with everything after the connector skeleton.