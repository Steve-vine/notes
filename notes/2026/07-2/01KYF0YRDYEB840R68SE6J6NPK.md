---
id: 01KYF0YRDYEB840R68SE6J6NPK
created: 2026-07-26T10:53:56.030957Z
updated: 2026-08-05T12:34:38.46025Z
type: task
title: 'GitHub connector skeleton: credential spec, health check, account repo listing'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 305
sprint: siyfhjg
blocked_by:
- 01KYF0X489C1CWJSKTD467M9RQ
comments:
- id: 01KYH84XHVKR3KK9GJKCN1DB01
  author: Steve Vine
  at: 2026-07-27T07:38:06.778963Z
  text: |-
    Built 2026-07-27 → Review. PR #288 (base main), branch feature/ise-305-github-connector-skeleton.

    connectors/github.py: GitHubConnector, connector_type="github", capabilities()={"repos"} (alerts/actions deferred to ISE-310/312). credential_spec = read PAT api_token only (write PAT via Grant-write flow, ADR 0051 §7); structural validate_credential (no network); health_check GET /user; build_client httpx seam; list_repos(ctx) paginated (per_page 100, 20-page ceiling, case-insensitive sort) for the register picker.

    Framework: appended "repos" to CONNECTOR_CAPABILITIES; added RepoRef model + list_repos() default on the base Connector; registered GitHubConnector; exported RepoRef. Frontend statusColors.ts: filled capability colour+description maps for the missing `documents` and new `repos` in one pass (conflict-hotspot file, done once).

    Tests: tests/test_github_connector.py over an httpx MockTransport seam — capability set, cred spec, structural validation, health connected/error, list_repos pagination/sort/skip. Green locally: pytest, full mypy (334 files), ruff check+format, frontend build+prettier+eslint. No migration.

    Note: later tasks stack on this branch (hard dep chain + migration stacking 0059→0062).
assignee: steve
priority: medium
task_status: done
---
New `connectors/github.py`: `connector_type="github"`, `capabilities() = {"repos"}` (alerts/actions added by later tasks), `credential_spec()` with `api_token` (secret) for the account-wide read PAT (write PAT arrives via the standard Grant-write flow), `validate_credential` structural checks (no network, ISE-199), `health_check` (GET /user), `build_client(secret)` httpx seam for tests (Confluence pattern), and `list_repos(ctx)` paginating the account's repositories for the register picker.

Framework changes: append `"repos"` to `CONNECTOR_CAPABILITIES` in `connectors/base.py`; register in `connectors/__init__.py`; add `repos` **and the missing `documents`** entries to `CAPABILITY_COLORS`/`CAPABILITY_DESCRIPTIONS` in `app/frontend/src/components/statusColors.ts` (do all capability strings once here — this file is a conflict hotspot). The add-integration flow is registry-driven, so no other frontend work.

**Acceptance:** GitHub appears in Settings → add integration with the capability badge rendering properly; credential form renders from the spec; health shows connected against a mocked client in tests.

**Files:** new `connectors/github.py`, `tests/integration/test_github_connector.py`; mod `connectors/base.py`, `connectors/__init__.py`, `app/frontend/src/components/statusColors.ts`. No migration.

**Note:** `connectors/github.py` is touched by most later tasks (T4/T7/T8/T9) — structure it with per-concern sections from the start and keep later branches short-lived.