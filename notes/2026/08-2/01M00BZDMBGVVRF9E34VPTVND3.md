---
id: 01M00BZDMBGVVRF9E34VPTVND3
created: 2026-08-14T14:49:19.243698Z
updated: 2026-08-14T19:23:43.044738Z
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
- id: 01M00RRTE9WEF6H4BRDSEHE610
  author: Steve Vine
  at: 2026-08-14T18:32:54.473257Z
  text: |-
    **Correction — the first cut of this was wrong, and CI caught it.** Recording it because the mistake is the interesting part.

    I used "a value unique per entity cannot group anything" as the criterion. That is too blunt, and it denied two keys that are load-bearing:

    1. **`crossplane-name`** — three BA tests failed. It is a *governed rule key*: `crossplane-name:kora-db` is exactly how a Business Application rule names a specific database (ISE-664), and it is read in `business_applications.py`, `assist_tools.py` and `ruleDrafts.tsx`. One value per entity, and entirely legitimate.
    2. **`karpenter.sh/nodepool`** — no test caught this one; I found it grepping. It is the **precondition of the `karpenter-node-recycling` library playbook** shipped last sprint (ISE-715): `tag_keys contains karpenter.sh/nodepool`. Denying the domain would have stopped that playbook ever matching, **silently** — a green suite and a dead feature, exactly the failure mode ISE-499's sprint was about.

    **The corrected criterion: could an operator ever NAME this value?** Not how many distinct values it has. `aws_ec2_fleet-id:fleet-400c5126-…` is opaque; `kube_node:ip-172-21-104-167` is stale as soon as it is interesting because the provisioner recycles nodes. Those stay denied. `crossplane-name:kora-db`, `sensor-name:chinwag-build` and `eventsource-name:chinwag` are names a human types — kept.

    `karpenter.sh/nodepool` and `eks.amazonaws.com/nodegroup` are now in `ALLOWED_MACHINERY_KEYS`, the rescue mechanism the task said to keep. A nodepool is a grouping a human defined and named, unlike the nodeclaim and instance-shape labels around it; the two provisioners state the same fact, so rescuing one and not the other would have been an accident of which provisioner a cluster uses.

    Also verified, rather than assumed: DataDog's host↔node cross-key reads `kube_node` from the **raw** tag list before `parse` (`_host_identity`, ISE-205), so denying it in the pool costs the join nothing.

    **The process lesson:** I checked the live rule tables on staging before denying anything and found no conflicts — but staging's BA rules happen to be role-based (`key: null`), so the data did not show what the *code* supports. Reading the rows was not a substitute for grepping every consumer of each key. Did that second, and it is what found the playbook.
- id: 01M00VBX8XAM9SN7ZVJHVZM5Z8
  author: Steve Vine
  at: 2026-08-14T19:18:17.117124Z
  text: |-
    **Deployed to staging (ad7fb4ec) and verified against live data — the "Done when" is only PARTLY met, and the reason is not in this change.**

    Confirmed the deny-list is live in the running pods (`is_denied` returns True for `karpenter.sh/registered`, `karpenter.k8s.aws/instance-size`, `karpenter_nodepool`, `kube_node`; False for the rescued `karpenter.sh/nodepool` and for `crossplane-name`).

    **Pool count is dropping as syncs run, exactly as the no-backfill argument predicted:** 2,279 at sprint open → 2,227 → 2,017 → 1,950 over successive syncs. No migration, no backfill; the links simply go as each connector re-reports.

    **But 45 machinery tags are still in the cloud**, and `mp-geo:uk`/`mp-geo:us` sit at rank 96/97 under an entity sort rather than near the top. Every remaining one is on a **`host` entity asserted by a Kubernetes system**, and those `entity_tag` rows have not been rewritten — timestamps still read 12–14 Aug. The systems sync every 5 minutes and report `status: ok`, but a manual `sync_one` on `mgnt-production-uk-pri` returned **`estate.entities: 0`**: the connector reported no entities at all, so `reconcile_entity_tags` was never called for those nodes and their stale links survive.

    That is a discovery problem, not a tag-parsing one — the DataDog-asserted machinery cleared on its first sync, which is the same code path working. **Raising separately rather than widening this task**; it wants its own investigation (silent zero-entity Kubernetes discovery, the "sync death that reports ok" shape from ISE-379). The deny-list itself needs no further change: the integration test proves the mechanism, and it was checked by turning the fix off and watching it fail.

    **Verified on staging for the other four:** search `mp-geo` returns both tags (ISE-718, the bug that opened the sprint); entity sort brings them into view (ISE-717); `total=1950` against 200 items with `truncated=True` (ISE-720); `max_entity_count` and `max_alert_count` come back as separate denominators, 182 and 25 (ISE-716).
- id: 01M00VNVJ41608T5NVC7DBNTCS
  author: Steve Vine
  at: 2026-08-14T19:23:43.044508Z
  text: |-
    **Follow-up: it has plateaued, so it will not self-heal.** Re-measured ~40 minutes and many 5-minute sync cycles after the previous check: pool still 1,950, still 45 machinery tags in the cloud, `mp-geo:uk`/`mp-geo:us` still at rank 96/97. Identical numbers, not falling.

    That settles the earlier "hasn't been rewritten yet" into "will not be rewritten": the Kubernetes systems keep reporting `status: ok` with zero entities, so `reconcile_entity_tags` never runs for those node entities and their pre-deny-list `entity_tag` links persist indefinitely. Waiting longer will not fix it.

    Nothing further needed on this task — the deny-list is correct, live and proven, and the DataDog-asserted machinery cleared through the same code path on its first sync. The residue is entirely downstream of the zero-entity Kubernetes discovery, which needs its own investigation.
assignee: steve
label:
- improvement
priority: medium
task_status: review
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