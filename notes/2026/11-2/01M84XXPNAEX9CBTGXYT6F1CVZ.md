---
id: 01M84XXPNAEX9CBTGXYT6F1CVZ
created: 2026-11-23T19:25:29.642666Z
updated: 2026-11-23T21:46:35.24902Z
type: task
title: Compass can go into maintenance — everyone sees a notice and is signed out, background work stops, and it can be brought back
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2116
sprint: szwetpq
blocked_by:
- 01M84XTFR1V2SDQHR0Y61HSY85
comments:
- id: 01M85600NYE7X8PTE9RM58BM11
  author: Steve Vine
  at: 2026-11-23T21:46:34.046768Z
  text: |-
    Merged: #2110, 309c79153, 23 Nov 21:46 GMT. No migration, chart or configuration change. Not on staging yet: the sprint deploys together.

    Built: maintenance mode. Every screen and portal shows one notice and reloads when Compass is back. Staff are signed out, assistants and API callers get a clear "in maintenance" answer, and health checks keep working so pods aren't restarted mid-restore. Every scheduled job and queued task is held, and only the backup worker's queue is exempt. There is no Admin button: restores start it, and an operator can end it from the command line, which is recorded in the activity log.

    Decisions made in the build:
    - If Valkey is unavailable, Compass does NOT treat that as maintenance, so a Valkey outage doesn't become a Compass outage. Only the actions that can't be undone (access changes, account deletions, privacy retention, evidence deletion) wait for a definite answer, for up to an hour, then fail visibly.
    - Queued work is parked, not deleted. It comes back if a restore dies, and is discarded only once the data has actually been replaced.
    - A task that overruns is told to stop after 5 minutes, except those that can't be undone and a running backup. Those are never killed: the restore gives up instead.
    - Vendor Portal links and API tokens are blocked during maintenance and work again afterwards. Trust Centre and auditor visits from before maintenance are refused afterwards.

    Tested: every scheduled job is checked from the live schedule, so a new one is covered automatically. A real worker and scheduler were held and resumed.

    Couldn't check yet: the notice in a browser, and a real backup running alongside maintenance. These go in the pre-UAT pass and COM-2124.

    Known limits, carried into COM-2118: an API pod cut off from Valkey alone could keep writing, so the swap must end other database connections. Nobody should deploy during a restore, because deploy jobs ignore the flag.
assignee: steve
label:
- feature
priority: high
task_status: review
---
ADR 0169 §4 (step 2) and Consequences. The foundation for every full restore.

**Chain:** on the chain — API.

**What people see**

- During maintenance every screen, the Vendor Portal, Auditor portal, Trust Centre and employee portal show a plain notice: Compass is being restored and will be back shortly.
- Everyone is signed out. API and assistant calls get a clear "in maintenance" answer.
- Only the backup worker keeps running.
- If the operation dies, an operator can end maintenance, and Compass says so in its activity log.

**Done when**

- With maintenance on, no scheduled job starts, no queued task runs, and nothing writes to the database except the backup worker. Proved by a test that goes through **every** scheduled job, so a new one cannot be forgotten.
- A task already running when maintenance starts is either finished or stopped before the restore proceeds, and the restore waits for that.
- Queued work is cleared and sessions are removed.
- Maintenance survives a restart of any pod.

**Technical notes**

- Hold the flag in **Valkey**, not Postgres, because the database is what's being replaced. All pods check it: API middleware, a Celery `task_prerun` guard, and Beat.
- Compass has no Kubernetes access (`automountServiceAccountToken: false`, no Role), so it stops work by refusing it, not by scaling down.
- API-queued tasks never expire (`celery_app.py`), so purge the queues explicitly.
- If Valkey is unavailable, fail towards maintenance for anything destructive rather than assuming it's off.