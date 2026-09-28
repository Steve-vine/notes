---
id: 01M3KZJ77YD8TYXZESDN6V3J93
created: 2026-09-28T12:24:17.918185Z
updated: 2026-09-28T13:59:52.710219Z
type: task
title: 'Feature-request triage script: list, show, mark and delete'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 470
sprint: svg0tvg
blocked_by:
- 01M3KZH6MVXRQFRJQ2F2S8QMRJ
assignee: steve
label:
- feature
priority: medium
task_status: active
tech:
- cloudflare
---
How Steve reads what comes in (ADR 0065). It's a script next to `checkin-stats.mjs`, using the same wrangler login. Good requests become NOT tasks by hand, or through Claude over the notuvia MCP. The script never writes to the vault.

## Agreed work

- [ ] `scripts/feature-requests.mjs`:
  - no args: list `new` requests (id, received, version/os, summary, email)
  - `--all`: include triaged and closed requests
  - `show <id>`: the full request, including details
  - `triage <id>` / `close <id>`: set the status and `triaged_at`
  - `delete <id>` and `delete --email <addr>`: remove rows immediately, for erasure requests. Print how many rows went.
  - `--json` and `--local`, as `checkin-stats.mjs` has
- [ ] Reuse the wrangler D1 query helper from `checkin-stats.mjs`. Extract it to a shared module if that's cleaner than copying it.
- [ ] Tests in `scripts/feature-requests.test.mjs` on the same pattern as `checkin-stats.test.mjs`.
- [ ] Add a "Reading feature requests" section to `workers/checkin/README.md`.

## Notes

When a request becomes a NOT task, don't copy the email into the task body. The vault syncs over git, so the address would spread to every machine. Record the request id instead.