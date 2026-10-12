---
id: 01M4RP0X7DY8P14EXXPSE4NA5Z
created: 2026-10-12T18:29:27.405974Z
updated: 2026-10-12T18:47:46.943305Z
type: task
title: 'ADR: Azure is the second source — a subscription is read as an app registration of its own, with a read-only role that names what it may see'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 917
sprint: svsqcj9
comments:
- id: 01M4RQ2C087SG61BDCRQXSD4FF
  author: Me
  at: 2026-10-12T18:47:43.880432Z
  text: |-
    Merged to main (PR #919, 2026-10-12). ADR 0103, decisions/0103-azure-is-the-second-source.md. Nothing to look at on staging: it is the record the other five Azure tasks build to.

    My calls in it, yours to overturn:
    - An app registration and client secret per subscription, held like an AWS access key. No second "role" way: Compass does not run in Azure, so there is no keyless route to keep.
    - One app per subscription is recommended, not enforced. Azure lets one app hold a role on many subscriptions and Compass cannot tell.
    - Not the Entra app Compass already has. One secret would then reach both the directory and the estate.
    - A custom role naming each read action, not Azure's built-in Reader. One role per subscription, named with the start of its ID, because Azure wants role names unique in a directory.
    - A subscription is read whole. No region choice.
    - A SQL database is the resource, not its server. A storage account is the resource, not its containers.
    - A subscription switched on from a tenant may be read with the tenant's app (one click) or an app of its own. The first is how Azure is usually run but means one secret reaches many subscriptions.

    One thing with no AWS counterpart: Azure ends every client secret on a date (a year with the command Compass gives, two at most). Compass says so when that is why a sign-in was refused. It does not warn ahead of the date yet; that is named as later.
label:
- brief
priority: high
task_status: review
---
Part of sprint 67, Inventory expansion. Steve, 2026-10-12: "let's get an Azure integration working now, same as the AWS one." This record gates the other Azure tasks.

ADR 0099 §6 named Azure as a later source that reuses the resource record, the three outcomes, the rules and the findings. This record settles the parts that are Azure's own.

## What it decides

- **How Compass signs in.** Each connected subscription has an app registration and a client secret, entered when the subscription is connected and kept the way an AWS access key is: encrypted, write-only, replaceable, never read back. This is the AWS "its own user" way (ADR 0101) and the only way offered: Compass does not run in Azure, so there is no keyless route to keep.
- **What the app may see.** A custom role Compass ships, naming each read action the readers use. Not Azure's built-in Reader, which reads the configuration of everything in the subscription.
- **What is never read or stored.** The contents of anything, storage keys, connection strings, app settings, container environment values, VM user data.
- **A subscription connects to one company**, states Production or Non-production, and is read whole: Azure lists a kind once for the subscription, so there is no region choice.
- **What it reads first.** Holds data: storage accounts, SQL databases, PostgreSQL and MySQL servers, Cosmos DB accounts. Runs things: virtual machines, scale sets, Kubernetes clusters, web apps, function apps, container apps. Lets traffic in: load balancers, application gateways.
- **A tenant can be connected once**, to list its subscriptions and offer each for connection, as an AWS organisation is.
- **A client secret expires.** Azure sets an end date on every secret. Compass says so when the sign-in is refused for that reason.

## Notes (technical)

- `decisions/0103-*.md`. Amends ADR 0099 §6 and §13 (Azure is no longer "later"); builds on ADR 0101 and ADR 0074.
- For implementers: `core/azure.py` is the one place a request to Azure is made and the test seam (httpx, no SDK, no new dependency); readers are a registry beside the AWS one; `discovered_resources` gains `azure_connection_id`; tables `azure_connections`, `azure_tenants`, `azure_tenant_subscriptions`.

**Done when:** the ADR is merged.