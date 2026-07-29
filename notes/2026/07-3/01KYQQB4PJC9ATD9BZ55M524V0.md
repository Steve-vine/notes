---
id: 01KYQQB4PJC9ATD9BZ55M524V0
created: 2026-07-29T19:59:05.938558Z
updated: 2026-07-29T19:59:05.938558Z
type: task
title: Azure evidence-on-demand
assignee: steve
label: feature
task_status: backlog
priority: medium
project: 01KX671DATY39VW6GWK3M2T3DN
number: 368
---
Mirror of ISE-362. Connector evidence tools per the ADR 0031 capability contract, exposed to investigation surfaces: resource describe (full ARM resource JSON), Azure Monitor metrics for an entity, Activity Log (the CloudTrail analogue — who changed what, when), and Log Analytics/KQL queries where a workspace is configured (optional, degrade gracefully without one).