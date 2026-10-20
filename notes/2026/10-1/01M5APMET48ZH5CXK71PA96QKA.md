---
id: 01M5APMET48ZH5CXK71PA96QKA
created: 2026-10-19T18:26:27.78008Z
updated: 2026-10-20T13:01:00.485962Z
type: task
title: A server, VM or load balancer found by discovery becomes a System technology asset, not an Application
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1125
sprint: sbkelqe
comments:
- id: 01M5CPD74F3FRF87W0S192QX88
  author: Steve Vine
  at: 2026-10-20T13:00:59.407546Z
  text: |-
    Merged in PR #1146 at 13:00 UTC on 2026-10-20 (main 1686ef75). Not yet on staging.

    **What changed:**
    - **Make asset** on a discovered resource now suggests **System** for:
      - servers and VMs: EC2 instances and Auto Scaling groups, Azure VMs and scale sets, Google Cloud VMs and instance groups, and domain-joined servers;
      - Kubernetes clusters: EKS, AKS and GKE;
      - load balancers: AWS, Azure load balancers and application gateways, and Google forwarding rules.
    - Web apps, functions, container services, Cloud Run and App Engine still suggest Application, and anything that holds data still suggests Datastore.
    - A domain-joined server is suggested as **On-premises**.
    - It stays a suggestion, and the assistant follows it when not told a kind.
    - Existing assets are unchanged. bstr-staging, ELM and mpazsqlvm3 still need correcting by hand.

    **Calls:** as in the task (application gateway and clusters count as System; domain-joined servers default to on-premises). Azure Firewall is not in the list. It wasn't in the task, so it still suggests Application.

    **Checks:**
    - A new unit test covers every kind, plus a guard that each listed kind is one a reader produces.
    - Integration assertions: `test_discovered` (EC2, EKS, ELB → System, Cloud) and `test_directory_discovery` (domain-joined → System, On-premises).
    - ruff and mypy clean; no migration, no API change.
    - CI: 29.1 min in all, backend-test 27.1. The frontend job didn't run, as it was a backend-only change.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Sprint 67 follow-up (Inventory discovery). Raised by Steve smoke-testing staging, 2026-10-19; load balancers added at his request the same day.

## Why

When someone makes a technology asset from a discovered server, the form suggests **Application** as its kind. A server is a **System**: the thing applications run on. Any asset made with the suggestion accepted is filed wrongly. That covers the register's counts, filters, and anything an auditor reads off the asset's kind.

On staging today, every asset made from a server is an Application: bstr-staging (an EC2 instance), ELM and mpazsqlvm3 (domain-joined servers). The two made from databases are correctly Datastores.

## What people see

- **Make asset on a discovered server or VM suggests System.** This covers:
  - AWS EC2 instances and Auto Scaling groups;
  - Azure virtual machines and scale sets;
  - Google Cloud VM instances and instance groups;
  - domain-joined servers from Active Directory or Entra ID.
- **Load balancers suggest System too** (Steve). This covers:
  - AWS load balancers (application, network and gateway);
  - Azure load balancers and application gateways;
  - Google Cloud's load-balancer front ends (forwarding rules).
  
  My call: an Azure application gateway is Azure's web load balancer, so it counts.
- **Kubernetes clusters (EKS, AKS, GKE) suggest System too.** My call: like a server, a cluster is the platform applications run on.
- **No change for the rest.** Web apps, function apps, Lambda functions, container services, Cloud Run, Cloud Functions and App Engine still suggest Application, and anything that holds data still suggests Datastore.
- **It stays a suggestion.** The person can still pick another kind before saving.
- **The assistant follows the same suggestion** when it makes an asset from a discovered resource and isn't told a kind.
- **Existing assets are not changed.** Compass can't tell an accepted suggestion from a deliberate choice, so the three staging assets above are corrected by hand (edit the asset).

### Also: where a domain-joined server is hosted

The same suggestion sets hosting to **Cloud** for everything, including domain-joined servers, whose hosting is unknown to the directory. ELM and mpazsqlvm3 show "Cloud · Directory · Domain-joined server". **Suggest On-premises for domain-joined servers** (my call): it's the common case, and a cloud VM that joins the domain is normally found by its cloud's own connection as well. Cloud servers keep Cloud.

## Notes (technical)

- The single source is the `prefill` in `core/discovery/reads.py`: `kind = datastore if review.holds_data(row) else application`, with `hosting=ContainerHosting.cloud` for all.
- Add a "suggested kind" to `review.py` next to `holds_data`: a set of resource kinds that map to `ContainerKind.system`. Use the reader constants:
  - servers: `aws.ec2` `INSTANCE_KIND`/`GROUP_KIND`, `azure.compute` `VM_KIND`/`SCALE_SET_KIND`, `gcp.compute` `VM_KIND`/`GROUP_KIND`, `directory.servers.SERVER_KIND`;
  - clusters: `aws.eks.KIND`, `azure.aks.KIND`, `gcp.gke.KIND`;
  - load balancers: `aws.elb.KIND`, `azure.network` `LOAD_BALANCER_KIND`/`GATEWAY_KIND`, `gcp.network.KIND`.
  
  Every entry_point kind lands in this set today, but list the kinds explicitly rather than keying on category, so a future entry point (an API gateway, say) is decided on its own.
- Hosting: `directory.server` → `ContainerHosting.on_prem`; everything else stays cloud.
- `ContainerModal.tsx` already takes `kind`/`hosting` from `prefill`, so no frontend logic changes. `assistant/tools/inventory_discovered.py` falls back to `prefill["kind"]`, so it follows automatically. Check its tool description doesn't say "application".
- No migration and no data fix.
- Tests:
  - the prefill for each server, cluster and load-balancer kind is system;
  - a web app is application, and a database is datastore;
  - a domain-joined server's hosting is on_prem.

**Done when:** on staging, Make asset opens with:
- Kind = System on a discovered EC2 instance, Azure VM, domain-joined server or AWS load balancer;
- Kind = Application on a web app;
- Hosting = On-premises on a domain-joined server.