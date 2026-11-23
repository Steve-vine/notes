---
id: 01M84XXPNAEX9CBTGXYT6F1CVZ
created: 2026-11-23T19:25:29.642666Z
updated: 2026-11-23T19:40:53.05731Z
type: task
title: Compass can go into maintenance — everyone sees a notice and is signed out, background work stops, and it can be brought back
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2116
sprint: szwetpq
blocked_by:
- 01M84XTFR1V2SDQHR0Y61HSY85
assignee: steve
label:
- feature
priority: high
task_status: active
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