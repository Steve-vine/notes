---
id: 01KYW7EFBDY1E34PYNQD3JYMNM
created: 2026-07-31T13:57:30.093804Z
updated: 2026-07-31T13:58:31.882332Z
type: task
title: 'Integration docs: AWS'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 413
sprint: sp3en5k
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
Replace the AWS stub (`src/content/docs/integrations/aws.md`) with full operator documentation:

- **Capabilities** — per-account discovery (EC2, RDS, EKS, ELB, S3 → estate entities with cross-source joins), CloudWatch alarms + AWS Health as alert signals, evidence on demand (describe/metrics/logs/CloudTrail), action catalogue (EC2 lifecycle, RDS reboot, resource tagging) with tiers — no IAM actions by design.
- **Setup** — one integration per account; read credentials (access key) and the separate write identity via the Grant-write flow; region configuration.
- **Examples** — a CloudWatch alarm attributed to an EC2 host known from DataDog; a T2 stop-instance through approval.

Ground in ADRs 0058 (connector) + 0060 (actions); rewrite for operators, released capability only.