---
id: 01KYT7F2D1KS9DWBBR3FJAKS68
created: 2026-07-30T19:19:20.737106Z
updated: 2026-07-30T19:20:47.34239Z
type: task
title: PG flexible server restart + Azure resource tag write-back
project: 01KX671DATY39VW6GWK3M2T3DN
number: 379
sprint: sh8mf3h
blocked_by:
- 01KYT7EFWTQRHT7K12RFEB0J69
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Second action wave: databases and tags.

- `restart_pg_flexible_server` (T2): param `resource_id` (full ARM ID); describe-first before-capture (server state); POST `Microsoft.DBforPostgreSQL/flexibleServers/{name}/restart`, 202 → ISE-377 LRO helper. Azure SQL stays out of v1 per ADR 0061 (no restart operation; failover deferred).
- `set_resource_tag` (T1): PATCH `Microsoft.Resources/tags/default` at resource scope (merge operation — only the named tag changes); params `resource_id`, `key`, `value`; before-capture = current tag value. Joins the ADR 0043 fix-at-source remediation map alongside the AWS (`set_resource_tags`, ISE-375) and K8s implementations, so tag-drift Observations on Azure entities can propose fix-at-source.
- Tests in `test_azure_actions.py`: execution paths for both operations (stubbed ArmClient), T2 approval gating for the restart, tags merge semantics (existing unrelated tags untouched), error containment.
- Acceptance: both operations proposable from the System-detail ActionsPanel; a tag written via ISE visible on the resource in the next discovery sweep.