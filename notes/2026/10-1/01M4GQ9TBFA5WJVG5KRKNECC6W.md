---
id: 01M4GQ9TBFA5WJVG5KRKNECC6W
created: 2026-10-09T16:17:52.495417Z
updated: 2026-10-10T13:36:27.462699Z
type: task
title: 'ADR: discovery finds resources and a person decides what each one is — a technology asset, part of one, or nothing'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 881
sprint: svsqcj9
assignee: steve
label:
- brief
priority: high
task_status: todo
---
Part of sprint 67, Inventory expansion. Scoped with Steve 2026-10-08 and 09. This record gates every other task in the sprint.

ADR 0072 §17 ruled discovery out ("the register records what somebody is accountable for; CSV is the bulk path"). This ADR reverses that line and nothing else in 0072. Append-only: a new ADR at the next free number when it is written, with a pointer added to 0072 in the way its existing amendments are marked.

## What it settles (agreed with Steve)

- **Three layers.**
  - *Data assets* are the information itself. Always entered and judged by a person.
  - *Technology assets* are anything that **holds data** (a database server, storage, a SAN) or **surfaces data to users** (an application, a SaaS platform). They stand alone or depend on other technology assets.
  - *Discovered resources* are what a connection finds. Nobody types them.
- **The rule is by what a thing is, never by how many things use it.** A shared database is a technology asset that several applications depend on. Nothing is promoted or demoted when a second system starts or stops using it.
- **A discovered resource has three outcomes:** a new technology asset is made from it, it is added to an existing technology asset, or it is discarded with a reason and does not come back.
- **"Made into a technology asset" means a technology asset is created with the resource attached beneath it.** A database and its replicas, or a set of buckets, are one entry. When a database is rebuilt, the new resource is attached to the same asset, which keeps its owner, risks, decisions and history.
- **A discovered resource carries facts and nothing else.** No owner, no form, no reference number, no review cycle, no risk, no decision. This is what keeps Compass from becoming an asset register.
- **Risks and decisions stay on the technology asset.** What rolls up from resources is findings: things the connection observed.
- **A resource that holds data belongs to exactly one technology asset.** A resource that does not (a server, a cluster, a load balancer) may serve several.
- **Compass proposes, a person confirms.** Rules file later arrivals so nobody reviews them one by one.
- **AWS is the first source.** Entra applications, Azure and on-prem (Active Directory, Proxmox, Hyper-V, an existing management tool, or facts reported in) follow. The resource record must be provider-neutral so they reuse it.
- **Ruled out:** network scanning, an agent of Compass's own on each server, and Compass logging in to servers to look.

## To decide in the ADR (recommendations)

- **How Compass reaches AWS.** Compass assumes a read-only role in each connected account, with an external ID.
  - Compass's own AWS identity is the pod's where it has one (production on EKS), otherwise an access key entered once in the app. Staging on g5 has no pod identity.
  - Stored as the attachment store does it (ADR 0074): `core.secretbox`, write-only through the API.
- **Least privilege.** A shipped policy naming the List / Describe actions the sprint's readers use. Not AWS's `ReadOnlyAccess`, which can read bucket objects and table items.
- **What is never read or stored.** Contents of any kind, Lambda environment variables, ECS task environment and secrets, EC2 user data, connection strings, snapshots.
- **Tags** are stored and treated as untrusted display text.
- **A connection belongs to one company**, and an AWS account connects to one company.
- **Cadence.** Every six hours, and on demand.
- **Identity of a resource.** Its ARN.
- **Gone resources.** Kept and marked while attached to a technology asset. An unreviewed resource that goes simply leaves the list.
- **A failed read never marks anything gone.**
- **Category.** Each kind of resource is `datastore`, `compute` or `entry_point`. The category drives what Compass proposes and the one-home rule.
- **Permissions.** Connections need `inventory.admin`; decisions and rules need `inventory.manage_register`; reading needs `inventory.view`.
- **Global search** does not index discovered resources; they are not records.
- **Test seam.** One client factory that every AWS call goes through, faked in tests in the way `test_s3_storage.py` and `test_mail_ses.py` already do. No network in tests.

## Named as later, not this sprint

- Renaming the technology asset kinds to Third-Party and Self-Hosted (agreed in principle).
- Criticality taken from what depends on an asset, and an owner suggested from it.
- Checks driven by the classification of the data an asset holds, and any link from a finding to a control assessment.
- Operating systems on EC2 instances (needs Systems Manager).
- Every source other than AWS.

**Done when:** the ADR is merged and ADR 0072 points at it.