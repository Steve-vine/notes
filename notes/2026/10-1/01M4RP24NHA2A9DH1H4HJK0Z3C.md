---
id: 01M4RP24NHA2A9DH1H4HJK0Z3C
created: 2026-10-12T18:30:07.793424Z
updated: 2026-10-12T19:39:46.879944Z
type: task
title: Compass also reads what runs things in Azure — virtual machines, scale sets, Kubernetes clusters, web apps, function apps and container apps — and where traffic comes in
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 920
sprint: svsqcj9
blocked_by:
- 01M4RP1V03QB96VP4QJV8T6Z2S
comments:
- id: 01M4RT1NSZZ0KJFN3B75RZ98S4
  author: Me
  at: 2026-10-12T19:39:46.87979Z
  text: |-
    Merged to main (PR #922, 2026-10-12). Not on staging until you say.

    What to look at, after reading a subscription that has any of these: Inventory ▸ Discovered now also lists virtual machines, scale sets, AKS clusters, web apps, function apps, container apps, Azure load balancers and application gateways. Each is proposed as a part of a technology asset ("Add to an asset"), not as one, and the same one can sit beneath several assets.

    Things worth knowing:
    - A machine that belongs to a scale set is not listed; the scale set is, with how many servers it runs. Anything Kubernetes manages is counted on its cluster.
    - Two names differ from AWS's so the kind filter does not show the same word twice: "AKS cluster" (AWS has "Kubernetes cluster") and "Azure load balancer" (AWS has "Load balancer").
    - A web app's address (acme.azurewebsites.net) is kept, because it is how people recognise the app. Database addresses are not kept.
    - Never read: app settings, connection strings, a machine's start-up script, a cluster's credentials. The role cannot ask for them.

    One thing for you to decide, the same shape as the Lambda and ECS question on COM-886: Azure returns a container app's environment values in the same answer as its image names, and offers no narrower call. Secrets come back as references, but a plain value somebody should have made a secret does come back. Compass keeps the image names and drops the rest before anything is stored or logged, and a test holds it to that. If you would rather Compass could not see them at all, the action can come out of the role file by default; container apps would then show as a kind that could not be read. I have left it in. docs/azure/README.md says how a customer removes it.

    Technical: no migration. The role file grows from 12 actions to 22. A subscription connected before this needs its role updated (az role definition update with the file downloaded again), and until then says which kinds it may not read.
label:
- feature
priority: high
task_status: todo
---
Part of sprint 67, Inventory expansion (ADR in COM-917). Follows the reading of what holds data (COM-919).

## What people see

- **The Discovered tab also lists** virtual machines, scale sets, Kubernetes clusters, web apps, function apps, container apps, load balancers and application gateways found in a connected subscription.
- **These are proposed as parts of a technology asset, never as one**, exactly as the AWS ones are: they run something or let traffic in; they do not hold data. A person can always choose otherwise.
- **What Compass says about each:**
  - Virtual machine: size, operating system, whether it is running, whether it has a public address.
  - Scale set: size and how many servers.
  - Kubernetes cluster: version, whether its control endpoint is public and whether that is limited to named address ranges, node pools and nodes.
  - Web app and function app: whether it is running, whether it insists on HTTPS, its runtime, its address.
  - Container app: its images, whether it takes traffic from outside, how many copies.
  - Load balancer and application gateway: whether it faces the internet, what it listens on, and for a gateway whether its firewall is on.
- **Never read:** app settings, connection strings, container environment values, VM user data.

## Notes (technical)

- **Readers** in `core/discovery/azure/`: `compute` (VMs, scale sets), `aks`, `web` (web apps and function apps from one listing), `container_apps`, `network` (load balancers, application gateways). Categories `compute` and `entry_point`.
- A VM that belongs to a scale set is not listed twice.
- A VM's public address comes from one subscription-wide listing of network interfaces, not a call per machine.
- Container apps return environment values with the facts kept. The reader takes the image names and drops the rest; the ADR says so.
- The shipped role grows with the readers; the test holds the file to them.
- New fact labels in `review.py`.

**Done when:** on staging a read of a subscription with a VM or a web app shows it on the Discovered tab, proposed as a part.