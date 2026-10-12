---
id: 01M4RP1CJ5J8DSKPRP8ME0NJ7E
created: 2026-10-12T18:29:43.109742Z
updated: 2026-10-12T18:30:45.046857Z
type: task
title: An Inventory admin connects an Azure subscription to a company — tests it, sees its health, and can remove it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 918
sprint: svsqcj9
blocked_by:
- 01M4RP0X7DY8P14EXXPSE4NA5Z
label:
- feature
priority: high
task_status: todo
---
Part of sprint 67, Inventory expansion (ADR in COM-917). This is the connection only. Nothing is read from the subscription until the next task.

## What people see

- **Inventory ▸ Settings gains "Azure subscriptions"** for the current company, below the AWS cards: a list of connected subscriptions with a name, the subscription ID, a health pill and when each was last read.
- **Adding a subscription asks for** the subscription ID, a name, the directory (tenant) ID, the application (client) ID and its client secret, and whether the subscription is Production or Non-production. There is no region choice: a subscription is read whole.
- **Compass shows what to set up on the Azure side:** a role file to download, already filled in with the subscription, and the three steps to follow (create the role, create the app registration, give the app the role). The role can list and describe resources. It cannot read what is inside them.
- **Test** says which subscription it reached, or why it could not, in plain words: the directory does not exist, the application is not in that directory, the secret is wrong, the secret has expired, the app has no role on the subscription, or the subscription is disabled.
- **The secret can be replaced under Edit** and is never shown again. The row shows the end of the application ID so two apps can be told apart.
- **Removing a subscription asks first** and says what happens: resources already attached to technology assets stay, marked "no longer read"; anything still awaiting a decision goes; Compass deletes its copy of the secret.
- **Who:** Inventory admins.

## Notes (technical)

- **`azure_connections`**, company-scoped, the usual mixins. `subscription_id` (unique across the deployment), `name`, `tenant_id`, `client_id`, `client_secret_encrypted` (`core.secretbox`), `default_environment`, the health columns and the read columns in the `aws_connections` shape.
- **`core/azure.py`: the one place a request to Azure is made.** Client-credentials token from `login.microsoftonline.com` for `https://management.azure.com/.default`, cached until shortly before it expires and keyed so a replaced secret takes effect at once; `get` and `pages` (follows `nextLink`) against Azure Resource Manager; 429 and 5xx retried with `Retry-After`. `_new_client` is the test seam (httpx `MockTransport`, as `test_graph.py`). No Azure SDK and no new dependency.
- **Errors leave as `AzureError`** with a sentence a person can act on. The provider's text is never passed through.
- **Health.** `GET /subscriptions/{id}`; the same check as Test. A beat task every 15 minutes, in the shape of `tasks/aws_health.py`.
- **The shipped role.** `docs/azure/compass-discovery-role.json`, generated from the readers' declared actions and held to them by a test, with `docs/azure/README.md` for the three steps. This task ships the subscription-read actions; each reader task adds its own.
- **API.** `/api/v1/inventory/azure-connections` (list, setup, create, update, delete, test) under `inventory.admin`. Regenerate `schema.d.ts`.
- **Audit.** `azure_connections` joins `_AUDITED_TABLES`; health writes are actorless. The secret's column name is on the redaction list.
- **Screen.** `inventory/AzureSubscriptionsCard.tsx` on the Inventory Settings panel.

**Needs from Steve before smoke-testing:** an Azure subscription, with an app registration that holds the role from the downloaded file, and a client secret for it.

**Done when:** on staging an Azure subscription is connected to a company, Test names the subscription, the health pill is green, and removing it works.