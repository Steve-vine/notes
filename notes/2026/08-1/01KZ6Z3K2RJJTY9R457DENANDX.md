---
id: 01KZ6Z3K2RJJTY9R457DENANDX
created: 2026-08-04T18:03:23.608151Z
updated: 2026-08-07T10:57:29.864188Z
type: task
title: Kubernetes secret discovery has been silently inert in prod — the service account cannot list secrets
project: 01KX671DATY39VW6GWK3M2T3DN
number: 542
sprint: skxht3g
trashed: 2026-08-04T19:19:44.086621Z
assignee: steve
label: null
priority: high
task_status: backlog
---
Found by ISE-531's Platform Log within 15 minutes of its first deploy (2026-08-04) — a failure that had been running unseen and that nothing in the app could previously show.

```
WARNING ISE_api.connectors.kubernetes
kubernetes discovery: secrets unavailable: (403) Forbidden
secrets is forbidden: User "system:serviceaccount:ise-integration:ise"
cannot list resource "secrets" in API group "" at the cluster scope
```

Fires on every Kubernetes discovery sweep. Consequence: **ISE-517's `secret` entity type (migration 0091) has never populated in production.** The estate believes the cluster has no secrets, which is not a gap an operator can distinguish from "there are none" — the same shape as the AWS 403s that prompted ISE-531 and the Cloudflare Pages 400 of ISE-538.

## Root cause is a grant, not code

The connector degrades correctly — it warns and carries on, costing only that slice. The ClusterRole bound to `system:serviceaccount:ise-integration:ise` simply has no `list` on `secrets` at cluster scope. That RBAC is out-of-band cluster config, not in this repo's Helm chart (the integration service account is the one ISE *reads the cluster with*, distinct from the app's own).

## Decide before granting — this one deserves a moment

Cluster-wide secret **list** is a meaningful privilege, and ISE already treats secret material carefully (ADR 0018 envelope encryption, ADR 0010 redaction). Worth settling explicitly rather than reflexively:

1. **Does discovery need `list` on secrets at all, or only metadata?** `list` returns secret *values* in the response body, not just names. If the entity only needs name/type/namespace/age — which is all ISE-517 stores — then the grant is far larger than the need. Check whether a metadata-only path exists (`list` with `resourceVersion=0` still returns data; a `metadata.k8s.io` API-scoped read or a per-namespace narrower role may be the honest answer).
2. **If values do transit ISE**, confirm the redaction list covers them before the grant lands, and confirm nothing writes a secret body into `state_snapshot` payloads — snapshots are stored raw and are readable through the state-slice drill-in.
3. **Scope**: cluster-wide vs the namespaces ISE actually watches.

Prefer the narrowest option that makes the entity type work. A monitoring platform that can read every secret in the cluster is a different risk conversation from one that can name them.

## Also in scope — make the silence impossible again

Whatever is granted, the failing state must not read as "no secrets". Either the connector says so on the System page (the ISE-537 `schedule_warnings` shape is the precedent), or the Platform Log row is considered sufficient now that it exists. Decide which; do not leave it to the operator to notice an absence.

## Definition of done

Either `secret` entities appear in the estate from the live cluster, or a recorded decision that ISE will not read them and the connector stops attempting it (a warning every sweep for a capability we have chosen not to have is noise, not a signal).
