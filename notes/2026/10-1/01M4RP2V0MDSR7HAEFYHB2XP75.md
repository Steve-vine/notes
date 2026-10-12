---
id: 01M4RP2V0MDSR7HAEFYHB2XP75
created: 2026-10-12T18:30:30.676848Z
updated: 2026-10-12T18:30:42.078175Z
type: task
title: An Azure tenant is connected once — its subscriptions are listed, each is switched on for a company, and a new subscription does not go unread unnoticed
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 922
sprint: svsqcj9
label:
- feature
priority: high
task_status: todo
---
Part of sprint 67, Inventory expansion (ADR in COM-917). The Azure counterpart of connecting an AWS organisation (COM-890).

## What people see

- **Inventory ▸ Settings gains "Azure tenants"** below "Azure subscriptions". Connecting a tenant asks for a name, the directory (tenant) ID, an application (client) ID and its client secret.
- **Compass lists the subscriptions that app can see**, each as one of: read (switched on for a company), left off with a reason, or new and not read.
- **Switching a subscription on** asks which company, a name, Production or Non-production, and how to sign in: **with the tenant's app** (one click, if that app holds the read-only role on the subscription) or **with an app of its own** (its application ID and secret entered then). It then appears under "Azure subscriptions" like any other and is read the same way.
- **A subscription that appears later is listed as new, not read,** and raises one action for the Inventory admins: switch on, or leave off with a reason.
- **A subscription Azure reports as disabled or deleted is not read**, and says why.
- **Removing a tenant** stops the listing. Subscriptions read with an app of their own carry on. Subscriptions read with the tenant's app stop being readable and say so, until given an app of their own.
- **Who:** Inventory admins.

## Notes (technical)

- **`azure_tenants`** (company-scoped; `tenant_id` unique; `client_id`, `client_secret_encrypted`; health; `last_synced_at`) and **`azure_tenant_subscriptions`** (`subscription_id`, `name`, `status`, `decision`, `off_reason`, who and when) in the shape of `aws_organisations` / `aws_organisation_accounts`.
- **`azure_connections` gains** `auth` (`app` | `tenant`) and `azure_tenant_id` (FK, SET NULL). A `tenant` connection signs in with the tenant row's app; nothing is copied.
- **Listing** is `GET /subscriptions` as the tenant's app: Azure returns what the app has any role on. `core/discovery/azure_tenant.py`, in the shape of `organisation.py`: new → undecided unless already connected; no longer listed → kept and marked gone; a failed listing changes nothing but the health.
- **The six-hourly pass lists tenants first**, and does not read a subscription Azure says is not enabled.
- **Action source** `inventory_azure_subscriptions_undecided`, beside the AWS one.
- **API.** `/api/v1/inventory/azure-tenants` (list, create, update, delete, refresh, switch on, leave off) under `inventory.admin`.
- **Docs.** `docs/azure/README.md` gains the tenant route: assign the role at a management group so the tenant's app sees every subscription beneath it.
- **Screen.** `inventory/AzureTenantsCard.tsx`.

**Done when:** on staging a tenant is connected, its subscriptions are listed, one is switched on with the tenant's app and read.