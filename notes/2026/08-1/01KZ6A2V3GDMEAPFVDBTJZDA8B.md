---
id: 01KZ6A2V3GDMEAPFVDBTJZDA8B
created: 2026-08-04T11:55:58.960675Z
updated: 2026-08-07T12:15:49.336806Z
type: task
title: Set up dedicated ISE IAM users in both AWS accounts (read-only + read-write)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 530
order: 1.0
sprint: skxht3g
comments:
- id: 01KZ6H6MNAN87J4WVZE4DX5Q0T
  author: Steve Vine
  at: 2026-08-04T14:00:23.466106Z
  text: |-
    Verified live 2026-08-04 (Claude): both accounts swapped to the new read users and re-synced clean.

    - Staging (463040245339): credential saved 13:42:58; the 13:44 sync still ran on the old key (reveal happens at sync start — save lost the race by ~1 min, no fault). First new-key sync 13:59:04 — 0 AccessDenied, no sync error.
    - Production (826764636751): credential saved 13:51:04, first new-key sync 13:53:25 — 0 AccessDenied, no sync error.
    - S3 tag sweep now functional on both; only 2 buckets per account carry tags, which is now AWS-side truth (most buckets genuinely untagged at source) rather than a failed read — tag-hygiene follow-up, not an ISE issue.
    - Alarm signals: 0 on both — permission proven (no denials), reads as "no alarms currently firing".

    Remaining acceptance item: a firing CloudWatch alarm appearing as an Alert signal end-to-end — needs a real or test alarm in ALARM state to prove. Write credentials (svc-ise-write / write_credential_ref) not yet configured on either System.
- id: 01KZ6K0AGAQXD8HXWJ2HBG7CQF
  author: Steve Vine
  at: 2026-08-04T14:31:53.610031Z
  text: |-
    Correction to the previous comment: write credentials WERE already set (Staging-write saved 13:43:28, Production-write 13:52:16) — the "not yet configured" line was stated without checking. Validated 2026-08-04 ~14:02 via sts:GetCallerIdentity with the stored write keys (read-only probe, no mutation):

    - Staging: OK — arn:aws:iam::463040245339:user/svc-ise_rw
    - Production: OK — arn:aws:iam::826764636751:user/svc-ise_rw

    Both authenticate in the right accounts as a dedicated svc-ise_rw user. Remaining acceptance: (1) a firing CloudWatch alarm arriving as an Alert signal, (2) first real write action through the approval flow exercising the svc-ise_rw policy (reboot/tag on something disposable in Staging would prove it).
assignee: steve
label: null
priority: high
task_status: done
---
**Config action for Steve — not code.** Live-found 2026-08-04 while checking the Cloudflare re-enable: both AWS integrations are running as the **Crossplane build users**, not ISE credentials, and two capability slices are 403ing on every sync (~every 15 min, both accounts):

```
Production (826764636751): user/svc-crossplane-build
Staging    (463040245339): user/svc-crossplane_build
  ✗ cloudwatch:DescribeAlarms  → AWS alarm detection DEAD — CloudWatch alarms invisible to ISE
  ✗ tag:GetResources           → S3 tag sweep dead — buckets tag-blind in the pool
```

Discovery works, so health shows `connected` and the failures live only in worker logs (see the companion visibility task, if raised). Riding the Crossplane build identity also means a Crossplane key rotation silently kills ISE.

## What to create — per account (Production + Staging)

Two IAM users per account, long-lived access keys (**AKIA…** — the connector rejects temporary ASIA… keys at validation), keys pasted into the ISE credential store as read (`credential_ref`) and write (`write_credential_ref`) on each AWS System.

### 1. `svc-ise-read` — read-only policy

The connector's `credential_spec` scopes (`aws.py:199`), expanded to valid IAM actions:

```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Sid": "ISERead",
    "Effect": "Allow",
    "Action": [
      "sts:GetCallerIdentity",
      "ec2:Describe*",
      "rds:Describe*",
      "rds:ListTagsForResource",
      "eks:Describe*",
      "eks:List*",
      "elasticloadbalancing:Describe*",
      "s3:ListAllMyBuckets",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:GetMetricData",
      "logs:FilterLogEvents",
      "health:Describe*",
      "cloudtrail:LookupEvents",
      "tag:GetResources"
    ],
    "Resource": "*"
  }]
}
```

Notes: `sts:GetCallerIdentity` is the health check and cannot be denied anyway; `health:Describe*` needs a Business+ support plan and degrades gracefully without it; `tag:GetResources` is the ISE-380 bulk tag sweep (also serves the write path's tagging API reads).

### 2. `svc-ise-write` — the ADR 0060 second identity

Covers exactly the five-action catalogue (reboot/start/stop instance, reboot RDS, set tag) plus the read-back each action does for its before/after capture:

```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Sid": "ISEWrite",
    "Effect": "Allow",
    "Action": [
      "sts:GetCallerIdentity",
      "ec2:RebootInstances",
      "ec2:StartInstances",
      "ec2:StopInstances",
      "ec2:DescribeInstances",
      "rds:RebootDBInstance",
      "rds:DescribeDBInstances",
      "tag:TagResources",
      "tag:GetResources"
    ],
    "Resource": "*"
  }]
}
```

Notes: `set_resource_tag` uses the Resource Groups Tagging API (`tag_resources`, `aws.py:1662`) — that needs `tag:TagResources` **plus** the underlying service's tagging permission for each resource type it touches (e.g. `ec2:CreateTags`, `rds:AddTagsToResource`, `s3:PutBucketTagging`); add those if/when tagging those types via ISE. Scope `Resource` tighter (specific ARN patterns, or a deny on prod-critical instances) if wanted — ISE's tier system (ADR 0017) gates approval, not IAM.

## Then, in ISE (Settings → each AWS System)

1. Replace the read credential with `svc-ise-read`'s key — regions config is untouched (it lives in `System.config`, deliberately survives credential changes, ADR 0058 §5).
2. Set `write_credential_ref` to `svc-ise-write`'s key.
3. Next sync: confirm the two warnings stop (`aws alarm detection failed` / `aws s3 tag sweep failed` gone from worker logs), S3 buckets pick up tags, and any live CloudWatch alarms appear as signals.

## Acceptance

- Worker logs clean of AWS AccessDenied for a full sync cycle on both accounts
- Bucket entities carry tags in the pool
- A test CloudWatch alarm (or an existing firing one) shows as an Alert signal in ISE
- Crossplane's users no longer appear in ISE's CloudTrail footprint
