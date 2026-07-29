---
id: 01KYQQA7N6RWFYHQ148JMVWA8H
created: 2026-07-29T19:58:36.198462Z
updated: 2026-07-29T22:14:50.422772Z
type: task
title: Azure resource discovery — resources become estate entities
project: 01KX671DATY39VW6GWK3M2T3DN
number: 365
sprint: s0d5f5q
blocked_by:
- 01KYQQ9YG6Z30R2E2R43WFPF30
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Discovery sync (mirror of ISE-359): enumerate **VMs, Azure Database (SQL + PostgreSQL flexible servers), AKS clusters, Load Balancers + Application Gateways, Storage Accounts, App Services + Function Apps** → estate entities. Native keys `azure:{subscription_id}:{resource_id}` (account-scoped per ADR 0045). `cross_keys` joins onto the existing estate: VM ↔ DataDog hosts (Azure hostname/vm-id convention), AKS ↔ existing K8s cluster/node entities (ISE-205 precedent). Reuse the `load-balancer` and `bucket` entity types added by the AWS sprint (storage account → bucket); decide App Service / Function App entity type at build (reuse vs new — any ENTITY_TYPES change needs api-types regen + the ai-config test enumerates task types). Subscription/resource-group containment via part-of edges per the AWS account pattern; last-seen stamping for estate lifecycle.