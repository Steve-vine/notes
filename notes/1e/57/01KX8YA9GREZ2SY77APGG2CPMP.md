---
id: 01KX8YA9GREZ2SY77APGG2CPMP
created: 2026-07-11T15:56:39.832077314Z
updated: 2026-07-11T17:42:54.223201Z
type: task
title: DataDog connector — service-map slice + event-based detect
assignee: steve
task_status: backlog
priority: low
project: 01KX671DATY39VW6GWK3M2T3DN
number: 31
blocked_by:
- 01KWVDQDJSAS0CCGYZN9TCJYRT
sprint: sdm5e08
---
Follow-up to ISE-24 (deferred pending live keys, now available). Add the read-state service-map slice (APM service dependencies / service definitions) and event-based detect (alert/error events via EventsApi), validated against the real DataDog EU org. Extends the existing DataDogConnector; contract tests + live check.