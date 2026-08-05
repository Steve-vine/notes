---
id: 01KYY8FMB9N4HNWJ5XSJ8101Y2
created: 2026-08-01T08:54:05.417784Z
updated: 2026-08-05T12:31:18.406482Z
type: task
title: Register status pages on the integration's own page, not a separate Status Pages nav item
project: 01KX671DATY39VW6GWK3M2T3DN
number: 457
sprint: sfv5yw0
comments:
- id: 01KYYB78T06FYJN71JS4QWH3HX
  author: Steve Vine
  at: 2026-08-01T09:41:57.183694Z
  text: |-
    Built 2026-08-01 — PR #395, merged to staging (8feb914). No migration.

    Same shape as ISE-456: GET /status-pages gains a system_id filter, the unreachable count is scoped with it, and StatusPageRead gains system_id for the back-link.

    StatusPagesPage became StatusPageRegisterCard via git mv, so the history follows. Two things fell out that the plan did not name:

    - The register modal's integration Select is gone, and with it the "add the Status Pages integration in Settings first" error path — it can no longer happen, because the card only exists on an integration that provides the capability. The "No integration provides status pages yet" empty state went for the same reason.
    - The detail page's SECOND back-link (the not-found path) has no page loaded, so there is no owning integration to return to. It now lands on Overview, which after ISE-452 is the register of what is installed — the right place to be when the registration itself is gone.

    Merge to staging conflicted with ISE-456 in nav.ts, as expected: staging had removed Repos but still had Status Pages, the branch had removed Status Pages but still had Repos (it branched from main). Resolved by dropping both, and both icon imports with them. Verified the combined state builds and the nav tests pass before committing the merge.

    Testing: registers the same Cloudflare URL under two Status Page integrations and asserts each sees only its own, unreachable is scoped, rows carry system_id, unscoped still returns all three.

    Gates: status-pages suite 7 passed; frontend 472 / 83 files; ruff, mypy strict, build, eslint, prettier green; OpenAPI + generate:api regenerated.
assignee: steve
priority: medium
task_status: done
---
Sibling of the Repos move, from Steve 2026-08-01 — the register belongs to the integration that checks it, not to a global nav entry.

`status_page` is **already instance-scoped** — unique `(system_id, url)`, and `POST /status-pages` already takes `system_id` in the body — so this is a UI move plus one query filter. No migration, no ADR.

**Changes**
- **`GET /status-pages` gains a `system_id` filter** (`api/v1/status_pages_api.py::list_status_pages`).
- **New `StatusPageRegisterCard` on `SystemDetailPage`**, rendered when the system's capabilities include `status_pages` — same card pattern as the rest of that page. It carries, for ONE integration, what `StatusPagesPage` does globally today: the registered pages with fetch status and last-checked, register/edit/deregister, the services description and the tracked-service list with its `auto`/`manual` provenance, tags. Reuse the existing pieces rather than rewriting them.
- **Delete `pages/StatusPagesPage.tsx` and the `/status-pages` route**; remove the Status Pages entry from `NAV_SECTIONS`.
- **Keep `/status-pages/:statusPageId`** (`StatusPageDetailPage`). It has **two** back-links to `/status-pages` (one on the error path) — retarget both to the owning integration, `/systems/{system_id}`.

**Acceptance**
- With two Status Page integrations configured, each integration's page lists only its own registered pages.
- Status Pages is gone from the left nav; `/status-pages` no longer resolves.
- A status page detail page still opens; both back-links return to its owning integration.
- Tracked-service editing still works from the card, and a `manual` tracked set is still never overwritten by re-matching.
- `npm run build`, eslint, `format:check`, vitest and the backend suite green; OpenAPI snapshot + `npm run generate:api` regenerated.
