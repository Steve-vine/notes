---
id: 01M5Y9CZ2EQ00A6WK97PK2YDHC
created: 2026-10-27T08:59:59.438742Z
updated: 2026-10-27T12:37:56.704277Z
type: task
title: The Active Directory tile — the domain connection, the mirror and managed OUs move in from Admin, and reading servers from the directory for Inventory becomes one of its features
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1351
sprint: s8fmesf
blocked_by:
- 01M5Y9C3P6MGA186PBB0BF38C4
comments:
- id: 01M5YNW12YMVF3EDMQH5TPTVRZ
  author: Steve Vine
  at: 2026-10-27T12:37:55.934206Z
  text: |-
    Done — PR #1368, merged to main.

    What's there:
    - Active Directory ▸ Configure: the directory setup (the same setting the Microsoft tile shows, changeable from either) and the domain connection with Test, the mirror and the managed-OU panels, for those who manage integrations. Below them is each company's "Servers from the directory" list, moved from Inventory ▸ Settings and following the company picker, for Inventory admins. The same list also shows on the Microsoft tile.
    - Overview: the three setups, LDAPS or Kerberos, the rights delegated once on the domain root, and a link to docs/active-directory.
    - Features:
      - Directory for Access Control: off stops the five-minute and nightly AD reads. AD changes from access requests wait, saying why, and run once it's back on. Hybrid to-dos are unchanged.
      - Servers for Inventory: off skips each company's servers read, and Read now says so.
    - Status: health from the five-minute check, the last read and the last full nightly read.
    - Inventory ▸ Settings no longer shows the servers card.

    Who can do what is unchanged: the connection, mirror and OUs need manage integrations; the servers list needs Inventory admin. Either may switch Servers for Inventory.
assignee: steve
label:
- feature
priority: medium
task_status: review
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