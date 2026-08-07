---
id: 01KYF6X6QJC94HWBA3RAV5JSBX
created: 2026-07-26T12:37:56.594886Z
updated: 2026-08-07T10:56:16.121742Z
type: task
title: Fold api-types into the backend job (drop duplicate install)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 320
sprint: sr2f21y
comments:
- id: 01KYFDMK9H6A16621JT9E8C62S
  author: Steve Vine
  at: 2026-07-26T14:35:34.576428Z
  text: |-
    Done — PR #276 (feature/ise-320-fold-api-types), green.

    api-types no longer stands up a duplicate uv install. The OpenAPI drift check moved into the backend job (reuses its venv); api-types is now node-only, regenerating + drift-checking schema.d.ts from the committed openapi.json.

    Note: I couldn't use the obvious "dump in backend, consume via artifact" approach — jobs don't share a filesystem, and ISE-316 removed the artifact API. So instead the check is split across the two jobs that already have the toolchains, and it composes because openapi.json + schema.d.ts both live under app/frontend/**: a forgotten dump_openapi reddens backend; a forgotten generate:api reddens api-types. Verified locally that both regens produce zero drift on the current committed types.

    Measured on this PR: api-types dropped to 30s (node-only) from the old ~193s+ uv install (seen 1-11m under contention). One fewer uv install per pipeline, as asked. Kept api-types as its own job because it's a required status check (deleting it would leave the check Expected forever).
assignee: steve
priority: low
task_status: done
---
The `api-types` job re-installs **uv AND node** just to regenerate `openapi.json` + `schema.d.ts` and diff them — duplicating the backend job's ~193s uv install and pulling node too (this job was seen taking 1–11m under contention). Fold the OpenAPI dump into the backend job (reuse its venv) and run the type-gen + drift check there or in the frontend job, removing one full uv install per run.

Acceptance: one fewer uv install per pipeline; the stale-types drift check still fails a PR that forgot `generate:api`.