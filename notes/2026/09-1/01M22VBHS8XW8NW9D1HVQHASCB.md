---
id: 01M22VBHS8XW8NW9D1HVQHASCB
created: 2026-09-09T10:27:57.864114Z
updated: 2026-09-10T07:20:12.139456Z
type: task
title: 'CORRECTED: old-tag audit was wrong — status.atProvider is stale; real scope is much smaller'
project: 01KZTJ50S657DMMC3VFEFWN78V
number: 6
sprint: s6sx8uq
comments:
- id: 01M251VZGZBGY39REH9PSSGKGC
  author: Steve Vine
  at: 2026-09-10T07:00:16.54157Z
  text: |-
    Root cause established by controlled experiment in staging, 2026-09-10. **The provider never removes tag keys.** Remediation must be out of band — this cannot be fixed from the compositions.

    ## The experiment

    Subject: `network-envstagingus-eip-zone-zonea` (EIP, `managementPolicies: ['*']`, tags have no functional effect). Parent `XNetwork` paused with `crossplane.io/paused=true` so the composition could not revert the spec edit; unpaused afterwards, XR back to `Synced=True ReconcileSuccess`.

    1. **Add** `mp-test: prune-check` to `spec.forProvider.tags` → appeared in AWS in **~15 seconds**, `Synced` stayed clean throughout.
    2. **Remove** `mp-test` from `spec.forProvider.tags` → **still present in AWS after 360s**, with `Synced=True` the whole time. No ReconcileError, no retry, no diff detected.

    So the write path is healthy and fast; the provider simply does not compute a diff for keys present in state but absent from config. Tag **values** update fine (the production promotion moved 86 resources from `mp-geo: ""` to `uk`/`us` in minutes). Tag **keys** are add-only.

    ## What this rules out

    The 24 Aug IAM throttling was not the cause. That was a real problem and #65 fixed it, but it is unrelated to the stale keys — this EIP is EC2, was never throttled, reconciles cleanly today, and still will not drop a key. Any remediation plan built on "re-drive the reconcile and it will clean itself up" is wrong.

    ## Consequences

    - The ~80 stale `Project`/`env` keys per environment can only be cleared by calling the AWS tag APIs directly. A composition change cannot do it. Neither can forcing reconciles, bumping resource versions, or re-rendering.
    - **Any future tag key rename is a one-way add.** The old key survives until someone untags out of band or the resource is replaced. This needs to go into CLAUDE.md as a standing constraint — the current line saying "renaming a tag key is a delete + create at the AWS API" is wrong and should be replaced.
    - Scope for the cleanup script is now firm: `aws ec2 delete-tags`, `aws iam untag-role` / `untag-policy` / `untag-instance-profile` / `untag-open-id-connect-provider`, `aws efs untag-resource`, `aws eks untag-resource`, `aws rds remove-tags-from-resource`, `aws s3api delete-bucket-tagging` (careful — that clears all bucket tags, so re-put instead). Per account and region: staging ~80, production ~79, sandbox unknown.
    - Safe to run repeatedly and safe to run any time: the compositions no longer reference the old keys, so nothing re-adds them.

    ## Debris from the test

    `mp-test: prune-check` is now a stray tag on `network-envstagingus-eip-zone-zonea` in the staging account, and by the very bug it demonstrates, Crossplane cannot remove it. Harmless, but it needs the same out-of-band untag as everything else:

    ```
    aws ec2 delete-tags --resources eipalloc-024926c3e33b90ae5 --tags Key=mp-test --region us-east-1
    ```

    Fold it into the cleanup pass, or run the one-liner. Worth keeping until then as a live, zero-risk test subject for validating the cleanup script before it is pointed at real tags.
