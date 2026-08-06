---
id: 01KYNB08NWNNCTA77XX6TJG5T8
created: 2026-07-28T21:44:57.788493Z
updated: 2026-08-06T08:34:21.169288Z
type: task
title: 'Status Page integration: register + list screen'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 352
sprint: s9cqr80
comments:
- id: 01KYNC8NETTM878QDRSTAP0BGH
  author: Steve Vine
  at: 2026-07-28T22:07:01.594579Z
  text: |-
    Built and in review. PR #325 (feature/ise-352-status-page-register → main), merged to staging for the batch test.

    Delivered: visible credential-less `statuspage` connector + new `status_pages` capability; StatusPage/StatusPageTag tables (migration 0069, register-is-edit on (system, url)); /api/v1/status-pages CRUD (viewer reads, operator writes, audited); Status Pages screen (list + register/edit modals: URL, provider, services-used description, tags) with capability-gated nav entry under Integrations; ADR 0057 records the design (one System + page register, webhook model rejected; deterministic-first/AI-on-novelty; tracked-service filtering semantics).

    Gates: backend ruff/mypy/pytest green (incl. migration models-match), frontend build + 435 vitest + prettier green. The add-integration flow needed no change — a blank credential was already allowed.
assignee: steve
label: null
priority: medium
task_status: done
---
Foundation slice: an operator can add/edit/delete status page entries (URL + display name + services-used description + tags) and see them listed.

**Backend**
- `StatusPageConnector` (`connectors/statuspage.py`): visible, credential-less (`credential_spec()` empty), `capabilities() = {"status_pages","alerts","entities"}`; register in `connectors/__init__.py` + registry. Add `status_pages` to `CONNECTOR_CAPABILITIES` in `connectors/base.py`.
- Models `StatusPage` + `StatusPageTag` (mirror `Repo`/`RepoTag`): url, name, services_description, fetch_status (pending/ok/gone/error), fetch_error, last_checked_at, state JSONB, content hash. Migration = next free number (check head at build; stack per parallel-migration rule).
- CRUD API `api/v1/status_pages_api.py` mounted in `router.py`: viewer GET list/detail, operator POST/PUT/DELETE, audit `status_page.register|update|deregister`. Tags normalised through the Tag Dictionary (`repos.set_tags` pattern).
- Verify the credential-less add-integration flow (`AddSystemModal` with empty `CredentialSpec`); adjust if it assumes a secret.

**Frontend**
- `StatusPagesPage.tsx` (model on `ReposPage.tsx`/`DocumentsPage.tsx`): list card + RegisterModal (URL, name, services-used textarea, shared `TagsInput`), operator-gated writes, client-side filter.
- Route in `App.tsx`; nav entry under "Integrations" with `requiresCapability: 'status_pages'`; `CAPABILITY_DESCRIPTIONS`/`CAPABILITY_COLORS` entries in `statusColors.ts`; regenerate API types.

**ADR (with this task)**: register model; one visible System + page register (not synthetic-System-per-page, ADR 0048 contrast); `status_pages` capability; deterministic-first/AI-on-novelty fetch strategy; tracked-service filtering semantics; dual recovery. Update the ISE Canon memo.

**Acceptance**: integration addable in Settings without a credential; Status Pages screen lists entries; add/edit/delete audited; nav hidden until the integration exists (ISE-351 pattern); tests mirror `test_repo_register.py`/`test_repos_api.py`.