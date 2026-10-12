---
id: 01M4RP2V0MDSR7HAEFYHB2XP75
created: 2026-10-12T18:30:30.676848Z
updated: 2026-10-12T20:12:22.099258Z
type: task
title: An Azure tenant is connected once — its subscriptions are listed, each is switched on for a company, and a new subscription does not go unread unnoticed
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 922
sprint: svsqcj9
blocked_by:
- 01M4RP2EGKHAGV8XRAJNJMZZ0P
comments:
- id: 01M4RVXB6KMMGXWNW1Q2VZC098
  author: Me
  at: 2026-10-12T20:12:22.099118Z
  text: |-
    Merged to main (PR #924, 2026-10-12). Not on staging until you say.

    What to look at:
    - Inventory ▸ Settings ▸ Azure tenants, the last card. Connect a tenant: a name, then the directory (tenant) ID. Once that is typed a grey box offers a role file and two commands, scoped to the whole directory. Then the application ID and secret.
    - A "Set up … in Azure" window opens. "List subscriptions" is also the test.
    - Each subscription shows as "New, not read", "On for <company>", "Left off", "<state> in Azure" or "No longer listed". Only the first and third have buttons.
    - Switch on asks how Compass signs in: "The tenant's app" (nothing more to enter) or "An app of its own". Then a name, the company and Production or Non-production. The subscription then appears under Azure subscriptions, where its row says "Read with the app of tenant <name>".
    - Leave off needs a reason. A subscription that is being read has to be removed under Azure subscriptions first, as for AWS.
    - A new subscription raises one action, "New Azure subscriptions", to the Inventory admins.
    - Remove a tenant: the window names any subscriptions read with its app and says they will stop. They stay connected and keep what was found. Their row then says the tenant has gone and to give it an app of its own under Edit.

    Needed from you before this can be smoke-tested: a directory where you can create a role at a management group. Assigning a role at the root group needs "Access management for Azure resources" switched on for you in Entra. The steps are in docs/azure/README.md.

    The one place this departs from what you asked of AWS. You said one identity per account, so an AWS organisation that reads as its own user needs each account's own key. Here a subscription switched on from a tenant can be read with the tenant's app: one click, and one secret that reaches every subscription switched on that way. I offered both and left the tenant's app as the first choice because it is how Azure is normally run (a role given once at a management group), and forty subscriptions would otherwise be forty app registrations. The window says which is which, the row says which a subscription uses, and it can be changed to an app of its own later. If you want it the AWS way, the first choice can be swapped or the tenant's app removed as an option; that is a small change.

    Technical: migration 0246 (azure_tenants, azure_tenant_subscriptions; azure_connections gains auth and azure_tenant_id, client_id becomes nullable). A subscription read with its tenant's app stores no secret and nothing is copied: the tenant's is looked up at each use, so replacing it under the tenant mends every such subscription at once.
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