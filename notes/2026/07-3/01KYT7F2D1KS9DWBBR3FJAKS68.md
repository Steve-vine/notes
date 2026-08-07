---
id: 01KYT7F2D1KS9DWBBR3FJAKS68
created: 2026-07-30T19:19:20.737106Z
updated: 2026-08-07T09:40:25.708938Z
type: task
title: PG flexible server restart + Azure resource tag write-back
project: 01KX671DATY39VW6GWK3M2T3DN
number: 379
sprint: sh8mf3h
blocked_by:
- 01KYT7EFWTQRHT7K12RFEB0J69
comments:
- id: 01KYT9KM2KK1FPESV5P95MKPRC
  author: Steve Vine
  at: 2026-07-30T19:56:47.059136Z
  text: |-
    Built on feature/ise-379-pg-restart-tag-writeback (stacked on ISE-378), PR #354 → #353's branch (retarget to main at release); merged to staging (41ceac0) — this staging push builds and deploys the full sprint.

    - restart_pg_flexible_server (T2): describe-first before-capture (server state), restart via the LRO helper. Azure SQL stays out per ADR 0061 §2 and the schema pins the operation to microsoft.dbforpostgresql/flexibleservers — an SQL server id cannot even propose.
    - set_resource_tag (T1): Tags API Merge at resource scope carrying only the named key (no other tag changes), prior value captured (None when unset). Azure tag-name rules (reserved microsoft/azure/windows prefixes, forbidden <>%&\?/ chars) refused by schema. ArmClient gains patch().
    - Azure joins the ADR 0043 fix-at-source map: tag_remediation maps azure → set_resource_tag, parameters from the entity's alias (azure:{sub}:{resource_id} → ARM id, already lower-case = the schema's spelling). Tag corrections on Azure resources now proposable from the Tag screens.
    - Tests: 9 new in test_azure_actions.py + Azure fix-at-source parameter test in test_tag_remediation.py; connector test pins the full six-operation tier table.

    Gates: ruff + format + mypy strict clean; full suite 1626 passed locally. PR #352 CI fully green; #353/#354 get CI at retarget-to-main (stacked-chain pattern). Watching the staging deploy run next.
assignee: steve
label: null
priority: medium
task_status: done
---
Second action wave: databases and tags.

- `restart_pg_flexible_server` (T2): param `resource_id` (full ARM ID); describe-first before-capture (server state); POST `Microsoft.DBforPostgreSQL/flexibleServers/{name}/restart`, 202 → ISE-377 LRO helper. Azure SQL stays out of v1 per ADR 0061 (no restart operation; failover deferred).
- `set_resource_tag` (T1): PATCH `Microsoft.Resources/tags/default` at resource scope (merge operation — only the named tag changes); params `resource_id`, `key`, `value`; before-capture = current tag value. Joins the ADR 0043 fix-at-source remediation map alongside the AWS (`set_resource_tags`, ISE-375) and K8s implementations, so tag-drift Observations on Azure entities can propose fix-at-source.
- Tests in `test_azure_actions.py`: execution paths for both operations (stubbed ArmClient), T2 approval gating for the restart, tags merge semantics (existing unrelated tags untouched), error containment.
- Acceptance: both operations proposable from the System-detail ActionsPanel; a tag written via ISE visible on the resource in the next discovery sweep.