---
id: 01M4RTZ8Q9HXC84JEJ3D6XS8BG
created: 2026-10-12T19:55:56.521354Z
updated: 2026-10-14T20:41:36.629157Z
type: task
title: 'ADR: Google Cloud is the third source — a project is read as a service account of its own, with or without a stored key, and a role that names what it may see'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 924
sprint: s70gjk2
comments:
- id: 01M4S2GGZH3R29A0GVARXMDA6P
  author: Steve Vine
  at: 2026-10-12T22:07:42.065853Z
  text: |-
    Merged to main (PR #927, 2026-10-12). ADR 0104, decisions/0104-google-cloud-is-the-third-source.md. Nothing to look at on staging: it is the record the other seven tasks build to.

    My calls in it, yours to overturn:
    - Two ways to sign in, chosen per project: a key file, or without a stored key. The key file is offered first, as "its own user" is for AWS.
    - Without a stored key rests on the AWS identity Compass already has. In production nothing long-lived is stored anywhere. On staging that identity is an access key somebody entered, so it is the one thing every project connected this way trusts. The screen will say which applies.
    - Nothing stands where AWS's external ID stands for the keyless way. A project that trusts Compass's identity would answer to any company in the same deployment that typed its details. Accepted because a project can be connected only once, only Inventory admins connect, and a deployment's companies are one organisation's own.
    - A custom role naming each permission, not Google's basic Viewer.
    - Compass asks Google only for the facts it keeps, so start-up scripts, environment values and cluster credentials are never sent to it. This is stronger than AWS or Azure allow.
    - A Cloud SQL instance is the resource, not its databases. A BigQuery dataset, not its tables. A load balancer is Google's "forwarding rule".
    - A Cloud Run service or function anyone can call is a fact, not a finding. A bucket or dataset anyone can read is a finding.
    - Projects Google makes by itself for Apps Script are left out of an organisation's list.

    One change from the task text: the shared connection row (COM-925) is thinner than I first described. It says only that a connection exists and which provider it belongs to. Names, health and read state stay where they are, so the working AWS and Azure code is not rewritten.
assignee: steve
label:
- brief
priority: high
task_status: done
---
Part of sprint 69, Inventory discovery - GCP. Steve, 2026-10-12: "This builds on the previous work for discovery of cloud assets, this time for GCP." This record gates the other tasks in the sprint.

ADR 0099 settled what a discovered resource is and what a person does with it; ADR 0103 gave it a second source. Everything above the readers is the same for a third. This record settles only the parts that are Google Cloud's own.

## What it decides

- **How Compass signs in: two ways, chosen per project.** Steve, 2026-10-12: "Add signing in without a stored key to this sprint."
  - **With a key file.** Each connected project has a service account and a key for it: a file Google hands over once. It is entered when the project is connected and kept the way an AWS access key and an Azure client secret are: encrypted, write-only, replaceable, never read back. This is the "its own user" way (ADR 0101).
  - **Without a stored key.** Compass proves who it is with the AWS identity it already has, and the project is set up to trust exactly that identity and let it act as a read-only service account. Compass stores nothing of Google's. This is the counterpart of the AWS "role that trusts Compass" way.
- **Why both.** Organisations created since 2024 block service account keys by default, so for many customers the key file is not available without changing a policy. And a deployment with no AWS identity cannot use the other way. Neither covers everyone.
- **What "no stored key" honestly means.** Where the platform gives Compass its AWS identity (production), nothing long-lived is stored anywhere. Where that identity is an access key someone entered (staging), that one key is what every project connected this way trusts: the position ADR 0101 was written to avoid for AWS. The screen says which applies.
- **What the service account may see.** A custom role Compass ships, naming each permission the readers use, the same file for both ways. Not Google's basic Viewer role, which can read the configuration of everything in the project.
- **Compass asks only for the facts it keeps.** Google lets a request name the fields it wants back, so a machine's start-up script or a service's environment values are never sent to Compass at all. AWS and Azure offer no such thing; there Compass drops them on arrival.
- **What is never read or stored.** The contents of anything (objects, rows, documents), database users and passwords, environment values, start-up scripts and SSH keys, cluster credentials.
- **A project connects to one company**, states Production or Non-production, and is read whole: Google lists a kind once for the project, so there is no region choice.
- **A service the project has never switched on reads as "none found"**, not as a failure.
- **What it reads first.** Holds data: Cloud Storage buckets, Cloud SQL instances, Firestore databases, BigQuery datasets, Spanner instances. Runs things: VMs, managed instance groups, GKE clusters, Cloud Run services, functions, App Engine services. Lets traffic in: load balancers.
- **An organisation can be connected once**, either way, to list its projects and offer each for connection, as an AWS organisation and an Azure tenant are.
- **A key has no end date unless the customer's organisation gives it one.** When Google refuses a sign-in because the key was deleted or has expired, Compass says exactly that.
- **What it is called on screen:** "Google Cloud", which is Google's own name for it.
- **The resource record points at its connection one way.** ADR 0103 named a third source as the point at which two connection columns should become one relation. This record decides that shape; the work is the next task.

## Notes (technical)

- `decisions/NNNN-*.md`, the next free number (0104 when this was written; check, a peer session may have taken it). Amends ADR 0099 §13 and closes ADR 0103's "a third source will want the same again". Builds on ADR 0101 and ADR 0074.
- **Start after COM-921, COM-922 and COM-923 are on main.** The organisation task follows the tenant's shape and the readers use the capitals rule.
- For implementers: `core/gcp.py` is the one place a request to Google is made and the test seam (httpx `MockTransport`, as `core/azure.py`). No Google client library and no new dependency: the key-file token request is a JWT signed with the key (`pyjwt` and `cryptography` are already in), and the keyless one is a SigV4-signed request that botocore already signs.
- **Without a stored key is workload identity federation with an AWS provider**, then acting as a service account (COM-931). The record must say three things about it:
  - The trust pins Compass's exact role or user, not its AWS account.
  - Nothing stands where AWS's external ID stands. A project that trusts Compass's identity would answer to any company in the deployment that typed its details. Say what is accepted and why (a project ID is unique across the deployment; only Inventory admins connect; removal tells the person to delete the trust), or record something better.
  - Impersonation rather than granting the role to the federated principal directly, because some Google APIs refuse a federated token.
- Readers are a registry in `core/discovery/gcp/`, joined in `core/discovery/sources.py`. `provider` is `gcp`; `account_ref` is the project ID.
- `native_id` is Google's full resource name, with the project always written as its ID. Some APIs answer with the project number, so the same resource can arrive spelled two ways.
- A read-only token (`cloud-platform.read-only`) is asked for wherever the API accepts it. Not every API does (Cloud SQL's is believed not to), so the role is what holds, not the scope. Confirm per API.
- "API not enabled" is a 403 with reason `SERVICE_DISABLED`. For some APIs it is judged against the service account's home project, not the project read. A refusal that names a different project is a set-up fault, not "none found". Confirm against a real project.
- Tables: `gcp_connections`, `gcp_organisations`, `gcp_organisation_projects`.
- Named as later: trusting the cluster's own Kubernetes identity instead of an AWS one, which would give a deployment with no AWS identity a keyless way (it needs the cluster's issuer to be reachable by Google, or its signing keys uploaded by hand); Compass running in Google Cloud with an identity from the platform.
- Alternatives to record: Cloud Asset Inventory as the single source (one permission reads every kind: ADR 0103's Resource Graph argument); the basic Viewer role; Google's client libraries; the key file as the only way; the keyless way as the only way; a BigQuery table rather than its dataset as the resource; what stands for a load balancer, since Google has no single resource for one.

**Done when:** the ADR is merged.