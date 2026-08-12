---
id: 01KZVBNV627T1M06GEQPFSFBYF
created: 2026-08-12T16:07:53.282205Z
updated: 2026-08-12T16:07:53.282205Z
type: task
title: CNPG peer-auth blocks `psql -U redvektor` from inside postgres pod
imported_from: linear
label: bug
assignee: steve
priority: low
task_status: backlog
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 132
---
CNPG's bundled `pg_hba.conf` requires the OS user to match the DB user when connecting via the unix socket. `kubectl exec rv-redvektor-postgres-1 -- psql -U redvektor` runs as the `postgres` OS user inside the pod, so peer-auth fails. Workaround: pass `-h localhost` to force TCP and supply `PGPASSWORD` from the chart's app-creds Secret. Mostly invisible after Brief 008a removed the only documented psql invocation; flagged here for future ad-hoc DB shell tasks.

Source: Obsidian Issues Tracker #29 (P4 Low, Open).

---

Imported from Linear [DEV-30](https://linear.app/stevevine/issue/DEV-30/cnpg-peer-auth-blocks-psql-u-redvektor-from-inside-postgres-pod)