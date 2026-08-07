---
id: 01KYY8FM8NKNKZFE71J9DT9DT3
created: 2026-08-01T08:54:05.333207Z
updated: 2026-08-07T10:09:25.970595Z
type: task
title: Register GitHub repos on the integration's own page, not a separate Repos nav item
project: 01KX671DATY39VW6GWK3M2T3DN
number: 456
sprint: sfv5yw0
comments:
- id: 01KYYAT3K9Z43TSHR32N416VRK
  author: Steve Vine
  at: 2026-08-01T09:34:45.865715Z
  text: |-
    Built 2026-08-01 — PR #394, merged to staging. No migration.

    Backend: GET /repos gains a system_id filter, RepoRead gains system_id.

    One thing the plan did not name and the build found: the `unreachable` count was computed GLOBALLY. Left as it was, a card on one integration's page would have warned about another integration's broken repos. It is now scoped with the list, and the test pins that.

    RepoRead needed system_id (it only carried `source`, the integration's NAME) so the detail page could link back. Its back-link pointed at /repos, which no longer exists — it now returns to /systems/{system_id}, labelled with the owning integration. A repo whose System was deleted keeps its row and shows no back-link rather than a dead one.

    Frontend: RepoRegisterCard on SystemDetailPage gated on the `repos` capability. The register modal lost its integration picker — the card knows whose page it is on. ReposPage, the /repos route and the nav entry are deleted; git recorded it as a rename, so the history follows.

    Testing: a backend test registers the SAME acme/checkout through two GitHub integrations and asserts each sees only its own (uq_repo_system_full_name makes that two rows, not a conflict), that unreachable is scoped, and that the unscoped call still returns all three. RepoRegisterCard.test.tsx pins the scoped query.

    Gates: repos API 7 passed; frontend 472 tests / 84 files; ruff, mypy strict, build, eslint, prettier green; OpenAPI + generate:api regenerated.
assignee: steve
label: null
priority: medium
task_status: done
---
From Steve 2026-08-01: the three register screens in the Integrations nav section (Documents, Repos, Status Pages) are really per-integration configuration, so each moves onto the page of the integration that owns it.

`repo` is **already instance-scoped** — unique `(system_id, full_name)`, and `POST /repos` already takes `system_id` in the body — so this is a UI move plus one query filter. No migration, no ADR.

**Changes**
- **`GET /repos` gains a `system_id` filter** (`api/v1/repos_api.py::list_repos`). `GET /repos/account?system_id=` is already per-system and needs nothing.
- **New `RepoRegisterCard` on `SystemDetailPage`**, rendered when the system's capabilities include `repos` — the established pattern on that page (`ActionsPanel`, `FreshserviceConfigCard`, `KindDictionaryCard`). It carries, for ONE integration, what `ReposPage` does globally today: the registered list with fetch status and freshness, the register-from-account picker, edit/deregister, tags. Reuse `ReposPage`'s existing pieces rather than rewriting them.
- **Delete `pages/ReposPage.tsx` and the `/repos` route**; remove the Repos entry from `NAV_SECTIONS`. A move, not a duplication — a second global list nobody navigates to is how a UI rots.
- **Keep `/repos/:repoId`** (`RepoDetailPage`) — it is reached from search and from the new card. Retarget its back-link from `/repos` to the owning integration, `/systems/{system_id}`.

**Acceptance**
- With two GitHub integrations configured, each integration's page lists only its own registered repos, and the register picker on one never offers the other's.
- Repos is gone from the left nav; `/repos` no longer resolves.
- A repo detail page still opens and its back-link returns to its owning integration.
- `npm run build`, eslint, `format:check`, vitest and the backend suite green; OpenAPI snapshot + `npm run generate:api` regenerated for the new filter.
