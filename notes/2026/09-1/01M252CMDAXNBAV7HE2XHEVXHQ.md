---
id: 01M252CMDAXNBAV7HE2XHEVXHQ
created: 2026-09-10T07:09:22.218241Z
updated: 2026-09-10T07:09:27.316917Z
type: task
title: S3 gateway endpoint block still renders the old Project/env tags
project: 01KZTJ50S657DMMC3VFEFWN78V
number: 8
sprint: s6sx8uq
assignee: steve
label:
- bug
priority: medium
task_status: todo
---
The only Crossplane-managed resource in the estate still on the old tag scheme. Found while correcting CPL-6 against real AWS state.

## The defect

`apis/net/network-comp-v2.yaml:102-105`, inside the `{{- if $network.s3GatewayEndpoint }}` block:

```yaml
tags:
  Name: "{{ $name }}-vpce-s3"
  Project: "{{ $p.projectName }}"
  env: "{{ $p.env }}"
```

Should be `mp-project` / `mp-env` / `mp-geo`, with the per-cluster geo resolution the rest of the file uses:

```yaml
tags:
  Name: "{{ $name }}-vpce-s3"
  mp-project: "{{ $p.projectName }}"
  mp-env: "{{ $p.env | default "" }}"
  mp-geo: "{{ $network.geo | default $p.geo | default "" }}"
```

## How it got in

Commit `6ef908d` ("feat: add opt-in s3GatewayEndpoint for network compositions"), 2026-08-12 — the same day as the tagging migration. Two changes to the same file in parallel; this one was written against the pre-migration convention and merged without conflict, so nothing flagged it. It is on `main` and every active branch.

## Live impact

One resource today: `network-mgntstaginguk-vpce-s3` (`vpce-03d547cc38c713858`, staging account, eu-west-2). Confirmed in AWS — it carries `Project: mgntstaging` and `env: mgnt` and **no `mp-*` tags at all**, so it is invisible to any `mp-project` cost query. Production has an equivalent endpoint with the same shape.

The block is opt-in per network (`s3GatewayEndpoint`), so the blast radius grows every time a network enables it.

## The work

1. Fix the tag block in `apis/net/network-comp-v2.yaml`.
2. Ship through sandbox → staging → production as usual. The existing endpoints pick up the new keys on the next reconcile — the provider updates tags correctly (this was verified: adds, value changes and key removals all propagate; it was `status.atProvider` that misled the earlier analysis).
3. Confirm in AWS afterwards, not from `status.atProvider`:
   `aws ec2 describe-tags --profile staging --region eu-west-2 --filters "Name=resource-id,Values=vpce-03d547cc38c713858"`

## Worth doing alongside

Add a guard so this class of regression cannot recur silently — a CI check that greps the compositions for `^\s+(Project|env|Env):` under a `tags:` block and fails. The migration is only as durable as the next person's copy-paste, and this proves that. Cheap to write, and it would have caught `6ef908d` on the day.