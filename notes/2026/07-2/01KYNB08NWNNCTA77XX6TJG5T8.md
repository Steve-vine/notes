---
id: 01KYNB08NWNNCTA77XX6TJG5T8
created: 2026-07-28T21:44:57.788493Z
updated: 2026-07-28T21:44:57.788493Z
type: task
title: 'Status Page integration: register + list screen'
label: feature
task_status: backlog
assignee: steve
priority: medium
project: 01KX671DATY39VW6GWK3M2T3DN
number: 352
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