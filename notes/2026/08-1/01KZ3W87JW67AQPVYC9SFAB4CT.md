---
id: 01KZ3W87JW67AQPVYC9SFAB4CT
created: 2026-08-03T13:15:46.652331Z
updated: 2026-08-03T13:15:56.191919Z
type: task
title: 'Estate: Karpenter-churned nodes linger as live hosts for days'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 514
sprint: skxht3g
assignee: steve
label:
- improvement
priority: medium
task_status: backlog
---
Improvement from Sprint 46 Estate testing. Across the four env clusters, 15 hosts shown live in the Estate no longer exist — the nodes were terminated by Karpenter and the EC2 instances are gone from AWS entirely (2 staging-uk, 3 staging-us, 6 prod-uk, 4 prod-us — nearly half of prod-uk's host list). The per-type retirement window (days) is right for pets but too slow for Karpenter cattle.

Suggestion: retire a host early when every source that ever reported it now agrees it's gone (k8s node absent AND AWS instance not found AND no fresh DataDog sighting), rather than waiting the full staleness window. Related: the two staging-uk ghosts are also the mis-named hosts in ISE-511.