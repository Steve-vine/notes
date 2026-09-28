---
id: 01M3KZJ77YD8TYXZESDN6V3J93
created: 2026-09-28T12:24:17.918185Z
updated: 2026-09-28T15:12:51.175253Z
type: task
title: 'Feature-request triage script: list, show, mark and delete'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 470
sprint: svg0tvg
blocked_by:
- 01M3KZH6MVXRQFRJQ2F2S8QMRJ
comments:
- id: 01M3M5SXW4G9DWG429JY0MZHT5
  author: Steve Vine
  at: 2026-09-28T14:13:21.922472Z
  text: |-
    Built. PR #475 (brief-470-feature-request-triage), in Review.

    What landed:
    - scripts/feature-requests.mjs with these commands: list new requests (default), --all, show <id>, triage <id>, close <id>, delete <id> and delete --email <addr>. --json and --local work as in checkin-stats. It never writes to the vault.
    - scripts/d1.mjs holds the wrangler execute call and the table formatter, shared with checkin-stats.mjs.
    - The README has a new "Reading feature requests" section.

    Decided along the way:
    - Writes use RETURNING id. The first local run showed that `wrangler d1 execute --local` leaves out meta.changes, so writes that had happened reported 0. The returned rows now give the count against both databases, and delete --email lists the ids it removed.
    - Ids must match the Worker's Crockford format, and emails its shape check, with quotes doubled. This matters because --command can't bind parameters.
    - Delete by email matches case-insensitively, so an erasure request catches the address however it was typed.
    - close stamps triaged_at when it isn't already set.

    Verification: 424/424 npm tests pass (13 new, seeded through the Worker's real handleRequest), and the pre-push hooks passed. The full command set ran end-to-end with --local, and the local test rows were cleared afterwards. Against the live database I only ran a read-only list and a no-op triage (which returned {"changed":[]}, confirming RETURNING works on D1). checkin-stats still works live.
- id: 01M3M96TAMTTPG0AVB89GCW446
  author: Steve Vine
  at: 2026-09-28T15:12:49.997616Z
  text: 'Merged as ee9a428 (squash, PR #475), with CI green. The branch is deleted.'
assignee: steve
label:
- feature
priority: medium
task_status: done
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