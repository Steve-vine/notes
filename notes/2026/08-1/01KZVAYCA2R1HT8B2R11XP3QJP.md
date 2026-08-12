---
id: 01KZVAYCA2R1HT8B2R11XP3QJP
created: 2026-08-12T15:55:04.386108Z
updated: 2026-08-12T15:56:09.557674Z
type: task
title: Migrate JWT signing from HS256 to RS256
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 81
sprint: sb1sfzd
assignee: steve
imported_from: linear
label:
- tech_debt
priority: medium
task_status: backlog
---
Brief 004 ships with HS256 (single shared secret). `kid` dispatch is already plumbed end-to-end. Migration: introduce asymmetric keypair as a second entry in `jwt_signing_keys`, publish JWKS endpoint, support both algorithms during rollover, flip `jwt_active_kid`, deprecate HS256.

Source: Obsidian To Do § Backlog.

---

Imported from Linear [DEV-56](https://linear.app/stevevine/issue/DEV-56/migrate-jwt-signing-from-hs256-to-rs256)