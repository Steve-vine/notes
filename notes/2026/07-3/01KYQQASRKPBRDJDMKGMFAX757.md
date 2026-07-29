---
id: 01KYQQASRKPBRDJDMKGMFAX757
created: 2026-07-29T19:58:54.739214Z
updated: 2026-07-29T19:58:54.739214Z
type: task
title: Azure Service Health → Alert signals
task_status: backlog
label: feature
assignee: steve
priority: medium
project: 01KX671DATY39VW6GWK3M2T3DN
number: 367
---
Mirror of ISE-361 (AWS Health). Ingest Azure Service Health events for the subscription — service issues, planned maintenance, health advisories — as Alert signals. Filter/scope to services and regions actually in use, derived from discovered resources, so unused-service noise is not alerted on (Status Page sprint precedent for relevance filtering).