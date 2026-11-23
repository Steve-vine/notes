---
id: 01M84XXEFMFJGW424C95Z9M2ZK
created: 2026-11-23T19:25:21.268886Z
updated: 2026-11-23T21:15:03.432878Z
type: task
title: Admin ▸ Backups — an Admin takes an encrypted copy of the database with a reason, sees it listed as BKP-n, and it deletes itself after 30 days
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2115
sprint: szwetpq
blocked_by:
- 01M84XTFR1V2SDQHR0Y61HSY85
comments:
- id: 01M8546A4MWK1H63PE8GCWV2C6
  author: Steve Vine
  at: 2026-11-23T21:15:03.188754Z
  text: |-
    Merged: #2112, b6fc3829f, 23 Nov 21:14 GMT. Migration 0904_database_backups. Not on staging yet: the sprint deploys together.

    Built: Admin ▸ Backups with BKP-n, Take a backup with a reason and progress, typed-number delete, no download, and the warning when the file store is set only on screen. Each copy is encrypted, read back and checked before it counts as Ready, and deletes itself after 30 days. A separate backup worker does the work, with its own 10Gi temporary disk.

    Decisions made in the build:
    - Custom roles can't be given Manage backups: it stays with the built-in Admin role.
    - A copy's description sits unencrypted beside it, so it holds the reason and the taker's id but no name.
    - "No room" shows as a Failed backup with the reason, not a refusal at the button.
    - Staging's 2Gi file volume is unchanged, because its storage class can't expand a claim. The node's free disk is the real limit there.
    - Postgres 16 only for now. A newer server is refused with a clear message.

    Tested: a real copy of a 272 MB local database while a writer kept committing, restored to one consistent point; killing the worker mid-copy leaves nothing behind.

    Couldn't check yet: the screen in a browser, the "on staging" Done when, and the complete built image. These go in the pre-UAT pass after the staging deploy.

    For the release: the worker's S3 identity needs rights on compass-backups/, a bucket rule to abort incomplete uploads, and a check that the 10Gi work disk fits production's database.
assignee: steve
label:
- feature
priority: high
task_status: review
---
ADR 0169 §1, §2, §10.

**Chain:** on the chain — migration + API.

**What people see**

- **Admin ▸ Backups** lists every copy: BKP number, when, who, why, size, Compass version, and status (Running, Ready, Failed).
- **Take a backup** asks for a reason, then runs in the background with progress. People carry on working.
- A failed copy says why and leaves nothing behind. Compass refuses to start one if there isn't room.
- An Admin can delete a copy (typed BKP number). Otherwise it deletes itself after 30 days.
- A warning shows if the file store is set only on the Admin screen, because a recovery from outside could not find it (§6).
- Copies never appear in evidence lists, audit packs, exports or file counts. There is no download.
- Only people with the new **Manage backups** permission (built-in Admin only, marked dangerous) see this. Polaris and connected assistants have no tools for it.

**Done when**

- An Admin takes a copy on staging while someone else keeps editing, and the copy is consistent as of its start.
- The stored copy cannot be read without Compass's key, and it has a description beside it naming its version, schema, time and key fingerprint.
- A copy past 30 days is gone from the store, and its row says when it went.
- Evidence screens, packs and Admin ▸ Files are unchanged by a copy existing.

**Technical notes**

- The image's `postgresql-client` is bookworm's default (15) and the servers are 16. Install a client matching the server from PGDG, and check `pg_dump --version` in the built image. The chart allows Postgres 16 or newer, so refuse clearly when the client is older than the server.
- Add a dedicated backup worker (own queue, one replica, its own `emptyDir` with a size limit). Do not run this in the shared worker pod: a large dump on the node's disk can evict the pod that runs access changes.
- `Storage.put`/`open` hold whole objects in memory. Add streaming upload and download. Filesystem and S3 stores both need it (staging uses a 2Gi local volume, so give staging room).
- Store under a `compass-backups/` prefix. **Do not** model copies as `attachments`, and do not add them to `exports._models()`, whose sweep deletes after 7 days.
- Encrypt streaming with a key derived from `SESSION_SECRET_KEY`, separate from the Fernet key in `secretbox`.
- Never log the connection string. Log redaction is by key name and doesn't cover message text; pass credentials by environment, not argv.
- New Celery tasks need a label in `core/task_labels.py`. Use the status row, heartbeat and stall sweep pattern from audit pack builds.