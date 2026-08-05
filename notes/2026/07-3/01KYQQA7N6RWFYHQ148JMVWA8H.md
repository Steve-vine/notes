---
id: 01KYQQA7N6RWFYHQ148JMVWA8H
created: 2026-07-29T19:58:36.198462Z
updated: 2026-08-05T19:02:04.219999Z
type: task
title: Azure resource discovery — resources become estate entities
project: 01KX671DATY39VW6GWK3M2T3DN
number: 365
sprint: s0d5f5q
blocked_by:
- 01KYQQ9YG6Z30R2E2R43WFPF30
comments:
- id: 01KYQZB9YW9VXJTACZZ82MKP6P
  author: Steve Vine
  at: 2026-07-29T22:18:59.93212Z
  text: |-
    Built and in review — PR #338 (feature/ise-365-azure-resource-discovery, stacked on #337), merged to staging.

    Discovery enumerates VMs → host, AKS → cluster, SQL servers + PostgreSQL/MySQL flexible servers → database, load balancers + application gateways → load-balancer, storage accounts → bucket, and App Services/Function Apps → workload. The entity-type question resolved as REUSE: App Services map onto the canonical workload type (kind-dictionary lesson), so the sprint needs NO migration and no api-types regen — the load-balancer/bucket bill was paid by AWS.

    Native keys azure:{subscription_id}:{resource_id}, lower-cased (ARM ids are case-insensitive with inconsistent casing between list APIs and alert payloads — pinning lowercase at the key boundary is what will let ISE-366 attribute alerts). Cross-keys: VM → datadog:host:{vm name} (the DataDog Azure integration's canonical hostname), AKS → k8s:cluster:{name}. routes-to edges from LBs to backend VMs via one NIC sweep, case-insensitive; app gateways deliberately edge-less (IP-backed pools). Per-provider failure containment. 9 new tests incl. the DataDog-join reconcile against real Postgres (one merged host entity, edges resolve to it).
- id: 01KYS1RMYHTCSSEVE8C6KT8RDS
  author: Steve Vine
  at: 2026-07-30T08:20:28.753598Z
  text: |-
    Live smoke test on staging (CSP Softcat subscription) found two defects in this task's slice — fixed on the branch (commit 3a838a0), chain re-merged, redeploying:

    1. VM discovery returned nothing: the subscription-wide virtualMachines list rejects $expand=instanceView outright (HTTP 400 "only supported when Virtual Machine Scale Set resource filter is applied"). Power state now comes from the dedicated statusOnly=true sweep (one extra list call), merged case-insensitively by resource id; a status-sweep failure costs only the power_state attribute, never the VMs. The test stub now behaves like ARM and 400s on $expand, so a regression reintroducing it fails loudly.

    2. Native keys are now bounded to varchar(300) via _bounded_key (readable prefix + sha256 digest, deterministic on both sides of a join) — a worst-case resource-group + resource name can push azure:{sub}:{resource_id} past the entity_alias.native_key column. Same helper backs the ISE-366 alert-key fix.
assignee: steve
label: null
priority: medium
task_status: done
---
Discovery sync (mirror of ISE-359): enumerate **VMs, Azure Database (SQL + PostgreSQL flexible servers), AKS clusters, Load Balancers + Application Gateways, Storage Accounts, App Services + Function Apps** → estate entities. Native keys `azure:{subscription_id}:{resource_id}` (account-scoped per ADR 0045). `cross_keys` joins onto the existing estate: VM ↔ DataDog hosts (Azure hostname/vm-id convention), AKS ↔ existing K8s cluster/node entities (ISE-205 precedent). Reuse the `load-balancer` and `bucket` entity types added by the AWS sprint (storage account → bucket); decide App Service / Function App entity type at build (reuse vs new — any ENTITY_TYPES change needs api-types regen + the ai-config test enumerates task types). Subscription/resource-group containment via part-of edges per the AWS account pattern; last-seen stamping for estate lifecycle.