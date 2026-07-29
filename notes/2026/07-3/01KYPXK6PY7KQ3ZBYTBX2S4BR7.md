---
id: 01KYPXK6PY7KQ3ZBYTBX2S4BR7
created: 2026-07-29T12:29:07.166788Z
updated: 2026-07-29T12:30:10.023353Z
type: memo
title: Crossplane Twingate EC2 instance findings
tech:
- crossplane
- twingate
- aws
- disruptor
- ec2
---
Findings from investigating 31 leaked Twingate connector EC2 instances in env-staging (2026-07-29). Relevant to the Disruptor rewrite.

## Root cause

Commit `1d3887a` (2026-03-31, Disruptor M6.5) added to the EC2 `Instance` MR in `apis/twingate/tgconnector-comp-v2.yaml`:

```yaml
managementPolicies: ["Create", "Observe", "Delete"]
```

Intent was to drop `Update` to prevent ENI immutable field conflicts on connector recreation. But `managementPolicies` is an explicit allow-list, not a subtraction from the default — dropping `Update` **also dropped `LateInitialize`**.

Without `LateInitialize`, the `crossplane.io/external-name` annotation is not repopulated after a provider pod restart (crossplane/crossplane#5918). The MR then loses track of which instance it owns, Observe finds nothing, and Create fires a duplicate.

On 3–4 Jul 2026 the `provider-aws-ec2` pod restarted ~8 times. Each restart produced a fresh instance across all four connector MRs — 35 running where 4 were expected. Last leak at 14:24:45, six minutes after the current pod started (14:18:35); stable since. One MR (`envstaginguk` zone-zonea) tripped the `external-create-pending` safety brake at 07:26 and stayed `Synced=False` — that brake is the only thing that stopped it.

## The bind

| | external-name survives restart | recreation after termination works |
|---|---|---|
| `LateInitialize` **on** | yes | **no** |
| `LateInitialize` **off** | **no** | yes |

`LateInitialize` cannot simply be restored. It populates empty `spec.forProvider` fields from observed state — which for `aws_instance` includes `primaryNetworkInterfaceId`, `privateIp` and `availabilityZone`. Once pinned into desired state they are never cleared, so after the instance is terminated (ENI has `deleteOnTermination: true`) Crossplane tries to recreate against a dead ENI and a taken IP. **That is the original "ENI immutable field conflict".**

Note `Update` is *not* the problem — it is orthogonal to the leak. Also worth knowing: upjet **refuses** ForceNew updates rather than replacing (`refuse to update the external resource because the following update requires replacing it`), so `Update` can only ever produce a stuck MR, never a destroyed instance. The original fear may have been unfounded.

## Design implication

A bare `Instance` MR is the wrong primitive for anything intended to rotate. Crossplane wants a stable 1:1 MR↔resource mapping; rotation deliberately breaks it on a schedule.

**Preferred option: ASG + LaunchTemplate.** Crossplane manages the ASG and template (stable, no instance-specific fields). Rotation becomes AWS-native — terminate an instance and the ASG replaces it from the current template, Crossplane never sees it. Removes external-name fragility, ENI pinning and the duplicate-leak class in one move. Disruptor's job shrinks to "terminate an instance". One ASG per zone at desired capacity 1 preserves current HA shape; the per-zone Secrets Manager token model works unchanged.

Weaker alternative: Disruptor deletes the **MR** rather than the instance. Produces a clean rebuild (proven 2026-07-29) but leaves the leak risk on provider restart.

## Also relevant

- Connector tokens come from Secrets Manager keyed `{network}.{zone}.access-token` / `.refresh-token` — **per zone, not per instance**. All duplicates in a group boot with the same token, so Twingate only ever sees 4 connector identities. Refresh-token rotation means non-winning daemons likely can't re-authenticate.
- Twingate GraphQL `Connector` exposes `hostname`, `publicIP`, `privateIPs` — the reliable way to map a connector to its actual EC2 host.
- Crossplane tracks the instance in `status.atProvider.id`, not external-name. In 3 of 4 groups this differs from the Twingate-live host, so 7 instances (4 live + 3 tracked) are currently retained. Reconciling that mismatch belongs with this rewrite.
- Production and sandbox carry the identical config and blank external-names — same latent exposure, untriggered.

## State as of 2026-07-29

28 duplicates stopped (reversible, private IPs preserved), 7 running, all 4 connectors ALIVE throughout. Terminate after soak. Composition deliberately left unchanged pending this rewrite.
