---
id: 01KYF0YRDYEB840R68SE6J6NPK
created: 2026-07-26T10:53:56.030957Z
updated: 2026-07-27T07:25:52.520434Z
type: task
title: 'GitHub connector skeleton: credential spec, health check, account repo listing'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 305
sprint: siyfhjg
blocked_by:
- 01KYF0X489C1CWJSKTD467M9RQ
assignee: steve
label: null
priority: medium
task_status: todo
---
New `connectors/github.py`: `connector_type="github"`, `capabilities() = {"repos"}` (alerts/actions added by later tasks), `credential_spec()` with `api_token` (secret) for the account-wide read PAT (write PAT arrives via the standard Grant-write flow), `validate_credential` structural checks (no network, ISE-199), `health_check` (GET /user), `build_client(secret)` httpx seam for tests (Confluence pattern), and `list_repos(ctx)` paginating the account's repositories for the register picker.

Framework changes: append `"repos"` to `CONNECTOR_CAPABILITIES` in `connectors/base.py`; register in `connectors/__init__.py`; add `repos` **and the missing `documents`** entries to `CAPABILITY_COLORS`/`CAPABILITY_DESCRIPTIONS` in `app/frontend/src/components/statusColors.ts` (do all capability strings once here — this file is a conflict hotspot). The add-integration flow is registry-driven, so no other frontend work.

**Acceptance:** GitHub appears in Settings → add integration with the capability badge rendering properly; credential form renders from the spec; health shows connected against a mocked client in tests.

**Files:** new `connectors/github.py`, `tests/integration/test_github_connector.py`; mod `connectors/base.py`, `connectors/__init__.py`, `app/frontend/src/components/statusColors.ts`. No migration.

**Note:** `connectors/github.py` is touched by most later tasks (T4/T7/T8/T9) — structure it with per-concern sections from the start and keep later branches short-lived.