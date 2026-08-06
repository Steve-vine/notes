---
id: 01KYW7EFBDY1E34PYNQD3JYMNM
created: 2026-07-31T13:57:30.093804Z
updated: 2026-08-06T08:34:28.625825Z
type: task
title: 'Integration docs: AWS'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 413
order: 1.0
sprint: sp3en5k
comments:
- id: 01KYW87G4EF8GQR4VSNFBBK3RD
  author: Steve Vine
  at: 2026-07-31T14:11:10.094586Z
  text: |-
    Done on feature/ise-413-docs-aws — PR #11, left OPEN for the PR-preview test.

    Full AWS page: capabilities (per-region discovery of EC2/RDS/EKS/ELB/S3 with tag-pool provenance and cross-source joins onto DataDog hosts + K8s clusters; CloudWatch alarms + Health events forwarded verbatim; evidence describe_resource/list_resources/cloudwatch_metric_statistics/logs_filter_events/cloudtrail_lookup_events; actions reboot_instance/start_instance/set_resource_tag T1, stop_instance/reboot_db_instance T2; explicit no-IAM-actions note), setup (read IAM identity scope list, one instance per account, Grant-write flow for the second identity), examples (alarm→known host incident, T1 vs T2 remediation, CloudTrail evidence). Facts from connectors/aws.py + ADRs 0058/0060. Build/lint green.
assignee: steve
label: null
priority: medium
task_status: done
---
Replace the AWS stub (`src/content/docs/integrations/aws.md`) with full operator documentation:

- **Capabilities** — per-account discovery (EC2, RDS, EKS, ELB, S3 → estate entities with cross-source joins), CloudWatch alarms + AWS Health as alert signals, evidence on demand (describe/metrics/logs/CloudTrail), action catalogue (EC2 lifecycle, RDS reboot, resource tagging) with tiers — no IAM actions by design.
- **Setup** — one integration per account; read credentials (access key) and the separate write identity via the Grant-write flow; region configuration.
- **Examples** — a CloudWatch alarm attributed to an EC2 host known from DataDog; a T2 stop-instance through approval.

Ground in ADRs 0058 (connector) + 0060 (actions); rewrite for operators, released capability only.