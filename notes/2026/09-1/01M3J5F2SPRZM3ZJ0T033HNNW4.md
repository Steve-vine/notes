---
id: 01M3J5F2SPRZM3ZJ0T033HNNW4
created: 2026-09-27T19:28:57.654716Z
updated: 2026-09-28T09:14:49.451586Z
type: task
title: Check-in Worker and D1 database at checkin.notuvia.net
project: 01KY6W9951TW0904DT0GGJVGE7
number: 462
sprint: sv8cva3
comments:
- id: 01M3J7N5KKWBWB7Z5MJ082MC7D
  author: Steve Vine
  at: 2026-09-27T20:07:14.288686Z
  text: |-
    Built. PR #466 (brief-462-checkin-worker), in Review. ADR 0064 lands with it.

    What landed:
    - workers/checkin/: the Worker, the D1 migration, wrangler.toml and a README.
    - POST /v1 accepts exactly the five fields and returns 204. Anything else gets a 4xx and stores nothing.
    - One row per (server UTC day, install, kind), upserted.
    - An is_new flag is set on an install's first row, counted once per machine across both kinds.
    - A daily cron (03:17 UTC) totals rows older than 13 months into daily_totals (no ids) and deletes them, in one D1 batch.
    - Observability is off. No workers.dev or preview URLs, so the Worker is reachable only on the custom domain.

    Decided along the way:
    - Tests run in the root vitest suite against node:sqlite with the real migration, behind a small D1-shaped adapter. This replaces the Workers test pool, so there are no new dependencies and CI covers it already. 11 tests.
    - is_new was added so "new installs per day" survives the 13-month pruning. It wasn't in the task text but NOT-466 needs it.

    Problem found: wrangler's dry run accepted the first version, but the real runtime rejected it under `wrangler dev`, because an entry module may only export handlers. Fixed by moving the logic into checkin.js and leaving index.js with only the handler export. After the fix, the local end-to-end run passed: two POSTs left one row, a bad body got 400, a GET got 405, and the cron ran cleanly.

    Not done: the Worker isn't deployed yet. It needs `wrangler d1 create` (the database_id is a placeholder until then), the remote migration and `wrangler deploy`. Deploying creates the D1 database and the checkin.notuvia.net custom domain on the Cloudflare account. It's waiting for Steve's go-ahead.
- id: 01M3KMQ97BB7H8ZDYNV186XD6B
  author: Steve Vine
  at: 2026-09-28T09:14:49.448622Z
  text: |-
    Deployed on 2026-09-28. The D1 database notuvia-checkin (bc19999f-6daa-480d-b27c-994d303540e4) is in WEUR. Steve applied migration 0001 remotely and deployed; the current version is 65c918ac. checkin.notuvia.net is attached as a custom domain, and the cron is 17 3 * * *.

    Live smoke test:
    - a valid POST gave 204, and a repeat POST also gave 204
    - the database held exactly one row, with is_new=1
    - {} gave 400, a GET gave 405, and / gave 404
    - the test row has been deleted, so the table is empty again

    The database id is committed to the PR branch (974e69e).
assignee: steve
label:
- feature
priority: high
task_status: review
tech:
- cloudflare
---
The server half of ADR 0064: the endpoint every install checks in to. It lands first, so clients have somewhere to send.

## Agreed work

- [ ] Worker source under `workers/checkin/` (with its `wrangler.toml`), deployed with `wrangler` on the same Cloudflare account as the R2 update channel. Custom domain `checkin.notuvia.net`.
- [ ] `POST /v1` accepts `{ install_id, version, os, arch, kind }` and returns `204`. Anything else gets a `4xx` and **stores nothing**:
  - `install_id`: UUID v4
  - `version`: semver `X.Y.Z`
  - `os`: `macos` | `windows` | `linux`
  - `arch`: `aarch64` | `x86_64`
  - `kind`: `desktop` | `headless`
  - Unknown fields and oversized bodies are also rejected.
- [ ] D1 schema: a daily table keyed `(day, install_id, kind)` holding version/os/arch, **upserted**. Repeat check-ins on one day overwrite rather than add, so the count stays correct.
- [ ] **No IP or request metadata stored.** The Worker reads only the body. Workers logs/observability stay off for this Worker, so request IPs never land in logs either.
- [ ] A scheduled (cron) trigger rolls daily rows older than 13 months into a per-day aggregate table and then deletes them. The aggregate holds counts by version/os/arch/kind and **no ids**.
- [ ] Tests for validation and upsert idempotency (vitest + the Workers test pool, or whatever `wrangler` offers).
- [ ] A short `workers/checkin/README.md`: how to deploy, the D1 migration steps, and a pointer back to ADR 0064.

## Notes

Land the ADR (`decisions/0064-anonymous-daily-check-in.md`) with this PR.