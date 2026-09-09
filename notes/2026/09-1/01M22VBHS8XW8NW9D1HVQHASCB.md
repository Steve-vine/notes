---
id: 01M22VBHS8XW8NW9D1HVQHASCB
created: 2026-09-09T10:27:57.864114Z
updated: 2026-09-09T10:28:23.713099Z
type: task
title: Old Project/env tags were never removed — 80 of 97 staging resources carry both tag schemes
project: 01KZTJ50S657DMMC3VFEFWN78V
number: 6
sprint: s6sx8uq
assignee: steve
label:
- bug
priority: high
task_status: todo
---
Found reviewing staging after the tagging release (CPL-2, PRs #62/#64). The `mp-*` migration is **additive, not a migration**: the new keys were applied, the old `Project` / `env` / `Env` keys were never removed, and Crossplane does not consider that drift.

## Evidence (envstaging, mgnt-staging-uk, 2026-09-09)

- 97 AWS managed resources. **80 still carry the old keys in AWS alongside the new ones.**
- Desired state is correct — `spec.forProvider.tags` holds only `Name`, `mp-project`, `mp-env`, `mp-geo` (plus upjet's `crossplane-*` tags).
- AWS holds both. Example, `network-envstaginguk-vpc`:
  - desired: `{Name, mp-env: staging, mp-geo: uk, mp-project: envstaging, crossplane-*}`
  - `status.atProvider.tags`: same **plus** `Project: envstaging`, `env: staging`
- The MRs report `Synced=True / ReconcileSuccess` (that VPC at 2026-09-09T10:03), so the provider sees no diff and will never prune them.

The correlation is exact: the only 17 clean resources are precisely the ones that had **no tags at all** before CPL-2 — the 2 LaunchTemplates, 6 addons, 2 AccessEntries, the PodIdentityAssociation, 2 twingate Policies, 2 InstanceProfiles and the 2 RDS Instances. Every resource that previously carried `Project`/`env` still carries it. Affected kinds: Role (21), Policy (11), Subnet (8), RouteTable (6), EIP (4), NATGateway (4), AccessPoint (4), Instance (4), VPC/IGW/Cluster/NodeGroup/OIDCProvider/FileSystem (2 each), SecurityGroup (3), Addon/SubnetGroup/ParameterGroup (1 each).

## This is not the throttling issue

PR #65 attributes "the old Project/Env tags never being removed" to IAM rate limiting. The evidence does not support that as the whole story: the rate cap has been in place since 26 Aug, these resources have reconciled successfully many times since, and the old keys are still there — including on EC2 and EFS resources, which are region-scoped and were never throttled. The rate cap fixed the Synced flapping; it did not fix the stale tags. Don't treat #65 as having closed this.

`providerconfig-aws-staging` has no `ignoreTags` or `defaultTags` — `spec` is just `credentials` — so this isn't provider configuration, it's how the provider reconciles tag maps.

## What to work out

1. Why the provider doesn't prune. Whether upjet's tag diffing treats extra external tags as ignorable, or whether removal needs an explicit trigger (a spec change on another field, or clearing `crossplane.io/external-name`-style forced reconcile). Test on one sandbox resource before touching anything wider.
2. How to clear the ~80 x 3 environments. Most likely a scripted one-off outside Crossplane — `aws ec2 delete-tags`, `aws iam untag-role` / `untag-policy`, `aws efs untag-resource`, `aws eks untag-resource`, `aws rds remove-tags-from-resource` — filtered on the key names, per account and region. Safe to run repeatedly, and the compositions are already correct so the keys will not come back.
3. Whether anything still consumes `Project` / `env`. Both schemes are currently valid, so cost reports and estate queries keyed on the old names still work today and will break the moment the cleanup runs. Check before, not after.

## Consequences while it sits

Duplicate, divergent tag schemes on the same resources. Anyone reading CLAUDE.md's "renaming a tag key is a delete + create at the AWS API" will believe the estate is migrated when it is not — that line is wrong for this provider and should be corrected as part of this ticket. Cost allocation on `mp-*` is correct; the old keys are noise that will drift as `mp-*` values are corrected (per CPL-3/CPL-7) and the stale copies are not.