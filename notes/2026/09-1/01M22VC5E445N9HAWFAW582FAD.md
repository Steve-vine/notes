---
id: 01M22VC5E445N9HAWFAW582FAD
created: 2026-09-09T10:28:17.988084Z
updated: 2026-09-10T07:20:34.945611Z
type: task
title: Frozen tags — EFS access points and twingate instances cannot receive tag updates
project: 01KZTJ50S657DMMC3VFEFWN78V
number: 7
sprint: s6sx8uq
comments:
- id: 01M25315C13658K4ZQ1A38910Q
  author: Steve Vine
  at: 2026-09-10T07:20:34.944201Z
  text: |-
    Confirmed real against the AWS APIs, and widened — 2026-09-10.

    Unlike CPL-6, this one survives verification. `aws efs describe-access-points` in staging:

    ```
    fsap-00713171b7066e07c  cluster-envstaginguk-ap-ai-agent-docs-test  mp-env=staging  mp-geo=(empty)  mp-project=envstaging
    fsap-0832e00f8c7f3ea4b  cluster-envstaginguk-ap-ai-agent-docs-dev   mp-env=staging  mp-geo=(empty)  mp-project=envstaging
    ```

    `mp-geo` is genuinely an empty string in AWS, not a stale-status artifact. Production has the equivalent four.

    **Widened to the twingate EC2 instances**, which are the same defect class — `managementPolicies` without `Update`, so tags freeze at Create:

    - Production `tgc-envproductionukpri-*` (`i-047d8e33e2d6335aa`, `i-0fc035aea3c89b684`): `mp-project` and `mp-env` correct, `mp-geo` **empty** in AWS. They were created 26 Aug, after the tag release but before production had per-cluster geo, so they froze mid-migration.
    - The older duplicates alongside them (`i-04a48549badc98b89` and friends, created 24 Jun) carry **only** `Project`/`Env` and no `mp-*` at all — they predate the migration entirely and can never receive it. Those are orphans and belong to **CPL-9**; terminating them resolves their tags as a side effect.

    So the ticket now covers two resource families with one root cause. The out-of-band option applies to both — `aws efs tag-resource` and `aws ec2 create-tags` will stick precisely because `Update` is excluded, so Crossplane will not revert them.

    Note this interacts with CPL-9: if the twingate rewrite to ASG + LaunchTemplate goes ahead, the connector instances stop being bare `Instance` MRs and this half of the problem disappears with it. Worth sequencing after that decision rather than hand-patching tags that a rewrite would replace.
assignee: steve
label:
- follow_up
priority: low
task_status: todo
---
Found reviewing staging after the tagging release. Four EFS access points render the right `mp-geo` but AWS still holds an empty string, and the value cannot be written.

## The four

In `envstaging`, all `Synced=True / Ready=True` — this is silent, not a failure:

| Access point | desired mp-geo | in AWS |
|---|---|---|
| `cluster-envstaginguk-ap-ai-agent-docs-dev` | `uk` | `""` |
| `cluster-envstaginguk-ap-ai-agent-docs-test` | `uk` | `""` |
| `cluster-envstagingus-ap-ai-agent-docs-dev` | `us` | `""` |
| `cluster-envstagingus-ap-ai-agent-docs-test` | `us` | `""` |

`mp-project` and `mp-env` are correct on all four. Only `mp-geo` is stranded.

## Why

The sequence did it:

1. PR #62 (24 Aug) shipped `mp-geo`, which resolved to `""` because no claim supplied `geo` yet.
2. PR #63 (24 Aug) removed `Update` from the access points' `managementPolicies`, working around the provider-aws-efs v2.4.0 bug where the tag-update path calls the deprecated EFS `DescribeTags` API with an `fsap-` id and loops on ReconcileError.
3. PR #67 (26 Aug) plus the claim changes gave `geo` a real value — but by then the only path that could write it was gone. Access points are immutable at the AWS API except for tags, so tags now land at Create and never after.

So the empty value is baked in for the life of these access points.

## Options

- **Wait for the provider fix.** #63's commit already says to remove the `managementPolicies` line once a provider-aws-efs release lands without the bug (and without the known issue in the next version). Once `Update` is restored the four correct themselves on the next reconcile. Cheapest, and this ticket is really a reminder to re-check the value afterwards.
- **Recreate the access points.** Correct tags immediately, but they carry live data paths for ai-agent-docs dev/test — not worth an outage for a tag.
- **Set the tag out of band** with `aws efs tag-resource`. Fixes AWS without touching Crossplane; harmless because with `Update` excluded, Crossplane will not reconcile it back to empty. Worth pairing with the CPL-6 cleanup, which is already a scripted out-of-band tag pass over the same estate.

## Watch for

Any access point created while this workaround is in place inherits whatever `mp-geo` renders at Create and freezes it, so a wrong or empty value at creation is permanent. Same applies to `mp-project` and `mp-env` if a claim is ever mis-set. Worth checking the sandbox and production access points for the same empty value — this review only covered staging.