---
id: 01M5Y9CZ2EQ00A6WK97PK2YDHC
created: 2026-10-27T08:59:59.438742Z
updated: 2026-10-27T09:02:14.099422Z
type: task
title: The Active Directory tile — the domain connection, the mirror and managed OUs move in from Admin, and reading servers from the directory for Inventory becomes one of its features
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1351
sprint: s8fmesf
blocked_by:
- 01M5Y9C3P6MGA186PBB0BF38C4
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint 90, Integrations (ADR in COM-1347). Builds on COM-1349.

## What people see

- **Category:** Identity & directory.
- **Overview:**
  - the three setups (ADR 0083);
  - how Compass reaches the domain (LDAPS or Kerberos, ADR 0086);
  - the rights it needs, delegated once on the domain root, never per OU (Steve, 2026-10-14);
  - a link to `docs/active-directory`.
- **Configure:**
  - Directory setup, the same setting as on the Microsoft tile;
  - the domain connection: servers, bind account and password or Kerberos, the CA certificate, Test;
  - the mirror and managed-OU panels from today's Admin ▸ Integrations;
  - each company's directory servers read for Inventory (moved from Inventory ▸ Settings), following the company picker.
- **Features:**
  - **Directory for Access Control**: read accounts and groups, and make the changes access requests approve;
  - **Servers for Inventory**: domain-joined servers, per company.
  - Changes Compass can't make in a hybrid tenant stay to-dos (ADR 0079). Nothing about them changes.
- **Status:** health from the existing 5-minute check, the last sync and the last full nightly sync.

## Who can do what

- The connection, mirror and OUs need manage integrations, as today.
- Each company's servers list needs Inventory admin, as today.

## Notes (technical)

- Move the cards from `admin/DirectoryIntegrations.tsx` and `inventory/DirectoryServersCard`. Endpoints unchanged.
- Gate the AD sync, the nightly full sync and directory discovery on their switches.

**Chain:** on the chain (API: feature gating).

**Done when:**
- AD is set up and tested from the tile;
- the per-company servers list works there and is gone from Inventory ▸ Settings;
- each switch stops only its own work.