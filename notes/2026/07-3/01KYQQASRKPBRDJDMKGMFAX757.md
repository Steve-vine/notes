---
id: 01KYQQASRKPBRDJDMKGMFAX757
created: 2026-07-29T19:58:54.739214Z
updated: 2026-07-29T22:02:52.42388Z
type: task
title: Azure Service Health → Alert signals
project: 01KX671DATY39VW6GWK3M2T3DN
number: 367
sprint: shjh4zz
blocked_by:
- 01KYQQAJXZVXDTHJMA56VWBNPD
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Mirror of ISE-361 (AWS Health). Ingest Azure Service Health events for the subscription — service issues, planned maintenance, health advisories — as Alert signals. Filter/scope to services and regions actually in use, derived from discovered resources, so unused-service noise is not alerted on (Status Page sprint precedent for relevance filtering).