---
id: 01KXXH7NHDX8HGSACT4Z6Q9BVK
created: 2026-07-19T15:52:05.421345041Z
updated: 2026-07-23T19:50:35.452138Z
type: task
title: DataDog contributes no estate entities (service-catalogue discovery)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 151
order: 0.0
sprint: skj7tft
comments:
- id: 01KY1X75DDHZBXBSZ6QM67CX76
  author: Steve Vine
  at: 2026-07-21T08:38:29.54922Z
  text: |-
    PR #149 → main, merged to staging.

    Investigation outcome: rather than establish whether this account's APM catalogue is empty vs. unparsed, the fix makes both cases moot — the APM catalogue alone can never be the only source, since an account that doesn't run APM legitimately has none.

    Three independent entity sources now, each contained so one failing doesn't cost the others (today a raising discover_entities aborts the whole sync for the system):
    1. APM service catalogue, as before.
    2. Monitor scope tags — a monitor names its subject in its query scope (the only place an ungrouped monitor names it) or in the groups it evaluates. An alerting-only account contributes services and hosts.
    3. Reporting hosts (HostsApi) → `datadog:host:{name}`, cross-keyed to `k8s:node:{name}`.

    Kube-scoped monitors deliberately mint nothing — those entities are Kubernetes' to own, and `_entity_key_from_group` already points a signal straight at them.

    Staging smoke test should confirm the end-to-end: DataDog entities appear in the estate KB, and a DataDog alert joins to its workload/host.
assignee: steve
label: null
priority: medium
task_status: done
---
**Follow-up (found in Sprint 13 smoke test, 2026-07-19).** On staging the estate knowledge base is populated by **Kubernetes/g5** (cluster, namespaces, workloads, nodes) but **DataDog contributes zero entities**, so the cross-tag harvest (ISE-127) never fires and DataDog signals don't join to their K8s workloads.

**Why it's DataDog-specific:** `DataDogConnector.discover_entities` enumerates only the **APM service catalogue** (`apis.services.list_service_definitions()`). Kubernetes discovery always yields entities; DataDog's yields nothing when the account has no APM service definitions — or when the v2 service-definitions response isn't parsed as expected. So no `datadog:service:*` entities are created, and the tier-1 cross-tag (K8s workload's `tags.datadoghq.com/service`) has nothing on the DataDog side to unify with.

**Note:** the per-sync `estate: {entities: 0, …}` counts in the worker log are **new-this-sync deltas**, not totals — they read 0 in steady state even when the graph is populated. Not evidence of emptiness.

**Investigate:**
- Does `list_service_definitions()` return anything on this DataDog account? Empty APM catalogue (expected 0, not a bug) vs. a response shape we don't parse (a bug).
- Should DataDog also derive entities from **monitor scope tags** (`service:` / `kube_deployment`/`kube_namespace`) and/or **hosts**, not only the APM catalogue — so a DataDog account that alerts on K8s workloads still cross-tags even without APM service definitions?
- Confirm end-to-end: once DataDog yields a `datadog:service:X` matching a K8s workload's cross-tag, they resolve to one entity (ISE-127 harvest) and a DataDog alert joins to the workload (ISE-128).

Estate KB area (ADR 0027/0028). Scope TBD after the investigation — likely a small connector change to broaden DataDog entity sources.