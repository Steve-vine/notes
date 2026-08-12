---
id: 01KZTP6ZEKHAWNF7ZWTVV8Y9G6
created: 2026-08-12T09:52:46.035656Z
updated: 2026-08-12T09:53:01.696076Z
type: task
title: Bump launchTemplateVersion in the claims so nodegroup instances pick up the mp-project / mp-env tags
project: 01KZTJ50S657DMMC3VFEFWN78V
number: 3
sprint: s6sx8uq
blocked_by:
- 01KZTMWVJHE399BV48PWQR6ZP0
assignee: steve
label:
- follow_up
priority: medium
task_status: todo
---
Follow-on from CPL-2. The tag change to the LaunchTemplate does not reach the nodes on its own — this ticket is the bump that makes it land. Work happens in **devops.infrastructure.aws** (the claims), not in this repo.

## Why it is needed

apis/eks/ekscluster-comp-v2.yaml:951 pins the nodegroup to an explicit launch template version:

```yaml
launchTemplate:
    name: "{{ $name }}-lt-{{ $index }}"
    version: "{{ $nodeGroup.launchTemplateVersion }}"
```

The value comes straight from the claim — there is no default in the XRD, and the LaunchTemplate has no `updateDefaultVersion`. So when CPL-2 edits `tagSpecifications`, AWS creates version N+1 and the template's default version stays put, but the nodegroup keeps pointing at the pinned number. Nothing rolls, and every instance and EBS volume launched from then on still carries the old `Project` / `Env` tags. This does not self-heal — the mixed-tag state is permanent until the pin moves.

## The work

- Bump `launchTemplateVersion` for every nodegroup in every claim in devops.infrastructure.aws, once CPL-2 has shipped and the new LT version exists in the account.
- Confirm the new version number per cluster first (`aws ec2 describe-launch-template-versions --launch-template-name <name>-lt-<index>`) rather than assuming N+1 — the templates may already be on different versions across environments.
- This is a rolling node replacement. Schedule it per environment; sandbox → staging → production as usual.
- After each roll, verify the new instances and volumes carry `mp-project` and `mp-env`, and that `NodeGroup` / `NodeType` survived.

## Notes

- Steve is content to run with mixed tags in the interim (agreed 2026-08-12), so this does not need to ship alongside CPL-2. Best folded into the next natural node roll (AMI bump or nodegroup resize) to avoid a disruption purely for tagging.
- Karpenter-managed nodes are **not** covered by this ticket and need no version bump — EC2NodeClass has no version pin, so the new tags apply on the next reconcile. Expectation is Karpenter updates instance tags in place rather than treating a tag change as drift; confirm in sandbox before relying on it, since drift would mean unplanned node churn.
- Until this ships, cost allocation and tag-based estate queries will under-report the nodegroup fleet — which is the bulk of EC2 spend. Worth not letting it sit indefinitely.