- id: 01M252C19HS9FKF7MCW1P54TJ3
  author: Steve Vine
  at: 2026-09-10T07:09:02.640255Z
  text: |-
    **This ticket's premise was wrong, and so was my follow-up experiment. Corrected 2026-09-10 against real AWS state.**

    Both the original audit and the "provider never removes tag keys" conclusion were measured from `status.atProvider.tags` on the managed resources. **That field is stale — it retains tag keys that no longer exist in AWS.** Once I had AWS CLI access and queried the APIs directly, the picture reversed.

    ## Ground truth

    `network-envstaginguk-vpc` — `atProvider` shows `Project: envstaging` and `env: staging`. Actual AWS (`ec2 describe-tags`):

    ```
    Name, crossplane-kind, crossplane-name, crossplane-providerconfig, mp-env, mp-geo, mp-project
    ```

    No `Project`. No `env`. Same for `cluster-envstaginguk-role-eksnode` (`iam list-role-tags`), the staging EIP, and `network-mgntstaginguk-vpc`. The migration worked. The Crossplane-managed estate is clean in AWS.

    The tag-removal experiment fails the same way: `mp-test` never showed up in AWS after I removed it from spec, and `describe-tags` confirmed it was already absent *before* I ran `delete-tags`. The provider adds **and removes** keys correctly; only `atProvider` lied about it.

    **The lesson worth keeping: never audit tags from `status.atProvider` — query AWS.** Any future tag work should use the AWS APIs as the source of truth.

    ## What actually still carries old keys

    Real sweep, `ec2 describe-tags --filters Name=key,Values=Project,Env,env`:

    | | staging eu-west-2 | production eu-west-2 |
    |---|---|---|
    | snapshot | 0 | 265 |
    | instance | 10 | 10 |
    | volume | 4 | 5 |
    | vpc-endpoint | 1 | 1 |
    | vpc | 1 (bstr) | 1 (bstr) |
    | network-interface / fleet | 0 | 2 |

    Three distinct causes, none of them "the provider won't prune":

    1. **EC2 instances and volumes** — not Crossplane resources at all. Launched from LaunchTemplate **version 1** (`aws:ec2launchtemplate:version = 1` on the nodes) and from pre-change Karpenter node classes, so they carry `Project`/`Env`/`NodeGroup`/`NodeType`. This is CPL-3, and it clears itself when the nodes roll. No separate work.
    2. **265 production EBS snapshots** — inherited tags from volumes at snapshot time. Historical and immutable in practice; they age out with retention. Not worth chasing.
    3. **`network-mgntstaginguk-vpce-s3`** — a genuine regression, see below. This is the only Crossplane-managed resource actually still on the old scheme.

    ## The one real defect

    `apis/net/network-comp-v2.yaml:102-105` — the opt-in S3 gateway endpoint block renders:

    ```yaml
    tags:
      Name: "{{ $name }}-vpce-s3"
      Project: "{{ $p.projectName }}"
      env: "{{ $p.env }}"
    ```

    Old keys, no `mp-geo`. Added by `6ef908d` on 2026-08-12 — the same day as the tagging migration, in parallel, so it never got converted. It is on `main` and every branch. Raised separately as CPL-8.

    ## Revised scope for this ticket

    Almost nothing. The cleanup script on `chore/legacy-tag-cleanup-script` (2026-08-26, 228 lines) predates my audit and was not built on it, but its target list should be re-scoped against real AWS state before anyone runs it — most of what it would look for is not there. The `Env`/`Project` keys on nodes and snapshots are the only meaningful population, and both resolve on their own.

    Also: the CLAUDE.md line about renaming being "a delete + create at the AWS API" is **correct after all** — it was my correction to it that was wrong. Leave it alone.
- id: 01M2530D626V4GX166T4ZYCFAS
  author: Steve Vine
  at: 2026-09-10T07:20:10.178176Z
  text: |-
    Cancelling — the premise was wrong and the residual scope belongs to other tickets.

    Verified against the AWS APIs: the Crossplane-managed estate is clean. No `Project`/`env` on the sampled VPCs, IAM role, EIP or mgnt VPC. The "80 of 97 carry both schemes" figure was an artifact of reading `status.atProvider.tags`, which retains keys AWS no longer has, and the "provider never removes tag keys" experiment failed the same way.

    Everything genuinely still carrying old keys is tracked elsewhere or resolves without work:

    - EC2 instances and volumes on LaunchTemplate v1 → **CPL-3**, clears on node roll
    - 265 production EBS snapshots → historical, age out with retention, not worth chasing
    - `network-mgntstaginguk-vpce-s3` → **CPL-8**, a real composition regression

    Nothing left that is specific to this ticket. Keeping it as cancelled rather than deleted because the correction comment is the record of *why* the audit was wrong, and that lesson — audit tags from the AWS API, never from `status.atProvider` — is the durable output. The `chore/legacy-tag-cleanup-script` branch should be re-scoped against real AWS state before it is run, since most of its target population does not exist.
assignee: steve
label:
- bug
priority: low
task_status: cancelled
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