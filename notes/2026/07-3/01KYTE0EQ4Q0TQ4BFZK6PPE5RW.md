---
id: 01KYTE0EQ4Q0TQ4BFZK6PPE5RW
created: 2026-07-30T21:13:41.860303Z
updated: 2026-08-07T10:37:46.921069Z
type: task
title: MySQL flexible server restart
project: 01KX671DATY39VW6GWK3M2T3DN
number: 386
sprint: sh8mf3h
comments:
- id: 01KZBGRBAWRQ1ACHZ1P6CBR3AG
  author: Steve Vine
  at: 2026-08-06T12:28:47.324593Z
  text: |-
    Built 2026-08-06 — PR #499 (feature/ise-386-mysql-flexible-server-restart), CI green, merged to staging (005430d).

    Built as specified, with two deliberate choices worth noting:

    1. The PG and MySQL handlers now share one `_flexible_server_restart` body (the `_vm_lifecycle` idiom) rather than being two near-identical copies. Each engine stays pinned to its OWN discovery api-version — MySQL 2023-12-30, PG 2022-12-01 — and there's a test asserting the api-version actually used, because a copy-paste of the PG key would otherwise be silent.

    2. ADR 0061 amended in the open rather than quietly: §2 gains the tier row plus a dated amendment note explaining why MySQL was missing, §1's custom role gains the restart/action + read pair. This is the amendment path §2 already prescribes for a catalogue addition. Azure SQL stays out — the objection there is the ABSENCE of a restart primitive, which this doesn't change.

    Extra test beyond the spec: a cross-engine schema pin (a PG id refused by the MySQL op AND the reverse) — the two engines share an ARM verb, never a target.

    No frontend change needed: ActionsPanel renders action_catalogue generically, so the operation appears on Azure System detail on its own. OpenAPI snapshot unchanged, so no api-types regen.

    ACTION FOR STEVE — the Azure WRITE service principal's custom role needs the new pair added before this can execute against the live subscription:
      Microsoft.DBforMySQL/flexibleServers/restart/action
      Microsoft.DBforMySQL/flexibleServers/read
    Without it the action proposes and approves fine, then fails with Azure's authorization error on the audit trail (contained, not a crashed worker).
- id: 01KZBKZQNRKW435XW38C91KGNZ
  author: Steve Vine
  at: 2026-08-06T13:25:15.064336Z
  text: |-
    RELEASED 2026-08-06 — Steve smoke-tested staging OK; PR #499 merged to main (714cbd1), staging reset to main (both at 714cbd1, zero divergence), feature branch deleted.

    CAVEAT ON THE MAIN-PUSH CI: it is RED, but for network reasons only, not code. Both `backend` and `backend-lint` died in "Install (dev group)" before ruff, mypy or pytest ever executed — first "Failed to download distribution due to network timeout (UV_HTTP_TIMEOUT 30s)", then on later retries an explicit "dns error" on package downloads. Three re-runs, same class of failure each time; my own host was simultaneously failing to resolve g5.citops.net and getting connection resets from api.github.com, so this was a site-wide DNS/network wobble, not the runners. api-types, changes and secret-scan passed throughout.

    The identical tree content is proven green three independent ways:
    - PR #499 CI fully green, including the full backend job (8m04s, pytest ran)
    - staging combined-check green on the same content, plus a successful staging deploy
    - local full backend suite 2461 passed; ruff check + ruff format + mypy (522 files) clean

    Worth re-running the main run once DNS settles, purely to get the belt-and-braces gate green.

    STILL OUTSTANDING (unchanged): the Azure write service principal's custom role needs
      Microsoft.DBforMySQL/flexibleServers/restart/action
      Microsoft.DBforMySQL/flexibleServers/read
    before the operation can actually execute against the live subscription.
assignee: steve
label: null
priority: medium
task_status: done
---
Close the one catalogue inconsistency left by the sprint: MySQL flexible servers are discovered as database entities (`Microsoft.DBforMySQL/flexibleServers`, ADR 0059) but have no restart action, despite sharing the PG flexible server's `/restart` ARM API.

- `restart_mysql_flexible_server` (T2 — same rationale as the PG restart, ADR 0061 §2: a database outage window on a stateful system). Amend the ADR 0061 §2 tier table.
- Schema mirrors `_pg_server_action_schema`: full lower-case ARM id pinned to `microsoft.dbformysql/flexibleservers` (deny-list exact-match spelling, ADR 0061 §3).
- Handler mirrors `_act_restart_pg_flexible_server`: describe-first before-capture (server state), restart via `run_action` (api-version `2023-12-30`, the pinned discovery version).
- Write SP RBAC addition: `Microsoft.DBforMySQL/flexibleServers/restart/action` + `…/read` — note it in ADR 0061 §1's custom role.
- Tests in `test_azure_actions.py` (before-capture, not-found, schema pin); tier-table pin in `test_azure_connector.py` gains the seventh row.