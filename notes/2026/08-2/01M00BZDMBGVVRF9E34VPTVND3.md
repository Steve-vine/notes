---
id: 01M00BZDMBGVVRF9E34VPTVND3
created: 2026-08-14T14:49:19.243698Z
updated: 2026-08-14T18:09:20.353986Z
type: task
title: platform machinery keys stay out of the tag pool
project: 01KX671DATY39VW6GWK3M2T3DN
number: 719
sprint: svc641e
comments:
- id: 01M00QDNF1EFXQ3Z6AH6DGD2M3
  author: Steve Vine
  at: 2026-08-14T18:09:20.353788Z
  text: |-
    Built — PR #668. The sweep was done against the live staging pool rather than from the task's list alone, and the numbers below are measured, not estimated.

    **Denied by domain**: `karpenter.sh`, `karpenter.k8s.aws`, `admission.datadoghq.com` (the task's list), plus four more of identical character found in the tail — `reconcile.external-secrets.io` (`created-by` is a 56-char content hash over 169 distinct values, the closest relative in the estate to `pod-template-hash`), `helm.sh` (chart+version strings), `nvidia.com` (GPU feature discovery — driver versions, a device-plugin timestamp), `pkg.crossplane.io` (provider/function names and revision hashes). And `eks.amazonaws.com`: it is the managed-nodegroup equivalent of `karpenter.sh/nodepool`, and treating one provisioner's bookkeeping as machinery and the other's as meaning would only be an accident of which one a cluster happens to use.

    **Denied by exact key**: `karpenter_nodepool` (the task's), plus identifiers-restated-as-tags — `aws_ec2_fleet-id` (112 distinct values over 115 entity links), `aws_ec2launchtemplate_id`, `kube_node` (117 over 117), `crossplane-name`, `sensor-name`, `eventsource-name`, `hidden-link`, and `last backup`/`last_backup`, which are timestamps and so churn the pool every night a backup runs.

    **The criterion the sweep used**, worth keeping: *a value unique per entity cannot group anything*. That is what separates a junk tag from a sparse one, and it is checkable from the pool without judgement calls.

    **Two deliberate non-removals, now pinned by their own tests so a later sweep does not undo the reasoning:**

    - `tags.datadoghq.com` **looks** like a machinery domain and is not. `tags.datadoghq.com/service` is the predicate of a live tag rule (the "Chinwag-v2" group) — denying the domain would have silently emptied that group. Checked the rule tables on staging before touching anything; no live tag rule or BA rule matches any family I denied.
    - `host` (199 variants) and `name` (92) are identity-restated-as-tag by the same criterion, but they are operator-visible and `Name` on AWS is set by hand. Removing them is a call for Steve, not a sweep to slip in — flagging rather than doing.

    **No backfill, verified rather than assumed.** New integration test migrates the exact scenario: a pool row written the way a pre-deny-list sync wrote it, then a re-sync through the reconciler that now denies the key. The `entity_tag` link goes, the orphaned `tag` row stays and is already excluded by the cloud's dead-row filter. I checked the test was worth having by removing `karpenter.sh` from the deny-list and confirming it fails.
assignee: steve
label:
- improvement
priority: medium
task_status: active
tech: null
---
`tags.py` already excludes label families that are platform bookkeeping rather than operator intent — `DENIED_KEYS` for per-revision hashes, `DENIED_KEY_DOMAINS` for `kubernetes.io` / `k8s.io`, with `ALLOWED_MACHINERY_KEYS` rescuing the handful of `app.kubernetes.io/*` recommended labels an operator actually chose (`app/backend/src/ISE_api/tags.py:37-92`).

Several families of exactly the same character were never added, and they now dominate the cloud's cold tail:

- `karpenter.sh/*` and `karpenter.k8s.aws/*` — nodepool and nodeclass names, instance-size/instance-cpu. Autoscaler bookkeeping.
- `karpenter_nodepool` — the DataDog-flattened spelling of the same thing, so the fact is in the pool twice.
- `admission.datadoghq.com/*` — injector state, not estate meaning.

The cost is not just noise. Ranking is `alert_count DESC, entity_count DESC`, and only 114 tags in the whole estate carry any alert over 7d — so 86 of the 200 cloud slots are decided purely on entity count, and these machinery keys win those slots on entity count alone. `admission.datadoghq.com/enabled` (38 entities) and `karpenter.k8s.aws/instance-size` (46) currently outrank `mp-geo:uk` (32), a key the org deliberately applies.

Extend `DENIED_KEY_DOMAINS` / `DENIED_KEYS` to cover these, keeping the existing rescue mechanism for anything genuinely meaningful.

**No migration or backfill needed** — verify this holds rather than assuming it. `reconcile_entity_tags` is set-replacement per (entity, system), so once `parse` drops the key the connector stops reporting it and the `entity_tag` links go on the next sync. The orphaned `tag` rows then have 0 entities and 0 alerts and are already excluded by the cloud's dead-row filter (`WHERE entity_count > 0 OR alert_count > 0`). Confirm with a populated integration test rather than trusting the reasoning.

Worth a wider sweep while in here: 2,279 tags are visible in the pool on staging and only 114 have ever carried an alert. Look for other autogenerated families in the tail before closing.

**Done when:** the karpenter and datadog-admission families no longer appear in the cloud, and the pool count drops materially from 2,279.