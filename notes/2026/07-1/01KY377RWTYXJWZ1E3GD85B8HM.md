---
id: 01KY377RWTYXJWZ1E3GD85B8HM
created: 2026-07-21T20:52:49.69049Z
updated: 2026-07-23T18:32:54.691019Z
type: task
title: DataDog hosts are named by instance id/UUID — unrecognisable in the estate, and host↔node merge never fires
project: 01KX671DATY39VW6GWK3M2T3DN
number: 205
sprint: sbeam3b
comments:
- id: 01KY4GHAHF47VV8RG0S15NBGVV
  author: Steve Vine
  at: 2026-07-22T08:54:34.287084Z
  text: |-
    Done — PR #187 (feature/ise-205-datadog-host-naming), stacked on #186/ISE-204 because both rewrite `_reporting_hosts` and the `add()` helper. Targets the ISE-204 branch; retarget to main once that merges.

    **Naming (`connectors/datadog.py`).** New `_host_identity(name, aliases, tags)` returns `(display_name, node_name)`, preferring in order: the `kube_node:` tag value, then the friendliest alias, then the canonical name. `_MACHINE_HOST_NAME` recognises EC2 instance ids, SSM managed instances, and dashed/undashed UUIDs — those are the names DataDog's own UI hides. Aliases are sorted before choosing because DataDog does not guarantee their order, and an unstable display name would rewrite the estate every sync; shortest friendly alias wins, since DataDog carries both `web-3` and its FQDN and the bare form is what an operator reads.

    **The join.** The `k8s:node:` cross-key now comes from the `kube_node:` tag when present, falling back to the hostname. The canonical name stays the native key, as the task specified — it is what a `host:` scope tag carries, so re-keying would orphan every existing alias and host-scoped signal. `_reporting_hosts` now returns a `DiscoveredHost` dataclass keeping the three names apart (canonical / display / node) rather than a name+tags tuple.

    Worth noting: preferring `kube_node:` for the display name also makes the merged entity agree with what Kubernetes independently calls the node, so post-merge the two integrations have no name left to fight over.

    **Two supporting fixes the task did not anticipate, without which neither half lands.**

    1. `add()` unioned `cross_keys` instead of first-write-wins. Monitor scopes run first and know a host only by its canonical name, so `setdefault` was silently discarding the host list's cross-key — the only one that could ever match. It also gained a `names_it` flag so the host list (the sole source that can see aliases and `kube_node:`) wins the display name regardless of which source ran first.

    2. `Entity.name` was creation-only in `reconcile_discovered`, so the 201 hosts already minted under their instance ids would have kept them forever and this fix would have been invisible on staging until those rows were pruned. Name is now re-observed like `attributes` (ISE-179) — but **only while a single integration knows the entity**. That is the uncontested case and the whole of the problem. ISE has no rule for whose name wins when several integrations know a thing, and last-writer-wins across two sync cadences would rename the row on every pass; a stable imperfect name beats a flapping one. Flagging it as a deliberate limit rather than an oversight — if a naming-precedence rule is ever wanted, that predicate is the seam.

    **Tests** — `tests/test_connector_discovery.py` (6 new), `tests/integration/test_discovery.py` (4 new). Connector: `kube_node:` drives the cross-key while identity stays canonical; machine-named host displays its friendliest alias; a UUID host with no usable alias keeps its canonical name; a self-managed host behaves exactly as before; a monitor scope beats neither the name nor the join and both cross-keys survive; identity stable across alias reorderings. Integration: instance-id host renamed once aliases arrive; a contested name is not rewritten; DataDog host merges with its Kubernetes node via kube_node — plus the pinned inverse, that keying on the canonical hostname leaves the two strangers (the bug as it stood).

    Full backend suite green (856 passed), ruff + format + mypy strict clean.

    **For the smoke test:** existing staging entities keep their instance-id names until the next DataDog sync renames them in place. The merge only fires for hosts whose DataDog twin actually reports a `kube_node:` tag — the task's suggested check (does `g5` now merge and inherit its twin's tags) depends on that tag being present on the twin, which is worth confirming on staging.
assignee: steve
label: null
priority: medium
task_status: done
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