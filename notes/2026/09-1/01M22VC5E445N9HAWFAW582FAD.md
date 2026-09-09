---
id: 01M22VC5E445N9HAWFAW582FAD
created: 2026-09-09T10:28:17.988084Z
updated: 2026-09-09T10:28:25.665527Z
type: task
title: EFS access points stuck with empty mp-geo — tag updates blocked by the provider bug workaround
project: 01KZTJ50S657DMMC3VFEFWN78V
number: 7
sprint: s6sx8uq
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