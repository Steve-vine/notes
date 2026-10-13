---
id: 01M4RV1HCMV8DTNRKNZEM62T11
created: 2026-10-12T19:57:10.932978Z
updated: 2026-10-13T00:26:47.431033Z
type: task
title: Compass also reads what runs things in Google Cloud — VMs, instance groups, GKE clusters, Cloud Run services, functions and App Engine services — and where traffic comes in
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 928
sprint: s70gjk2
blocked_by:
- 01M4RV0ZNHKCXFC0EF7Q2G7D4M
comments:
- id: 01M4SAF43QC7KXMQM33APJ9DE5
  author: Steve Vine
  at: 2026-10-13T00:26:44.727158Z
  text: |-
    Merged to main (PR #932, 2026-10-13). Not on staging until the whole sprint is in review.

    What to look at, after reading a project that has any of these: Inventory ▸ Discovered now also lists Compute Engine VMs, managed instance groups, GKE clusters, Cloud Run services, Cloud Functions, App Engine services and Google Cloud load balancers. Each is proposed as a part of a technology asset ("Add to an asset"), not as one, and the same one can sit beneath several assets.

    Things worth knowing:
    - Nothing is listed twice. A machine that belongs to an instance group is counted on the group. A group that GKE manages is counted on its cluster. A newer function, which Google runs as a Cloud Run service, is listed as the function.
    - Names that would repeat a word already in the kind filter say whose they are: "GKE cluster", "Compute Engine VM", "Cloud Function", "Google Cloud load balancer".
    - A load balancer here is what Google calls a forwarding rule: the part with an address, the ports it listens on, and whether it faces the internet. Google has no single thing called a load balancer.
    - A Cloud Run service and a function show whether anyone can call them without signing in. That is shown as a fact and will not raise a finding, since a public website is meant to be public.
    - Never asked for, so never sent to Compass: a machine's start-up script and SSH keys, a service's or a function's environment values, a cluster's certificate and credentials.

    My call, yours to overturn: Compass tells that a machine belongs to an instance group from its name (the group's name with four characters on the end) and where it is. Google records the real link only in the machine's metadata, alongside its start-up script, and Compass does not ask for any of that. The cost is that a machine somebody gave a name of its own inside a group will be listed on its own. It errs towards showing a thing rather than hiding it.

    Not looked at: whether Cloud Armor protects what is behind a load balancer. That means following several of Google's parts from one to the next and is left for later.

    Not tested against a real project. Two things here are the likeliest in the whole sprint to need a fix on first real read: how Compass asks for machines, groups and load balancers across every zone at once, and how it asks for Cloud Run services and functions across every region at once. If either is wrong the kind will say it could not be read, and nothing will be lost.

    Technical: no migration, no API change. The role file grows from 7 permissions to 18. A project connected before this needs its role updated from the current file.
assignee: steve
label:
- feature
priority: high
task_status: review
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