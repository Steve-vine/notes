---
id: 01KYTE0EQ4Q0TQ4BFZK6PPE5RW
created: 2026-07-30T21:13:41.860303Z
updated: 2026-08-05T19:29:27.637057Z
type: task
title: MySQL flexible server restart
project: 01KX671DATY39VW6GWK3M2T3DN
number: 386
sprint: sh8mf3h
assignee: steve
priority: medium
task_status: backlog
---
Close the one catalogue inconsistency left by the sprint: MySQL flexible servers are discovered as database entities (`Microsoft.DBforMySQL/flexibleServers`, ADR 0059) but have no restart action, despite sharing the PG flexible server's `/restart` ARM API.

- `restart_mysql_flexible_server` (T2 — same rationale as the PG restart, ADR 0061 §2: a database outage window on a stateful system). Amend the ADR 0061 §2 tier table.
- Schema mirrors `_pg_server_action_schema`: full lower-case ARM id pinned to `microsoft.dbformysql/flexibleservers` (deny-list exact-match spelling, ADR 0061 §3).
- Handler mirrors `_act_restart_pg_flexible_server`: describe-first before-capture (server state), restart via `run_action` (api-version `2023-12-30`, the pinned discovery version).
- Write SP RBAC addition: `Microsoft.DBforMySQL/flexibleServers/restart/action` + `…/read` — note it in ADR 0061 §1's custom role.
- Tests in `test_azure_actions.py` (before-capture, not-found, schema pin); tier-table pin in `test_azure_connector.py` gains the seventh row.