---
id: 01KZTJDGNG9BEZEDJXNJ6EEPEB
created: 2026-08-12T08:46:25.968508Z
updated: 2026-08-12T09:19:13.417402Z
type: task
title: Tag Review
project: 01KZTJ50S657DMMC3VFEFWN78V
number: 1
order: 1.0
sprint: s6sx8uq
comments:
- id: 01KZTM9A182WYS29F78M8A9V52
  author: Steve Vine
  at: 2026-08-12T09:19:05.255019Z
  text: |-
    Tag review complete — swept all 17 compositions + stacks/fullstack-comp.yaml (107 AWS managed resources across iam, ec2, eks, efs, rds, s3, route53).

    ## Resources missing tags that DO support tags (10)

    Filename / resource

    apis/app/appcluster-comp-v2.yaml / eks PodIdentityAssociation `{{ $cluster }}-pia-integrations-mcp`
    apis/ebs/ebs-comp-v2.yaml / eks Addon `{{ $ebs.cluster }}-addon-ebscsicontroller`
    apis/efs/efs-comp-v2.yaml / eks Addon `{{ $efs.cluster }}-addon-efscsicontroller`
    apis/eks/ekscluster-comp-v2.yaml / eks Addon `{{ $name }}-addon-vpccni`
    apis/eks/ekscluster-comp-v2.yaml / eks AccessEntry `{{ $name }}-accessentry-{{ $index }}`
    apis/rds/mariadb-comp-v2.yaml / rds Instance `{{ $p.projectName }}-db-instance`
    apis/rds/mariadb-comp-v2.yaml / rds Instance `{{ $p.projectName }}-db-replica`
    apis/rds/pgsql-comp-v2.yaml / rds Instance `{{ $p.projectName }}-pgsql-instance`
    apis/twingate/tgconnector-comp-v2.yaml / iam Policy `{{ $name }}-policy-twingate.secrets`
    apis/twingate/tgconnector-comp-v2.yaml / iam InstanceProfile `{{ $name }}-instanceprofile-twingate`

    The three RDS Instances are the significant ones — they are the biggest billed resources in the estate and currently carry no Project/env tag at all, so they don't show up in cost allocation or in tag-based estate queries. The parent SubnetGroup, SecurityGroup and ParameterGroup around them *are* tagged, so the gap is only on the instances themselves.

    ## Correctly untagged — the AWS API has no tags field (41)

    No action needed on these: RolePolicyAttachment (x19), RolePolicy, SecurityGroupRule (x5), Route (x3, incl. apis/tgw/tgwroute-comp-v2.yaml), RouteTableAssociation (x2), ZoneAssociation, route53 Record (x3), TransitGatewayRoute (x2), efs MountTarget, s3 BucketPublicAccessBlock (x2), s3 BucketPolicy, s3 BucketLifecycleConfiguration, eks AccessPolicyAssociation, eks ClusterAuth (Crossplane-only, not an AWS resource), ec2 Tag `{{ $name }}-tag-sg.karpenter` (is itself a tag).

    ## Tagged, but not to the CLAUDE.md standard (Name / Project / env + extras loop)

    Worth folding into the same sprint since the files are being touched anyway:

    - **No `env` tag at all — 39 of 50 tagged resources.** Every tagged resource in appcluster, ebs, efs, ekscluster (IAM/OIDC), both rds comps, both tgw comps, s3 bucket + s3accessrole, and twingate's role. Only apis/net/network-comp-v2.yaml applies `env` consistently.
    - **`Env` capitalised instead of `env`** — apis/eks/ekscluster-comp-v2.yaml: eks Cluster, LaunchTemplate, NodeGroup, plus the Karpenter EC2NodeClass tag block (line ~454); apis/twingate/tgconnector-comp-v2.yaml: ec2 Instance. Two different keys for the same concept across the estate — needs picking one before any tag-based reporting is reliable.
    - **Missing `Name`** — apis/app/appcluster-comp-v2.yaml eks Addon `-addon-podidentity` (Project only); apis/rds/mariadb-comp-v2.yaml rds ParameterGroup (Project only); apis/twingate/tgconnector-comp-v2.yaml iam Role `-role-twingate` (Project/Network/Component only).
    - **No per-resource extra-tags `range` loop** — 46 of 50. Only ekscluster's LaunchTemplate/NodeGroup/EC2NodeClass and s3 bucket-comp's Bucket accept user-supplied extra tags.

    No code changed for this ticket — review only.
assignee: steve
priority: medium
task_status: review
---
Review all resource tagging and identify is there are any Crossplane resources currently missing tags.  Note, not all resources support tags e.g. Routes and ZoneAssociations.  If any resources are found, add to a list in the comments of this ticket as -
Filename / resource