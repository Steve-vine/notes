---
id: 01M4RTZ8Q9HXC84JEJ3D6XS8BG
created: 2026-10-12T19:55:56.521354Z
updated: 2026-10-12T19:56:00.436988Z
type: task
title: 'ADR: Google Cloud is the third source — a project is read as a service account of its own, with a role that names what it may see'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 924
sprint: s70gjk2
assignee: steve
label:
- brief
priority: high
task_status: todo
---
Part of sprint 69, Inventory discovery - GCP. Steve, 2026-10-12: "This builds on the previous work for discovery of cloud assets, this time for GCP." This record gates the other tasks in the sprint.

ADR 0099 settled what a discovered resource is and what a person does with it; ADR 0103 gave it a second source. Everything above the readers is the same for a third. This record settles only the parts that are Google Cloud's own.

## What it decides

- **How Compass signs in.** Each connected project has a service account and a key for it: a file Google hands over once. It is entered when the project is connected and kept the way an AWS access key and an Azure client secret are: encrypted, write-only, replaceable, never read back. This is the "its own user" way (ADR 0101) and the only way offered in this sprint.
- **Google may refuse to make a key.** Organisations created since 2024 block service account keys by default. A customer in that position must allow keys for the project before they can connect it, and the set-up steps say so in plain words. Signing in without a stored key is named as later.
- **What the service account may see.** A custom role Compass ships, naming each permission the readers use. Not Google's basic Viewer role, which can read the configuration of everything in the project.
- **Compass asks only for the facts it keeps.** Google lets a request name the fields it wants back, so a machine's start-up script or a service's environment values are never sent to Compass at all. AWS and Azure offer no such thing; there Compass drops them on arrival.
- **What is never read or stored.** The contents of anything (objects, rows, documents), database users and passwords, environment values, start-up scripts and SSH keys, cluster credentials.
- **A project connects to one company**, states Production or Non-production, and is read whole: Google lists a kind once for the project, so there is no region choice.
- **A service the project has never switched on reads as "none found"**, not as a failure.
- **What it reads first.** Holds data: Cloud Storage buckets, Cloud SQL instances, Firestore databases, BigQuery datasets, Spanner instances. Runs things: VMs, managed instance groups, GKE clusters, Cloud Run services, functions, App Engine services. Lets traffic in: load balancers.
- **An organisation can be connected once**, to list its projects and offer each for connection, as an AWS organisation and an Azure tenant are.
- **A key has no end date unless the customer's organisation gives it one.** When Google refuses a sign-in because the key was deleted or has expired, Compass says exactly that.
- **What it is called on screen:** "Google Cloud", which is Google's own name for it.
- **The resource record points at its connection one way.** ADR 0103 named a third source as the point at which two connection columns should become one relation. This record decides that shape; the work is the next task.

## Notes (technical)

- `decisions/NNNN-*.md`, the next free number (0104 when this was written; check, a peer session may have taken it). Amends ADR 0099 §13 and closes ADR 0103's "a third source will want the same again". Builds on ADR 0101 and ADR 0074.
- **Start after COM-921, COM-922 and COM-923 are on main.** The organisation task follows the tenant's shape and the readers use the capitals rule.
- For implementers: `core/gcp.py` is the one place a request to Google is made and the test seam (httpx `MockTransport`, as `core/azure.py`). No Google client library and no new dependency: the token request is a JWT signed with the key, and `pyjwt` and `cryptography` are already in.
- Readers are a registry in `core/discovery/gcp/`, joined in `core/discovery/sources.py`. `provider` is `gcp`; `account_ref` is the project ID.
- `native_id` is Google's full resource name, with the project always written as its ID. Some APIs answer with the project number, so the same resource can arrive spelled two ways.
- A read-only token (`cloud-platform.read-only`) is asked for wherever the API accepts it. Not every API does (Cloud SQL's is believed not to), so the role is what holds, not the scope. Confirm per API.
- "API not enabled" is a 403 with reason `SERVICE_DISABLED`. For some APIs it is judged against the service account's home project, not the project read. A refusal that names a different project is a set-up fault, not "none found". Confirm against a real project.
- Tables: `gcp_connections`, `gcp_organisations`, `gcp_organisation_projects`.
- Alternatives to record: Cloud Asset Inventory as the single source (one permission reads every kind: ADR 0103's Resource Graph argument); the basic Viewer role; Google's client libraries; workload identity federation now (production runs in EKS and could federate, staging on g5 could not); a BigQuery table rather than its dataset as the resource; what stands for a load balancer, since Google has no single resource for one.

**Done when:** the ADR is merged.