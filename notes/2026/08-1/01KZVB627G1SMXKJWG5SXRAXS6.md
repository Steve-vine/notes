---
id: 01KZVB627G1SMXKJWG5SXRAXS6
created: 2026-08-12T15:59:16.208745Z
updated: 2026-08-12T16:00:32.701443Z
type: task
title: '`redvektor-admin create-user` getpass fails under non-TTY contexts'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 100
sprint: s1hm0kb
assignee: steve
imported_from: linear
label:
- bug
priority: low
task_status: backlog
---
When invoked via `kubectl exec` (no `-it` flag) or any non-interactive context, the CLI's `getpass.getpass()` prompt fails with "Can not control echo on the terminal" and aborts. Workaround: pass `REDVEKTOR_ADMIN_PASSWORD` env var via `kubectl exec deploy/rv-redvektor-api -- env REDVEKTOR_ADMIN_PASSWORD='...'`. Should be documented in chart/README.md and ideally promoted to a first-class `--password-from-env` flag.

Source: Obsidian Issues Tracker #27 (P4 Low, Open).

---

Imported from Linear [DEV-28](https://linear.app/stevevine/issue/DEV-28/redvektor-admin-create-user-getpass-fails-under-non-tty-contexts)