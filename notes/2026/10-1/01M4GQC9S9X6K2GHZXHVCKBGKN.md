---
id: 01M4GQC9S9X6K2GHZXHVCKBGKN
created: 2026-10-09T16:19:13.833773Z
updated: 2026-10-10T14:40:36.851083Z
type: task
title: Compass also reads what runs things in AWS — servers, container services, clusters, functions and load balancers — and proposes them as parts of a technology asset
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 886
sprint: svsqcj9
blocked_by:
- 01M4GQBC18SVPP9FKTMQE1TN21
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Part of sprint 67, Inventory expansion (ADR in COM-881). The first reading task covers what holds data. This adds what runs things, which is how an application gets its parts.

## What people see

- **The Discovered tab gains new kinds:** servers (EC2), auto-scaling groups, container services (ECS), Kubernetes clusters (EKS), functions (Lambda) and load balancers.
- **Compass proposes "add to a technology asset" for these**, never "make a technology asset", because none of them holds data or is the thing a user signs into. The person can still choose otherwise.
- **One of these can be added to more than one technology asset.** A cluster or server that runs three applications is listed under all three.
- **An application is still named by a person.** AWS cannot say which servers and services make up "Kora"; someone makes the technology asset and adds its parts, or a rule does (the rules task).
- **Servers that come and go are not listed one by one.** An auto-scaling group is one resource showing how many servers it runs. A Kubernetes cluster is one resource showing its node count.
- **What Compass keeps about each:**
  - Servers: type, running or stopped, Linux or Windows, the image it was built from, when it was launched, whether it has a public address.
  - Container services: the cluster, how many copies run, the image names.
  - Kubernetes clusters: version, whether the control endpoint is public, whether secrets are encrypted.
  - Functions: runtime and when last changed.
  - Load balancers: internet-facing or internal, and the protocols it listens on.
- **Never read:** a function's environment variables, a container's environment or secrets, a server's start-up script.

## Notes (technical)

- **Readers added to the registry** from the first reading task, category `compute`, and `entry_point` for load balancers. The shipped policy gains their List / Describe actions; the registry-versus-policy test enforces it.
- **Auto Scaling.** Instances that belong to an Auto Scaling group are skipped as rows and counted on the group. The same for instances that belong to an EKS managed node group. Without this the Discovered tab fills with resources that are gone by the next read.
- **Terminated instances** are treated as gone, not as a state.
- **Excluded fields.** Drop Lambda `Environment`, ECS task definition `environment` and `secrets`, and EC2 `UserData` at the reader, before anything is stored. A test asserts none of those keys can appear in `facts` for these kinds.
- **Image names** from ECS task definitions are kept; registry credentials and image digests are not needed.
- **Many-to-many.** `technology_asset_resources` already allows several rows for a non-`datastore` resource; this task is the first to exercise it. Check the Discovered tab's "already attached" state reads sensibly for a resource with attachments that can still take more.
- **Kubernetes workloads are not read.** What runs inside a cluster needs the cluster's own API, not AWS's; out of scope here.
- **Volume.** An account can hold thousands of functions; confirm the list and the tab count stay paginated and indexed on `(company_id, review_state, kind)`.
- **Tests.** Reader tests against fake responses in AWS's shapes, including an Auto Scaling group with instances and a node group; the excluded-fields test; attaching one resource to two assets.

**Done when:** on staging, servers, services, clusters, functions and load balancers from the connected account appear in Discovered proposed as parts; one is added to two technology assets and shows under both.