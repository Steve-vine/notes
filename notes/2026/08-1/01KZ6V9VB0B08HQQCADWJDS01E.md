---
id: 01KZ6V9VB0B08HQQCADWJDS01E
created: 2026-08-04T16:56:54.368661Z
updated: 2026-08-05T12:03:06.471254Z
type: task
title: Grant secrets read RBAC to the ISE service account on all six external clusters
project: 01KX671DATY39VW6GWK3M2T3DN
number: 541
sprint: skxht3g
comments:
- id: 01KZ73F4E2YC0MTRWWV1AB3FMA
  author: Steve Vine
  at: 2026-08-04T19:19:36.130634Z
  text: |-
    Confirmed live from the ISE-531 Platform Log, 2026-08-04 18:00 — this is now visible in-app rather than only in `kubectl logs`, which is the first thing that surface did on its first day.

    `kubernetes discovery: secrets unavailable: (403)` for `system:serviceaccount:ise-integration:ise`, still firing every sweep.

    I duplicated this ticket by accident (as ISE-542) before spotting it existed, and have deleted mine. It asked one question this ticket had already answered better: whether discovery needs `list` on secrets at all or only metadata. Your security note settles it — ISE reads metadata only, Kubernetes RBAC cannot express metadata-without-data for list/get, so the grant necessarily permits value reads and the not-reading is ISE's code contract. That is the right framing and it belongs here.

    One point from mine worth keeping, since this ticket does not cover it: **whatever is decided, the failing state must not read as "no secrets"**. Today a 403 and a genuinely secret-free cluster are indistinguishable on the estate — the same invisible-degradation shape as ISE-537 and ISE-538. If the answer for some clusters is "no grant, accept the gap", then the gap needs stating on the System page (the ISE-537 `schedule_warnings` shape is the precedent) rather than being left as an absence for an operator to notice. If the answer is "grant everywhere", the Platform Log row is arguably enough.
assignee: steve
label: null
priority: medium
task_status: done
---
**Config action for Steve — not ISE code.** Live-found 2026-08-04 on the Kubernetes re-enable: every external cluster's sync logs `kubernetes discovery: secrets unavailable: (403) Forbidden` (2 per sync × 6 clusters = 12 warnings per cycle). The ISE read service accounts predate ISE-517 (Secret entities, landed 2026-08-03), which added a cluster-wide secrets list to discovery.

## Effect until granted

- `secret` entity count is 0 from the six external clusters — the ISE-517 chain (workload → Secret → ExternalSecret, "what breaks if this rotates") is absent from exactly the clusters where it matters most.
- The warnings repeat every sync (~15 min × 6 clusters) — the recurring-warning noise ISE-531's Platform Log will surface prominently once it lands.
- Discovery otherwise degrades gracefully (by design) — everything else about the cluster sync is unaffected.

## What to grant

Add to the ISE read ClusterRole on each of: `env-production-uk-pri`, `env-production-us-pri`, `env-staging-uk`, `env-staging-us`, `mgnt-production-uk-pri`, `mgnt-staging-uk`:

```yaml
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["list", "get"]
```

**Security note for the change record:** ISE reads Secret **metadata only** — name, namespace, type, labels, annotations, referenced-by — and deliberately never the `data` values (ISE-517 design; Helm-release and SA-token Secrets are excluded by type at ingest). Kubernetes RBAC cannot express "metadata but not data" for list/get, so the grant necessarily *permits* value reads — the not-reading is ISE's code contract, worth stating wherever this grant is reviewed. If that's uncomfortable for the prod clusters, the alternative is excluding the secrets slice there and accepting the coverage gap — but the estate's rotation-impact question is most valuable precisely on prod.

The grant lives wherever the ISE SAs are provisioned (cluster bootstrap / Crossplane IaC — likely `devops.library.crossplane` or the cluster compositions; the SA manifests predate ISE-517 so whatever stamped them needs the added rule).

**g5 note:** the g5 System is still disabled (last of the seven). Its in-cluster SA will need the same grant when it's re-enabled — it's the cluster where ISE itself runs, and the one whose kind dictionary already maps ExternalSecrets.

## Acceptance

- A full sync cycle on all six clusters with zero `secrets unavailable` warnings
- `secret` entities present in the estate from external clusters, with workload → Secret → ExternalSecret edges on the graph
- Confirm Helm-release (`helm.sh/release.v1`) and SA-token Secrets are absent (the type exclusion working at scale — a busy prod cluster is the first real test of that filter's volume assumption)
