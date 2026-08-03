---
id: 01KZ3VYPS8SNVWVKT4MDTX82CS
created: 2026-08-03T13:10:34.53603Z
updated: 2026-08-03T13:10:34.53603Z
type: task
title: 'Estate: Karpenter hosts named after the nodepool Name tag, not the hostname'
assignee: steve
label: bug
priority: medium
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 511
---
Found in Sprint 46 Estate testing. Two env-staging-uk hosts display as "cluster-envstaginguk-nodeclass-nodepool-apps" — the Karpenter pool's AWS Name tag — instead of their hostname (ip-172-21-82-67 / ip-172-21-85-156). Naming is a first-discovery race: when the AWS integration discovers an instance before the Kubernetes sync, it names the entity from the EC2 Name tag, and every Karpenter node in a pool carries the same tag value — so the estate shows multiple hosts with identical, meaningless names.

**Fix direction:** for host entities, prefer the hostname/private-DNS over the EC2 Name tag when naming (or treat the shared Karpenter tag as non-authoritative).