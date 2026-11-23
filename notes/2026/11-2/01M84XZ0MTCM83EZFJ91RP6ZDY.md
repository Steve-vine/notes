---
id: 01M84XZ0MTCM83EZFJ91RP6ZDY
created: 2026-11-23T19:26:12.634427Z
updated: 2026-11-23T19:39:37.699589Z
type: task
title: 'Complete failure: when Compass cannot start, a recovery command lists the copies from the store and restores one into an empty database, with a runbook to follow during an incident'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2120
sprint: szwetpq
blocked_by:
- 01M84XYDAWZQWZPVAJZXP43KNA
assignee: steve
label:
- feature
priority: high
task_status: todo
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