---
id: 01KZTMWVJHE399BV48PWQR6ZP0
created: 2026-08-12T09:29:45.809824Z
updated: 2026-08-12T09:29:51.596351Z
type: task
title: Apply missing tags and migrate all compositions to the mp-project / mp-env standard
project: 01KZTJ50S657DMMC3VFEFWN78V
number: 2
sprint: s6sx8uq
assignee: steve
label:
- tech_debt
priority: medium
task_status: todo
---
Follow-on from CPL-1 (Tag Review). Two jobs in one pass over the compositions: add tags where they are missing, and move every existing tag block to the new standard.

## New tagging standard

`mp-env` replaces `env` / `Env`, and `mp-project` replaces `Project`. Both are **mandatory** on every resource that supports tagging. The value sources are unchanged — `$p.projectName` and `$p.env`.

```yaml
tags:
  Name: "{{ $name }}-<descriptor>"
  mp-project: "{{ $p.projectName }}"
  mp-env: "{{ $p.env }}"
  {{- if $resource.tags }}
  {{- range $key, $value := $resource.tags }}
  {{ $key }}: "{{ $value }}"
  {{- end }}
  {{- end }}
```

`Name` stays as-is. `karpenter.sh/discovery` on the private subnets is a functional selector, not a metadata tag — leave it untouched.

## 1. Add tags to the 10 resources currently missing them

- apis/rds/mariadb-comp-v2.yaml — rds Instance `-db-instance`, rds Instance `-db-replica`
- apis/rds/pgsql-comp-v2.yaml — rds Instance `-pgsql-instance`
- apis/eks/ekscluster-comp-v2.yaml — eks Addon `-addon-vpccni`, eks AccessEntry `-accessentry-{{ $index }}`
- apis/ebs/ebs-comp-v2.yaml — eks Addon `-addon-ebscsicontroller`
- apis/efs/efs-comp-v2.yaml — eks Addon `-addon-efscsicontroller`
- apis/app/appcluster-comp-v2.yaml — eks PodIdentityAssociation `-pia-integrations-mcp`
- apis/twingate/tgconnector-comp-v2.yaml — iam Policy `-policy-twingate.secrets`, iam InstanceProfile `-instanceprofile-twingate`

## 2. Migrate the 50 already-tagged resources

Rename `Project` → `mp-project` everywhere, and `env` / `Env` → `mp-env`. Add `mp-env` to the 39 resources that have no env tag today (everything outside apis/net/network-comp-v2.yaml). Add the missing `Name` on appcluster's `-addon-podidentity`, mariadb's ParameterGroup, and twingate's `-role-twingate`. Add the extra-tags `range` loop where the parameter block supports per-resource tags.

Also covers the Karpenter `EC2NodeClass` tag block in apis/eks/ekscluster-comp-v2.yaml (~line 454) and the `LaunchTemplate` tagSpecifications — these stamp the tags that land on Karpenter-launched nodes, so they need to match or the fleet ends up split across two schemes.

## Notes / watch-outs

- `$p.env` is available in every composition — all 17 alias `$p` from the same `project` block and fullstack-comp passes it to every child. eks, net, obs, s3accessrole and twingate already reference it, so no XRD change is needed.
- Renaming a tag key is a delete + create at the AWS API. Expect the old `Project`/`Env` keys to be dropped from live resources on the next reconcile — confirm nothing (cost reports, SCPs, ISE estate queries, Karpenter selectors) keys off the old names before rolling to production.
- The RDS instances use `managementPolicies: ["Observe", "Create", "Update", "LateInitialize"]` — verify the tag addition actually applies rather than being late-initialised away, and check it does not trigger an instance modification window.
- Update the tagging standard section in CLAUDE.md, and record the change under `# Unreleased` in changelog.md.
- Roll out sandbox → staging → production, verifying tags land at each stage.

Do NOT add tags to the 41 resources listed in CPL-1 as unsupported (RolePolicyAttachment, SecurityGroupRule, Route, Record, RouteTableAssociation, ZoneAssociation, TransitGatewayRoute, MountTarget, the S3 sub-resources, AccessPolicyAssociation, ClusterAuth) — the AWS API has no tags field for these.