---
id: 01KYY8FMB9N4HNWJ5XSJ8101Y2
created: 2026-08-01T08:54:05.417784Z
updated: 2026-08-01T09:18:47.280709Z
type: task
title: Register status pages on the integration's own page, not a separate Status Pages nav item
project: 01KX671DATY39VW6GWK3M2T3DN
number: 457
sprint: sfv5yw0
assignee: steve
priority: medium
task_status: todo
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
