---
id: 01KYQMGWJYCQQDXCA7MPZ5245E
created: 2026-07-29T19:09:48.51072Z
updated: 2026-07-29T19:10:10.356656Z
type: task
title: AWS resource discovery — EC2/RDS/EKS/ELB/S3 as estate entities
project: 01KX671DATY39VW6GWK3M2T3DN
number: 359
sprint: sjyt01k
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
`discover_entities()` enumerating EC2, RDS, EKS, ELB/ALB, S3 across the configured regions.

- `EntityData` with `native_key = aws:{account_id}:{arn}` (account-scoped from day one — ADR 0045 trap).
- **Entity join, not duplication:** cross_keys — EC2 instance → `datadog:host:{instance-id}` (DataDog canonical host names are instance ids in this estate) and `k8s:node:{node-name}` for EKS nodes; EKS cluster → `k8s:cluster:{name}`. `discovery.reconcile_discovered` auto-merges and re-points existing signals (ISE-205 precedent).
- AWS resource tags into the tag pool (ADR 0037 — tag-derived groups for free).
- Deterministic edges where cheap: EKS nodegroup instances `part-of` cluster; ALB `routes-to` target instances where the target-health API makes it cheap.
- Migration adding `load-balancer` + `bucket` entity types + the full ENTITY_TYPES tax: openapi regen (`dump_openapi` + `npm run generate:api`), 5 frontend enum files (EstatePage, SystemDetailPage, EntityDetailPage, EntityGraphView icon map, TagDictionaryCard), retire windows in `settings.py`. Type map: EC2→host, RDS→database, EKS→cluster, ELB/ALB→load-balancer, S3→bucket.

**Done when:** AWS entities are visible and filterable in Estate + graph, and an EC2 instance already known to DataDog/K8s shows as ONE entity with aliases from all sources.