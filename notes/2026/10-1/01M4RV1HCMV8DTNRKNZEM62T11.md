---
id: 01M4RV1HCMV8DTNRKNZEM62T11
created: 2026-10-12T19:57:10.932978Z
updated: 2026-10-12T19:57:12.668732Z
type: task
title: Compass also reads what runs things in Google Cloud — VMs, instance groups, GKE clusters, Cloud Run services, functions and App Engine services — and where traffic comes in
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 928
sprint: s70gjk2
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Part of sprint 69, Inventory discovery - GCP (ADR in COM-924). Follows the reading of what holds data (COM-927).

## What people see

- **The Discovered tab also lists** VMs, managed instance groups, GKE clusters, Cloud Run services, functions, App Engine services and load balancers found in a connected project.
- **These are proposed as parts of a technology asset, never as one**, exactly as the AWS and Azure ones are: they run something or let traffic in; they do not hold data. A person can always choose otherwise.
- **What Compass says about each:**
  - VM: size, operating system where Google says, whether it is running, whether it has a public address.
  - Managed instance group: size and how many machines.
  - GKE cluster: version, whether its control endpoint is public and whether that is limited to named address ranges, node pools and nodes, whether Google runs the nodes (Autopilot).
  - Cloud Run service: its image, whether it takes traffic from outside, whether anyone can call it without signing in, its address.
  - Function: its runtime, what sets it off, whether anyone can call it without signing in.
  - App Engine service: its runtime, how many versions take traffic, its address.
  - Load balancer: whether it faces the internet, what it listens on, its address.
- **Nothing is listed twice.** A machine that belongs to an instance group is counted on the group, and a group that GKE manages is counted on its cluster. A function that Google runs as a Cloud Run service is listed as the function.
- **Names that would repeat a word already in the kind filter say whose they are:** "GKE cluster", "Google Cloud load balancer", "Compute Engine VM".
- **Never read, and never sent to Compass:** a machine's start-up script and SSH keys, a service's or a function's environment values, a cluster's credentials.

## Notes (technical)

- **Readers** in `core/discovery/gcp/`: `compute` (instances and managed instance groups, each one `aggregatedList`), `gke` (`locations/-`), `run` (`locations/-`), `functions` (`locations/-`), `appengine`, `network` (forwarding rules). Categories `compute` and `entry_point`.
- **The `fields` mask is what keeps secrets out.** `instances.aggregatedList` returns `metadata.items` (start-up scripts, SSH keys); a Cloud Run service and a function return environment values; a cluster returns `masterAuth`. None is in the mask, so Google never sends them. A test holds each mask to exactly the fields kept, and fails if one of those names appears.
- **A load balancer is a forwarding rule.** Google has no single resource for one; the forwarding rule is the part with an address, ports and a scheme (`EXTERNAL`, `EXTERNAL_MANAGED`, `INTERNAL…`). Global and regional rules come from one `aggregatedList`. Whether Cloud Armor protects what is behind it means walking proxy, URL map and backend service, and is left for later.
- **A VM's operating system** comes from its boot disk's licences in one project-wide `disks.aggregatedList`, not a call per machine. Unknown where the licence says nothing.
- **Who is in what.** A managed instance group names its instances through `listManagedInstances` per group; GKE's groups are recognised from the cluster's node pools (`instanceGroupUrls`). A second-generation function names the Cloud Run service beneath it (`serviceConfig.service`).
- **"Anyone can call it"** is the service's or function's IAM policy naming `allUsers` (one `getIamPolicy` per service). It is a fact, not a finding: a public website is meant to be public. Unknown, never false, if the policy cannot be read.
- **App Engine:** one application per project; `apps/{id}/services` and their versions. A project that has never created the application is an empty answer.
- The shipped role grows with the readers; the test holds the file to them. A project connected before this needs its role updated from the current file and until then says which kinds it may not read.
- New fact labels in `review.py`. "GKE", "Cloud Run", "App Engine", "Compute Engine" and "Google Cloud" join the capitals rule.
- No migration.

**Done when:** on staging a read of a project with a VM or a Cloud Run service shows it on the Discovered tab, proposed as a part.