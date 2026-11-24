---
id: 01M84XZ0MTCM83EZFJ91RP6ZDY
created: 2026-11-23T19:26:12.634427Z
updated: 2026-11-24T03:52:32.950475Z
type: task
title: 'Complete failure: when Compass cannot start, a recovery command lists the copies from the store and restores one into an empty database, with a runbook to follow during an incident'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2120
sprint: szwetpq
blocked_by:
- 01M84XYDAWZQWZPVAJZXP43KNA
comments:
- id: 01M85TY4TTS07HD5SG1N25G92X
  author: Steve Vine
  at: 2026-11-24T03:52:32.857843Z
  text: |-
    Merged: #2118, 787af4848, 24 Nov ~03:45 GMT. No migration and no API change. Not on staging yet: the sprint deploys together. Runbook: docs/runbooks/complete-failure.md, linked from chart/README.md. ADR 0171 (recovering from outside Compass) is Proposed, for Steve to read.

    Built: a recovery command in the Compass image that lists copies from the store with no database or Valkey, and restores one into an empty database. Compass then comes up on hold. The runbook covers stopping the app (in production, switching off Argo's sync first), restoring a lost bucket first, rebuilding the cluster, picking a copy before anything is dropped, restoring, starting, signing in and working through the hold. The recovery job can't fire by accident: it's off by default, isn't a deploy hook, and only renders for 15 minutes after it's asked for.

    Decisions made in the build:
    - Overwriting a database that isn't empty needs its name plus a code worked out from what's in it now, so the same command can't overwrite twice.
    - It refuses while any Compass worker is answering or connected.
    - Everything from before the restore is ignored afterwards: old queued work, sessions, portal visits and reset links. This holds even if Valkey was down during the restore.
    - `create-admin --password-stdin` works on hold for a break-glass sign-in.
    - Everyone is signed out once on any environment that has had a hold, because older sessions don't record when they began.

    Tested: a real recovery on scratch containers. The database was dropped and recreated empty and Valkey flushed; the restore took about 36s and came back on hold with the copy's data. A break-glass Admin signed in. It refused a wrong key, a non-empty database, a connected app and a replayed overwrite. An independent review found 11 issues, all fixed.

    Couldn't check yet: the production commands (Argo, the database cluster, the published chart), and the timings section, which COM-2124 fills in. Production's secret is confirmed as `prod-uk-compass-creds` (read from AWS), which is what the runbook uses.

    For Steve:
    - The build tried to add a CI check that the recovery job stays off and is never a deploy hook, but the permission system blocked the CI change. Nothing enforces that automatically yet.
    - Restoring the database platform's own scheduled backup still places no hold, so Compass could re-run due access changes within five minutes. Logged as a separate task.
    - Who runs the bucket's external backup, and how, isn't written down anywhere Compass can see.
assignee: steve
label:
- feature
priority: high
task_status: review
---
ADR 0169 §6, §11.

**Chain:** independent (a command, a chart job and a runbook, reusing the restore engine). Joins the chain if it turns out to need a migration or API change.

**What the operator does**

1. Follows the runbook: stops the Compass app.
2. **If the bucket itself was lost, restores it from the external backup first** (ADR 0169 §11).
3. Runs the recovery job to **list** copies. It works with no database and no Valkey, and shows each copy's number, time, reason, version and whether its key matches.
4. Runs it to **restore** a chosen copy as Everything into an empty database.
5. Starts Compass, which comes up **on hold**. An Admin signs in and works through the review.

**Done when**

- On a scratch Compass whose database has been **deleted and recreated empty**, and whose Valkey has been wiped, following only the runbook gets Compass back with the copy's data, on hold.
- It refuses a copy from a newer version, a wrong key, or a database that isn't empty, unless the operator explicitly says to overwrite it.
- An Admin can sign in afterwards, including when SSO settings came back from the copy. The runbook covers what to do if nobody can.
- The runbook gives the commands for staging and production, the measured time, and the step for a lost bucket.

**Technical notes**

- Add a command to the backend image plus a chart Job, off by default, using the app's Secret and ConfigMap. Production is deployed by Argo CD and its API is IP-allowlisted, so **Steve runs it there**: the runbook must work from his machine, and the production manifest belongs in `devops.application.compass`.
- Read the store from `S3_*` environment settings only (`_from_env`). `_resolve_uncached` prefers the database row, which is gone.
- Needs `DATABASE_URL`, store settings and `SESSION_SECRET_KEY`. The runbook must say where each comes from if the cluster itself was lost (production: Secrets Manager `production-uk-compass-creds`).
- Write the hold before anything can reconnect.
- Put the runbook in the repo, with a pointer from `chart/README.md`.