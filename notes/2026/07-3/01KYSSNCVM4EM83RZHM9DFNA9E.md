---
id: 01KYSSNCVM4EM83RZHM9DFNA9E
created: 2026-07-30T15:18:07.988038Z
updated: 2026-07-30T15:44:17.123858Z
type: task
title: RDS reboot + AWS resource tag write-back
project: 01KX671DATY39VW6GWK3M2T3DN
number: 375
order: 1.25
sprint: sv6hnwj
blocked_by:
- 01KYSSMCE2P50V2H1JMPVD2JHN
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Second action wave: databases and tags.

- `reboot_db_instance` (T2): params `db_instance_identifier`, optional `force_failover`, optional `region`; `target_fields=["db_instance_identifier"]`; `before` = prior DB instance status; rollback note explains the brief-outage/failover semantics.
- `set_resource_tags` (T1): ARN-targeted (`resource_arn` + `tags` map, create-or-overwrite semantics via `ec2:CreateTags`/`tag:TagResources`); `before` = prior values of the touched tag keys.
- **Fix-at-source wiring (ADR 0043)**: add `"aws": "set_resource_tags"` to `tag_remediation._OPERATIONS` (`tag_remediation.py:43`) and confirm `correctable_system_ids` picks AWS systems up — AWS tag compliance becomes correctable from the Tag detail page like K8s/DataDog (existing UI, no frontend work).
- Execution-path tests against stubbed boto3 for both operations + a tag-remediation plan/propose test for an AWS system.