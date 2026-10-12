---
id: 01M4RP24NHA2A9DH1H4HJK0Z3C
created: 2026-10-12T18:30:07.793424Z
updated: 2026-10-12T18:30:07.793424Z
type: task
title: Compass also reads what runs things in Azure — virtual machines, scale sets, Kubernetes clusters, web apps, function apps and container apps — and where traffic comes in
label: feature
priority: high
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 920
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