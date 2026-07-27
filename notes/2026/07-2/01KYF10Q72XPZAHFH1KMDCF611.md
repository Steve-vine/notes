---
id: 01KYF10Q72XPZAHFH1KMDCF611
created: 2026-07-26T10:55:00.322252Z
updated: 2026-07-27T07:09:03.96598Z
type: task
title: 'Repo register + Repos screen: pick-from-list, tags, nav entry, entity ReposCard'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 306
sprint: siyfhjg
blocked_by:
- 01KYF0YRDYEB840R68SE6J6NPK
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
First vertical slice: an operator registers a repo from the account list and sees it in the app.

**Migration 0059** (⚠ renumbered 2026-07-27 — Sprint 25 Dashboards took 0056–0058; head is now 0058): `repo` table (id, system_id FK → system ON DELETE SET NULL, full_name, html_url, description, default_branch, fetch_status, timestamps, `uq(system_id, full_name)`) + `repo_tag` join into the shared tag pool (Document/DocumentTag pattern — no system_id on the join, human-asserted; **no repo→entity FK**, tags are the linkage).

**Backend**: core `repos.py` mirroring `documents.py` — register-is-edit, `set_tags` (via `tags.normalise_set`/`get_or_create` so the Tag Dictionary canonicalises), `repos_for_entities` (tag-canonical join, `documents_for_entities` shape), `tag_labels`, `age_phrase`. API `api/v1/repos_api.py`: GET list, GET account repos for the picker (via connector `list_repos`), POST register, PUT edit (full_name immutable — a repo IS its identity), DELETE, plus `GET /entities/{id}/repos`. Audit register/update/deregister.

**Frontend** (per UI brief §11, which supersedes earlier sketches): `pages/ReposPage.tsx` — dense register table (owner/name, System, tags, freshness, comprehension status), filterable/sortable. **Register modal is a pick-from-list tick-list** over the account's repos (multi-select; already-registered show ticked, re-saving edits in place — no free-text repo path anywhere), then tags via the dictionary-resolving tag picker. Operator-gated writes; string-tag badges with "No tags — reaches nothing" at zero. Nav entry in `components/nav.ts` (after Documents, with rationale comment), routes `repos` + `repos/:repoId` shell in `App.tsx` (detail page filled by the comprehension task), `components/ReposCard.tsx` on `EntityDetailPage.tsx` next to DocumentsCard (returns null when empty; invalidate both `['repos']` and `['entity-repos']`). Regenerate OpenAPI (`uv run python -m ISE_api.dump_openapi` + `npm run generate:api`).

**Acceptance:** operator adds a GitHub integration, registers repos ticked from the account list with description + tags, sees them on the Repos screen; an entity sharing a canonical tag shows the repo on its detail page.

**Files:** new `migrations/versions/*_0059_repo_register.py`, `src/ISE_api/repos.py`, `api/v1/repos_api.py`, `pages/ReposPage.tsx`, `components/ReposCard.tsx`, `tests/integration/test_repo_register.py` + `test_repos_api.py`; mod `models.py`, `api/v1/router.py`, `components/nav.ts`, `App.tsx`, `pages/EntityDetailPage.tsx` (import hotspot — expect conflicts), `openapi.json`/`schema.d.ts`.

**Migration chain:** 0059 is first of the sprint's four (0059→0060→0061→0062); parallel branches must stack, merge in order.