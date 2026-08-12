---
id: 01KZTWBW9H0W5P5DP9C9VKA6EE
created: 2026-08-12T11:40:18.097672Z
updated: 2026-08-12T11:40:18.097672Z
type: task
title: 'Region tagging: close the coverage gap before the regional layer relies on it'
label: chore
priority: high
task_status: backlog
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 665
---
A regional Business Application is only as complete as the region tagging beneath it, and today that is 155 of 7,188 live entities — about 2%.

**What exists**
- `geo` → `uk` (64) / `us` (53), on **workloads only**, from the four Kubernetes connectors
- `region` → `eu-west-2` (72) / `us-east-1` (19) / `uksouth` (3), on **DataDog hosts only**
- These are disjoint: no entity carries both, and they are different vocabularies — `uk` is a business region, `eu-west-2` and `uksouth` are two provider regions that are both the UK

**What carries nothing:** databases, clusters, VPCs, buckets, load balancers. `kora-uk-production-mariadb-db-instance` has its region in its NAME only — and reasoning from names is exactly what this estate has been bitten by twice.

**Also worth knowing:** `project` cannot substitute. `cluster-envproductionukpri-ekscluster` and `cluster-envproductionuspri-ekscluster` BOTH carry `project:envproductionpri`, so the Platform role cannot tell UK from US either.

**The work**
1. Decide the vocabulary level — business (`uk`/`us`) or provider (`eu-west-2`) — and canonicalise the other into it with dictionary aliases so both sources converge on one answer.
2. Get the chosen key onto the entity types a Business Application actually composes, databases first: `chinwag-v2.prod.uk` collecting its UK workloads while missing its UK database is the failure this task exists to prevent.
3. State it at the platform roots too (8 clusters, the VPCs) — a short actionable list, and what an inherited/derived reading would need later.

Until this lands, regional rules will resolve partially and report the shortfall as a per-rule fault (ADR 0096 §3). That is honest behaviour, not a bug — but it means the layer looks broken until the tags catch up, so sequence this with ISE-663 rather than after it.