---
id: 01KXTRWGPMRSWZBRVTM2MCM9TM
created: 2026-07-18T14:08:05.332460206Z
updated: 2026-07-21T17:43:38.83577Z
type: task
title: Repoint the Issues UI onto Incidents
project: 01KX671DATY39VW6GWK3M2T3DN
number: 117
sprint: stgj737
assignee: steve
priority: medium
task_status: done
---
**Sprint 11 (spine).** Migrate the Sprint 8 Issues screen (chat/timeline, `ISE-frontend`) so the durable record is the **Incident**, with Signals (Alerts/Observations) shown as *attached, transient* underneath (they may flicker; the Incident holds steady).

- Incident status chips (New/Active/Resolved/Reactivated/Closed); signal status badges.
- One-click **severity downgrade** and **Ignore** from the queue.
- Consumes only `/api/v1`. Repoint any tests/placeholders that assert the old Issues shape.

Depends on the Incident + Signal models and their API. Frontend: React + TS strict, Vitest.

**Backend ready (ISE-115):** the one-click actions call `POST /findings/{id}/downgrade` and `POST /findings/{id}/ignore`; incidents already carry the *effective* (tuned) severity, and `/incident-policy` + `/severity-overrides` exist for a settings surface. This task is the frontend wiring of those.