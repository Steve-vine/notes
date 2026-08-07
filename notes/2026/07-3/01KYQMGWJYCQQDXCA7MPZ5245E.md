---
id: 01KYQMGWJYCQQDXCA7MPZ5245E
created: 2026-07-29T19:09:48.51072Z
updated: 2026-08-07T10:06:57.172543Z
type: task
title: AWS resource discovery — EC2/RDS/EKS/ELB/S3 as estate entities
project: 01KX671DATY39VW6GWK3M2T3DN
number: 359
sprint: sjyt01k
blocked_by:
- 01KYQMGNP8W4A1BJNYBHA65C94
comments:
- id: 01KYQTSX5A9022961HVPQGBK1D
  author: Steve Vine
  at: 2026-07-29T20:59:35.466215Z
  text: |-
    Built and shipped to review. PR #332 (stacked on #331; retarget to main after it merges), merged to staging.

    What landed: discover_entities() sweeping configured regions — EKS clusters (cross-key k8s:cluster:{name}), EC2 instances (cross-keys datadog:host:{instance-id} + k8s:node:{private-dns}, part-of their EKS cluster, terminated skipped), RDS, ALB/NLB (routes-to instance targets), S3 buckets (tag-blind, no per-bucket fan-out). Account-scoped keys aws:{account_id}:{arn}. Migration 0072 adds load-balancer + bucket entity types; five frontend enum/icon sites + api-types regenerated. Per-slice failure containment (one missing IAM permission ≠ dead discovery).

    Verified with a real-Postgres join test: a DataDog host named by instance id + the AWS-discovered instance resolve to ONE entity with both aliases, and the LB routes-to edge lands on the merged entity. Gates: ruff/mypy green, 37 backend tests, frontend build/vitest green.

    Smoke on staging: after a sync, Estate should show AWS resources under the new Load-Balancer/Bucket filters, and existing DataDog hosts should gain aws: aliases rather than duplicate rows.
assignee: steve
priority: medium
task_status: done
---
`discover_entities()` enumerating EC2, RDS, EKS, ELB/ALB, S3 across the configured regions.

- `EntityData` with `native_key = aws:{account_id}:{arn}` (account-scoped from day one — ADR 0045 trap).
- **Entity join, not duplication:** cross_keys — EC2 instance → `datadog:host:{instance-id}` (DataDog canonical host names are instance ids in this estate) and `k8s:node:{node-name}` for EKS nodes; EKS cluster → `k8s:cluster:{name}`. `discovery.reconcile_discovered` auto-merges and re-points existing signals (ISE-205 precedent).
- AWS resource tags into the tag pool (ADR 0037 — tag-derived groups for free).
- Deterministic edges where cheap: EKS nodegroup instances `part-of` cluster; ALB `routes-to` target instances where the target-health API makes it cheap.
- Migration adding `load-balancer` + `bucket` entity types + the full ENTITY_TYPES tax: openapi regen (`dump_openapi` + `npm run generate:api`), 5 frontend enum files (EstatePage, SystemDetailPage, EntityDetailPage, EntityGraphView icon map, TagDictionaryCard), retire windows in `settings.py`. Type map: EC2→host, RDS→database, EKS→cluster, ELB/ALB→load-balancer, S3→bucket.

**Done when:** AWS entities are visible and filterable in Estate + graph, and an EC2 instance already known to DataDog/K8s shows as ONE entity with aliases from all sources.