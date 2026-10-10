---
id: 01M4GQC9S9X6K2GHZXHVCKBGKN
created: 2026-10-09T16:19:13.833773Z
updated: 2026-10-10T15:17:20.577384Z
type: task
title: Compass also reads what runs things in AWS — servers, container services, clusters, functions and load balancers — and proposes them as parts of a technology asset
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 886
sprint: svsqcj9
blocked_by:
- 01M4GQBC18SVPP9FKTMQE1TN21
comments:
- id: 01M4K67M9EYS0KAYR9XTZ0FXT2
  author: Steve Vine
  at: 2026-10-10T15:17:18.254663Z
  text: |-
    Merged to main (PR #894, 2026-10-10). On staging once all ten tasks are in Review.

    What to look at:
    - After a read, the Discovered tab also lists servers, auto-scaling groups, container services, Kubernetes clusters, functions and load balancers. Each is proposed as "Part of one", not as a technology asset. Opening one still offers all three decisions.
    - The tab has an Attached chip. It lists what sits beneath a technology asset and which. A part that does not hold data can be opened there and added to another asset. The same parts are offered by Add resource on an asset's page.
    - A part added to two assets shows under both, and each says "Also serves" the other.
    - Servers in an auto-scaling group are not listed; the group is, with how many servers it runs. A Kubernetes cluster shows its node count. Terminated servers are not listed.

    One thing to know and decide, because the task said "never read" and that is not strictly achievable for two of these:
    - AWS returns a function's environment variables in the same answer that lists the functions. There is no other complete way to learn which functions exist.
    - AWS returns a container's environment values and secret references in the same answer that gives a service's image names.
    Compass takes only the facts it keeps (runtime and last change; image names) and discards the rest before anything is stored or logged. A test runs every reader over a made-up account carrying such values and checks none of them survive. But the role does let Compass see them in passing. If you would rather it could not, those two permissions can be taken out of the role template: functions and container services would then show as "could not be read" and everything else carries on. Say if you want that as the default.

    A server's start-up script and a function's code are never asked for, and the role does not allow it.

    Differences from the task text:
    - AWS's own tags (such as the CloudFormation stack name) are kept on every resource, so a rule can file a whole stack.
    - Kubernetes workloads inside a cluster are not read, as planned.

    Technical: migration 0235 (index by company, state and kind). Six readers added under core/discovery/aws/. docs/aws/README.md explains the two permissions above and how to withhold them.
assignee: steve
label:
- feature
priority: medium
task_status: review
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