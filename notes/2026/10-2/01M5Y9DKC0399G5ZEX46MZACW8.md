---
id: 01M5Y9DKC0399G5ZEX46MZACW8
created: 2026-10-27T09:00:20.224899Z
updated: 2026-10-27T13:47:59.729398Z
type: task
title: The Azure tile — each company's subscriptions and tenants move in from Inventory ▸ Settings
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1353
sprint: s8fmesf
blocked_by:
- 01M5Y9C3P6MGA186PBB0BF38C4
comments:
- id: 01M5YSW8E5FCT5VH4QCHZPWXTF
  author: Steve Vine
  at: 2026-10-27T13:47:57.764973Z
  text: |-
    Done — PR #1370, merged to main. It has the AWS tile's shape.

    - Azure ▸ Configure: each company's Subscriptions and Tenants, moved from Inventory ▸ Settings, following the company picker and working as before. Inventory admin only.
    - Overview: an app registration and secret per subscription or a tenant's app reaching many, the read role, that Compass changes nothing, and that it's a separate app from the Microsoft integration's Entra app.
    - Features ▸ Inventory discovery: off skips the six-hourly read, including the tenant listing that runs first. Read now answers "Inventory discovery is switched off on the Azure integration."
    - Status: every live company's subscriptions, with last read, found and last error. Any failing one turns the tile to Needs attention.
    - Inventory ▸ Settings no longer shows Azure.

    Not done: a separate warning for a secret close to expiry. Azure doesn't hand us the expiry through the read role Compass holds. An expired or rejected secret already fails the 15-minute health check and turns the tile to Needs attention.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Sprint 90, Integrations (ADR in COM-1347). Builds on COM-1349; the same shape as the AWS tile (COM-1352).

## What people see

- **Category:** Cloud.
- **Overview:**
  - an app registration and secret per subscription, or the tenant's app reaching many (ADR 0103);
  - the custom read role from `docs/azure`;
  - that Compass changes nothing.
  - It is a separate app from the Microsoft tile's Entra app.
- **Configure:** **Subscriptions** and **Tenants**, moved from Inventory ▸ Settings. They follow the company picker and work as today (add, Test, Read now, switch on, remove).
- **Features:**
  - **Inventory discovery**, every 6 hours.
  - Sprint 93 adds **Vulnerabilities** (Microsoft Defender for Cloud).
- **Status:** one row per subscription across every company. Needs attention when any last read failed or a secret is close to expiry, if Azure tells us the expiry.

## Who can do what

Inventory admin, as today.

## Notes (technical)

- Move `inventory/AzureSubscriptionsCard` and `AzureTenantsCard`.
- Gate the Azure discovery Beat job and Read now.

**Chain:** on the chain (API).

**Done when:**
- a subscription is added, tested and read from the tile;
- Azure is gone from Inventory ▸ Settings;
- the switch skips the next read.