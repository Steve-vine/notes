---
id: 01KY377RWTYXJWZ1E3GD85B8HM
created: 2026-07-21T20:52:49.69049Z
updated: 2026-07-21T21:38:22.702669Z
type: task
title: DataDog hosts are named by instance id/UUID — unrecognisable in the estate, and host↔node merge never fires
project: 01KX671DATY39VW6GWK3M2T3DN
number: 205
sprint: sbeam3b
assignee: steve
label:
- bug
priority: medium
task_status: backlog
---
Found on staging 2026-07-21 while chasing ISE-204. The estate holds 202 hosts: 201 DataDog-minted with names like `i-0d6411757748923e3` (EC2 instance id) or bare UUIDs, and one recognisable host (`g5`, the Kubernetes node). Zero hosts are known to both integrations — the host↔node merge has never fired.

**Two consequences of one cause** — `discover_entities` (`datadog.py`) uses DataDog's *canonical* host name (`name`/`host_name` from `list_hosts()`, or the `host:` scope tag) for both the entity name and the `k8s:node:<name>` cross-key:
1. **Unrecognisable estate**: DataDog's canonical name for an AWS host is the EC2 instance id (DataDog's own UI shows friendly aliases instead), so an operator can't find the host they know by name — Steve searched for a host he could see in DataDog and couldn't match it in ISE.
2. **Broken merge**: for an EKS/K8s host the actual node name is not the canonical hostname — it's carried in the host's `kube_node:` tag (e.g. `kube_node:ip-172-21-105-249.ec2.internal`). The cross-key `k8s:node:<instance-id>` matches nothing, so a DataDog host can never merge with the Kubernetes node entity it is. This is also why the `g5` node shows no DataDog tags even though its twin may report to DataDog.

**Fix shape:**
- Carry DataDog host **aliases** (`list_hosts()` returns them) — use a friendly alias for the entity display name, keep the canonical name as the native key so identity stays stable.
- Derive the `k8s:node:` cross-key from the host's `kube_node:` tag when present, falling back to the hostname; re-run discovery and confirm the g5 node merges with its DataDog twin and inherits its tags.
- Test: a host whose canonical name is an instance id but whose tags carry `kube_node:X` produces cross-key `k8s:node:X` and a display name from its aliases.

Related: ISE-204 (tag flapping — same discovery seam, distinct bug).