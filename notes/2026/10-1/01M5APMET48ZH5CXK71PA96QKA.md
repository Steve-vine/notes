---
id: 01M5APMET48ZH5CXK71PA96QKA
created: 2026-10-19T18:26:27.78008Z
updated: 2026-10-19T18:26:29.714086Z
type: task
title: A server or VM found by discovery becomes a System technology asset, not an Application
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1125
sprint: sbkelqe
assignee: steve
label:
- bug
priority: medium
task_status: todo
---
Sprint 67 follow-up (Inventory discovery). Raised by Steve smoke-testing staging, 2026-10-19.

## Why

When someone makes a technology asset from a discovered server, the form suggests **Application** as its kind. A server is a **System**: the thing applications run on. Any asset made with the suggestion accepted is filed wrongly. That covers the register's counts, filters, and anything an auditor reads off the asset's kind.

On staging today, every asset made from a server is an Application: bstr-staging (an EC2 instance), ELM and mpazsqlvm3 (domain-joined servers). The two made from databases are correctly Datastores.

## What people see

- **Make asset on a discovered server or VM suggests System.** This covers:
  - AWS EC2 instances and Auto Scaling groups;
  - Azure virtual machines and scale sets;
  - Google Cloud VM instances and instance groups;
  - domain-joined servers from Active Directory or Entra ID.
- **Kubernetes clusters (EKS, AKS, GKE) suggest System too.** My call: like a server, a cluster is the platform applications run on.
- **No change for the rest.** Web apps, function apps, Lambda functions, container services, Cloud Run, App Engine, load balancers and application gateways still suggest Application, and anything that holds data still suggests Datastore.
- **It stays a suggestion.** The person can still pick another kind before saving.
- **The assistant follows the same suggestion** when it makes an asset from a discovered resource and isn't told a kind.
- **Existing assets are not changed.** Compass can't tell an accepted suggestion from a deliberate choice, so the three staging assets above are corrected by hand (edit the asset).

### Also: where a domain-joined server is hosted

The same suggestion sets hosting to **Cloud** for everything, including domain-joined servers, whose hosting is unknown to the directory. ELM and mpazsqlvm3 show "Cloud · Directory · Domain-joined server". **Suggest On-premises for domain-joined servers** (my call): it's the common case, and a cloud VM that joins the domain is normally found by its cloud's own connection as well. Cloud servers keep Cloud.

## Notes (technical)

- The single source is the `prefill` in `core/discovery/reads.py`: `kind = datastore if review.holds_data(row) else application`, with `hosting=ContainerHosting.cloud` for all. Add a "suggested kind" to `review.py` next to `holds_data`: a set of server/cluster resource kinds → `ContainerKind.system`. Use the reader constants:
  - `aws.ec2` `INSTANCE_KIND`/`GROUP_KIND`, `aws.eks.KIND`;
  - `azure.compute` `VM_KIND`/`SCALE_SET_KIND`, `azure.aks.KIND`;
  - `gcp.compute` `VM_KIND`/`GROUP_KIND`, plus the GKE cluster kind;
  - `directory.servers.SERVER_KIND`.
- Hosting: `directory.server` → `ContainerHosting.on_prem`; everything else stays cloud.
- `ContainerModal.tsx` already takes `kind`/`hosting` from `prefill`, so no frontend logic changes. `assistant/tools/inventory_discovered.py` falls back to `prefill["kind"]`, so it follows automatically. Check its tool description doesn't say "application".
- No migration and no data fix.
- Tests: the prefill for each server/cluster kind is system, a web app is application, a database is datastore; a domain-joined server's hosting is on_prem.

**Done when:** on staging, Make asset on a discovered EC2 instance, Azure VM or domain-joined server opens with Kind = System, and on a web app with Kind = Application; a domain-joined server opens with Hosting = On-premises.