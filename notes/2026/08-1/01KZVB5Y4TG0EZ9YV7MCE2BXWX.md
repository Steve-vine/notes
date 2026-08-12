---
id: 01KZVB5Y4TG0EZ9YV7MCE2BXWX
created: 2026-08-12T15:59:12.026222Z
updated: 2026-08-12T15:59:12.026222Z
type: task
title: Add `redvektor-admin reset-password` CLI subcommand
imported_from: linear
task_status: backlog
label: feature
priority: low
assignee: steve
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 99
---
If a super-admin forgets their password, the only recovery is to delete the user row and recreate. Argon2id is one-way; no recovery from the hash. A `redvektor-admin reset-password --email <e>` subcommand using the same env-var pattern would fix this in a few lines.

Source: Obsidian Issues Tracker #28 (P4 Low, Open). Discovered during Brief 007 live verification when password was unknown after re-creating the cluster.

---

Imported from Linear [DEV-29](https://linear.app/stevevine/issue/DEV-29/add-redvektor-admin-reset-password-cli-subcommand)