---
id: 01M22VC5E445N9HAWFAW582FAD
created: 2026-09-09T10:28:17.988084Z
updated: 2026-09-10T09:37:58.753441Z
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
- id: 01M25AWQZ1QE229TRSVPQ6QAQP
  author: Steve Vine
  at: 2026-09-10T09:37:58.749258Z
  text: |-
    Tags applied out of band, 2026-09-10. All eight access points now correct in AWS; ticket stays open for the durable fix.

    **What was done.** Verified first on one staging access point that an out-of-band `aws efs tag-resource` holds — checked at 4, 8 and 12 minutes, `mp-geo=uk` survived every reconcile with the MR reporting `Synced=ReconcileSuccess`. It holds precisely because `Update` is excluded: Crossplane has no path to write tags, so it has no path to overwrite them either. Then applied to the rest.

    | | before | after |
    |---|---|---|
    | staging ×4 | `mp-geo` empty, other two correct | `mp-project` / `mp-env` / `mp-geo` all correct, uk / us per region |
    | production ×4 | **no `mp-*` tags at all** | all three correct, uk / us per region |

    Production was worse than this ticket originally described — not an empty `mp-geo` but no `mp-*` whatsoever, so those four were entirely invisible to cost allocation. Found only by querying the EFS API directly; Crossplane reported all four `Synced=True / Ready=True` throughout, before and after.

    No disruption: all eight MRs `Synced/Ready`, `xefs` and `xfullstack` healthy in both environments.

    **Why this stays open.** These eight tags live outside Crossplane. They survive reconciles but will not survive access-point recreation, and the compositions still cannot write them while the `#63` workaround is in place. `provider-aws-efs` is still `v2.4.0`, the version with the `DescribeTags`/`fsap-` bug. The real fix remains: upgrade to a release without that bug (and without the known issue #63 flagged in the next version), remove the `managementPolicies` line, and let Crossplane own the tags again. Re-verify the values in AWS afterwards.

    **Deliberately not investigated.** Why production's four received no tags at all while staging's got two of three, given both took the same release. Steve's call (2026-09-10) to leave it unexplained and revisit only if it recurs — the symptom is fixed and the root cause has no payoff unless another access point lands bare. If that happens, the thing to check is where in the #62 → #63 sequence the access points fell, since #63 landed within the hour of #62 and could have cut the reconcile short.

    Worth knowing if it does recur: Crossplane reports these resources as perfectly healthy while untagged, so nothing will alert. A periodic check for EFS access points missing `mp-*` would catch it; querying the AWS API, not `status.atProvider`.

    One incidental reassurance: unlike the twingate instances, these access points have a populated `external-name`, so they are not exposed to the identity-loss failure mode in CPL-9. The two share a `managementPolicies` shape but not the risk.
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