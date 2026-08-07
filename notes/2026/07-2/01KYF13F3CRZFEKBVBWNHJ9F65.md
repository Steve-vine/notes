---
id: 01KYF13F3CRZFEKBVBWNHJ9F65
created: 2026-07-26T10:56:30.316871Z
updated: 2026-08-07T10:57:34.19572Z
type: task
title: Governed open_pull_request action (T2, write PAT, atomic Git Data API commit)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 312
sprint: siyfhjg
blocked_by:
- 01KYF0YRDYEB840R68SE6J6NPK
comments:
- id: 01KYHCVM6873ZYKSDW417NBJ94
  author: Steve Vine
  at: 2026-07-27T09:00:25.160123Z
  text: |-
    Built 2026-07-27 → Review. PR #295 (stacked on #294, base feature/ise-311 branch), branch feature/ise-312-open-pr. No migration.

    connectors/github.py: capabilities() now {"repos","alerts","actions"}. action_catalogue() = single open_pull_request ActionSpec: tier T2, reversible=True, target_fields=["repo"], params JSON Schema (repo, base_branch?, head_branch, title, body?, commit_message, files[{path,content}] minItems 1) additionalProperties:false, rollback "close PR/delete branch". NO merge_pull_request. _execute: rejects spec.name != open_pull_request; lazy _session()+select(Repo by full_name) to refuse unregistered repo + get default_branch (executor's ctx.config lacks system_id so registration check is global-by-full_name); refuse head==base; build_client(ctx.secret carries WRITE PAT — executor reveals write_credential_ref) → _open_pull_request module fn (Git Data API: GET ref/heads/{base} → GET commit → POST trees (inline content, ONE tree all files) → POST commits → POST refs → POST pulls) returns html_url; httpx.HTTPStatusError → ActionResult failed. Generic machinery untouched: resolve_action re-validates at propose+execute, executor already clean-fails on no write_credential_ref.

    Tests test_github_pr_action.py (unit, MockTransport): exact 6-call sequence + atomicity (one tree/commit for 2 files), 422→raise, additionalProperties:false rejects extra param + missing required (validate_action_params(spec, params) — takes spec not connector). Updated test_github_connector skeleton (caps [alerts,actions,repos], catalogue [open_pull_request] T2). Green: mypy 351, ruff, connector-discovery. No frontend/OpenAPI (catalogue dynamic; proposal form renders from schema).
assignee: steve
label: null
priority: medium
task_status: done
---
The actionable capability: instead of mutating infrastructure directly, ISE can open a reviewed GitHub PR.

Add `"actions"` to the GitHub connector's capabilities. `action_catalogue()` gets one spec:
- **`open_pull_request`** — tier **T2** (always human-approved in ISE; deliberately cheaper than direct infra mutation because a second human gate sits at GitHub review), `reversible=True`, rollback note "close the PR / delete the branch". Params (JSON Schema, `additionalProperties: false`): `repo` (full_name), `base_branch` (optional, defaults to the repo default), `head_branch`, `title`, `body`, `commit_message`, `files[{path, content}]` minItems 1. `target_fields=["repo"]` so per-System `risk_policy.protected_targets` can deny-list repos/branches (the k8s-shaped defaults don't apply).
- **No `merge_pull_request`** — explicitly not shipped (ADR 0051 says why).

`_execute`: refuse `head_branch == base_branch` and unregistered repos; create branch + one atomic commit via the Git Data API (blobs → tree → commit → ref — a multi-file PR is one commit) + open the PR; return the PR URL in the ActionResult so the change record links it. Runs through the untouched propose→approve→execute machinery: `resolve_action` validates at proposal AND execution, executor uses `write_credential_ref` — no write PAT ⇒ clean `failed` with a clear message, never falls back to the read credential.

**Acceptance:** an operator proposes `open_pull_request` from the catalogue, an approver approves (T2 separation of duties), execution opens a PR (mocked client in tests) and the executed change links the PR URL; without a write credential the change fails cleanly; a protected repo is refused regardless of approval.

**Files:** mod `connectors/github.py`; new `tests/integration/test_github_pr_action.py` (mirror resolve_action + `test_change_executor.py` patterns). No migration — parallelisable with everything after the connector skeleton.