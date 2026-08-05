---
id: 01KZ7A7DTKGHY5FMRK8XAMSST6
created: 2026-08-04T21:17:43.63518Z
updated: 2026-08-05T12:33:36.921984Z
type: task
title: 'On-call rotas: domain model + Rotas screen'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 545
sprint: s4ncy73
assignee: steve
label: null
priority: medium
task_status: backlog
---
ADR 0080 §1/§4. Rota = ordered member list (ISE users) forming the escalation chain, contact number held on the membership (EntraID `mobilePhone` may pre-fill; rota value is authoritative), simple rotation (weekly handoff or manual) + one-click override ("I'm covering").

Screen: Rotas page — who is on call **right now** front and centre, then chain, rotation, override. Nav entry + ui-brief addition.

Numbers are PII: log-redaction list covers them; UI/logs name the person, not the number. Out of scope (stays out): layered schedules, time zones, follow-the-sun, iCal.