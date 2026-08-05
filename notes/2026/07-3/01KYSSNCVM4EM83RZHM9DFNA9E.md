---
id: 01KYSSNCVM4EM83RZHM9DFNA9E
created: 2026-07-30T15:18:07.988038Z
updated: 2026-08-05T14:25:18.57168Z
type: task
title: RDS reboot + AWS resource tag write-back
project: 01KX671DATY39VW6GWK3M2T3DN
number: 375
order: 1.25
sprint: sv6hnwj
blocked_by:
- 01KYSSMCE2P50V2H1JMPVD2JHN
comments:
- id: 01KYSVQWFRHN6N4P6N168A1AXV
  author: Steve Vine
  at: 2026-07-30T15:54:26.67999Z
  text: |-
    Built on feature/ise-375-rds-reboot-tag-writeback (stacked on ISE-374), PR #350.

    - reboot_db_instance (T2): DB-identifier targeted, optional force_failover passed through as ForceFailover, describe-first before-capture (prior DBInstanceStatus), DBInstanceNotFoundFault → clean failed result.
    - set_resource_tag (T1): renamed from the planned set_resource_tags — one key on one resource to one value, matching the set_label/set_host_tag single-surface shape (ADR 0060 + brief updated accordingly). Resource Groups Tagging API only, so write scopes are just tag:TagResources + tag:GetResources. ARN's own region routes the call; prior value captured (None when unset); aws: reserved prefix refused by schema; FailedResourcesMap surfaced as a failed result.
    - ADR 0043 wiring: "aws": "set_resource_tag" in tag_remediation._OPERATIONS + ARN derivation from the aws:{account}:{arn} alias — AWS systems now appear in correctable_system_ids and the existing Tag-detail correction UI just works.
    - Tests: test_aws_actions.py → 19 tests; new AWS case in test_tag_remediation.py; connector test pins the five-op tier table.

    Gates: ruff + format + mypy strict clean; full suite 1600 passed locally.
assignee: steve
label: null
priority: medium
task_status: done
---
Second action wave: databases and tags.

- `reboot_db_instance` (T2): params `db_instance_identifier`, optional `force_failover`, optional `region`; `target_fields=["db_instance_identifier"]`; `before` = prior DB instance status; rollback note explains the brief-outage/failover semantics.
- `set_resource_tags` (T1): ARN-targeted (`resource_arn` + `tags` map, create-or-overwrite semantics via `ec2:CreateTags`/`tag:TagResources`); `before` = prior values of the touched tag keys.
- **Fix-at-source wiring (ADR 0043)**: add `"aws": "set_resource_tags"` to `tag_remediation._OPERATIONS` (`tag_remediation.py:43`) and confirm `correctable_system_ids` picks AWS systems up — AWS tag compliance becomes correctable from the Tag detail page like K8s/DataDog (existing UI, no frontend work).
- Execution-path tests against stubbed boto3 for both operations + a tag-remediation plan/propose test for an AWS system.