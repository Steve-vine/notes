---
id: 01KZTWBW9H0W5P5DP9C9VKA6EE
created: 2026-08-12T11:40:18.097672Z
updated: 2026-08-13T19:00:07.885713Z
type: task
title: 'Region tagging: close the coverage gap before the regional layer relies on it'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 665
sprint: sj9fsph
comments:
- id: 01KZV1K83WD5Y5G4XJ0NQQQK51
  author: Steve Vine
  at: 2026-08-12T13:11:42.460117Z
  text: |-
    Done — PR #615, merged as 79f50f2.

    **The premise of this task turned out to be wrong in the best way: no tagging exercise was needed.** The cloud connectors have always known the region — AWS sweeps region by region and records `attributes["region"]`, Azure records `attributes["location"]` — and an attribute is not a tag, so nothing could ever select on it. The fact was one layer away from being usable the whole time. `kora-uk-production-mariadb-db-instance` had its region in its name *and* in its attributes, and in no form anything could match.

    `with_region_tags` promotes it onto the pool, applied **once over each finished batch** rather than at the ~9 `EntityData` sites — so a resource type added later can't quietly forget it, which is exactly how the estate ended up with the region on hosts and nowhere else.

    Three judgement calls:
    - **`region:` for both clouds.** AWS says `eu-west-2`, Azure says `uksouth`, and they're the same fact. Whether both are *also* "uk" is a Tag Dictionary decision — canonical values and aliases — not a connector's. That keeps your vocabulary-level decision open rather than pre-empting it.
    - **Never overwrites** a region the source reported as a real tag: the estate's own statement beats ISE's inference from which sweep found it.
    - **Blank or absent yields nothing** rather than an empty tag.

    Every AWS and Azure resource gains a region on the next sync — databases, VPCs, EKS/AKS clusters, EC2/VMs, load balancers, buckets. That's the coverage a regional Business Application needs.

    **Still open, and still yours:** whether to bind the Region role to `region` and speak provider names, or keep the seeded `geo` and map `eu-west-2`/`uksouth` → `uk` with value aliases. Nothing in the code assumes either.

    Five discovery tests asserted exact tag lists that legitimately grew — updated rather than loosened, so they still pin the whole list.
assignee: steve
label:
- chore
priority: high
task_status: done
tech: null
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