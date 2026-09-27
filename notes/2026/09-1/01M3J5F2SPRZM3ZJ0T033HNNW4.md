---
id: 01M3J5F2SPRZM3ZJ0T033HNNW4
created: 2026-09-27T19:28:57.654716Z
updated: 2026-09-27T19:29:31.16149Z
type: task
title: Check-in Worker and D1 database at checkin.notuvia.net
project: 01KY6W9951TW0904DT0GGJVGE7
number: 462
sprint: sv8cva3
assignee: steve
label:
- feature
priority: high
task_status: todo
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