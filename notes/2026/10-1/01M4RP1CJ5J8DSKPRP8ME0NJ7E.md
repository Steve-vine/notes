---
id: 01M4RP1CJ5J8DSKPRP8ME0NJ7E
created: 2026-10-12T18:29:43.109742Z
updated: 2026-10-12T19:04:16.807636Z
type: task
title: An Inventory admin connects an Azure subscription to a company — tests it, sees its health, and can remove it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 918
sprint: svsqcj9
blocked_by:
- 01M4RP0X7DY8P14EXXPSE4NA5Z
comments:
- id: 01M4RR0J0X9ZYDW17TWQKQN65N
  author: Me
  at: 2026-10-12T19:04:13.085098Z
  text: |-
    Merged to main (PR #920, 2026-10-12). Not on staging until you say.

    What to look at:
    - Inventory ▸ Settings ▸ Azure subscriptions, below the two AWS cards.
    - Add subscription: type the subscription ID first. A grey box then appears with a "Download the role file" button and two commands to copy, already filled in for that subscription. Run them in Azure; the second prints the directory ID, application ID and secret. Enter those, choose Production or Non-production, and add.
    - A "Set up … in Azure" window opens with the same file and commands and a Test button. Test names the subscription it reached, or says what is wrong.
    - Each row has Set up and test, Edit and Remove. Edit keeps the saved secret unless you type a new one.

    Needed from you before this can be smoke-tested: an Azure subscription, and the right to create a role and an app registration in it (Owner or User Access Administrator). The steps are also in docs/azure/README.md.

    Things that differ from the task text:
    - The task said the row shows the end of the application ID. It shows the whole ID: it is not secret, and it is what you search for in Azure.
    - "What to create in Azure" is offered as soon as the subscription ID is typed, before anything is saved. Otherwise you would have had to add the subscription before you had its secret.
    - One more failure Test can name: the subscription is in a different directory from the app.

    Azure ends every client secret on a date. The command Compass gives asks for one year. When it lapses the health pill turns red within fifteen minutes and says "has expired — make a new one in Azure". There is no warning ahead of the date yet.

    Technical: migration 0244 (azure_connections). core/azure.py is the one place a request to Azure is made; no Azure SDK, no new dependency. docs/azure/ holds the role file, generated from code and held in step by a test. The health check is the same check as Test and leaves no activity entries.
label:
- feature
priority: high
task_status: review
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