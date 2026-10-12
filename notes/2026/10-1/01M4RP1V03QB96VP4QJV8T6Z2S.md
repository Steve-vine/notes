---
id: 01M4RP1V03QB96VP4QJV8T6Z2S
created: 2026-10-12T18:29:57.891862Z
updated: 2026-10-12T21:57:19.577203Z
type: task
title: Compass reads what holds data in a connected Azure subscription — storage accounts, SQL databases, PostgreSQL and MySQL servers and Cosmos DB accounts — every six hours and on demand
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 919
sprint: svsqcj9
blocked_by:
- 01M4RP1CJ5J8DSKPRP8ME0NJ7E
comments:
- id: 01M4RSYCQ86ZD84VXZ03GNT2RN
  author: Me
  at: 2026-10-12T19:37:59.272094Z
  text: |-
    Merged to main (PR #921, 2026-10-12). Not on staging until you say.

    What to look at, once a subscription is connected:
    - Inventory ▸ Settings ▸ Azure subscriptions: each row now has Read now, and under the name says what the last read found ("12 resources found: 3 storage accounts, 4 sql databases…"). A kind that could not be read is named in orange or red with what to do.
    - Inventory ▸ Discovered: Azure resources are in the same list as AWS ones. Same three decisions, same bulk actions, same rules.
    - The "Account" filter, column and rule field are now called "Found in", and list AWS accounts and Azure subscriptions together. I renamed it because a subscription is not an account. Say if you would rather keep "Account".
    - Making a technology asset from one pre-fills "Azure · uksouth · PostgreSQL 16.4 server".

    What is read: storage accounts, SQL databases, PostgreSQL servers, MySQL servers, Cosmos DB accounts.

    Things worth knowing:
    - A SQL database is listed, not its server. Each database carries its server's public endpoint and firewall facts. The server's own "master" database is not listed.
    - Azure encrypts storage accounts, PostgreSQL, MySQL and Cosmos DB at rest and does not allow that to be switched off, so there is no "encrypted" fact for those. SQL databases do have one.
    - "Open to every address" means a firewall rule from 0.0.0.0 to 255.255.255.255. "Open to all Azure services" (Azure's 0.0.0.0 rule) is shown as a fact but is not treated as open to the internet.
    - A kind the subscription has never used reads as none found, not as a failure.

    Not tested against a real subscription. The field names come from Azure's published API, not a live answer, so the first real read may show a fact as Unknown that should not be. Tell me what you see and I will fix it forward.

    Technical: migration 0245 (discovered_resources.azure_connection_id). core/discovery/sources.py now answers for both providers, so review, rules, findings and the Discovered API no longer import the AWS registry. sync.py's upsert and sweep take the source as an argument; the AWS read is otherwise unchanged and its suites pass as they were.
label:
- feature
priority: high
task_status: done
---
Part of sprint 67, Inventory expansion (ADR in COM-917). This is the reading. What it finds appears on the Discovered tab that AWS already uses, and is decided the same three ways.

## What people see

- **Each connected Azure subscription shows** when it was last read, how many resources were found, and a count per kind. **Read now** reads it at once.
- **The Discovered tab lists Azure resources beside AWS ones:** the same columns, the same three decisions (make a technology asset, add to one, discard with a reason), the same bulk actions. The account filter lists subscriptions and AWS accounts together.
- **What is read, and what Compass says about each:**
  - Storage account: whether anyone can read blobs without signing in, whether unencrypted connections are refused, how it is replicated, whether blob versions are kept.
  - SQL database: whether it is encrypted, whether its server has a public endpoint and whether that is open to every address, its tier and size.
  - PostgreSQL and MySQL servers: engine and version, public endpoint and whether open to every address, how many days of backups, whether it is zone-redundant, its storage.
  - Cosmos DB account: which API it speaks, whether it accepts connections from any network, how it is backed up, the regions it runs in.
- **A kind that could not be read says so on the subscription** and names the missing permission. Everything else is still read, and nothing of that kind is marked gone.
- **Rules file Azure resources as they arrive.** A rule can name a subscription as it can an AWS account.
- **A technology asset made from an Azure resource** is pre-filled "Azure · region · what it is".
- **Removing a subscription** keeps what is attached to a technology asset, marked no longer read.

## Notes (technical)

- **Readers** in `core/discovery/azure/`: `storage`, `sql`, `postgres`, `mysql`, `cosmos`, registered in `READERS`. Each declares its kind (`azure.storage.account` …), category, the role actions it needs, `read` and `summarise`. The shipped role is rebuilt from them and the test holds the file to it.
- **Every list is subscription-wide** and follows `nextLink`. A resource carries its own `location`. A resource provider the subscription has never registered is an empty answer, not a failure.
- **`discovered_resources.azure_connection_id`** (FK, SET NULL), beside `aws_connection_id`. `provider` is `azure`; `native_id` is the resource ID, lower-cased (Azure's IDs are case-insensitive and its APIs do not agree on case).
- **`core/discovery/sources.py`** joins the two registries, so `review`, `rules`, `findings`, `reads` and the Discovered API ask one place what a kind is called and which connection a resource belongs to.
- **`core/discovery/azure_sync.py`** drives the read; upsert, sweep and "a refused fact keeps its last known value" are the functions `sync.py` already has, given the source as an argument. A failed read never marks anything gone.
- **Celery.** `tasks/azure_discovery.py`: per-connection read and a six-hourly fan-out, in the `aws_discovery` shape.
- **API.** `POST /inventory/azure-connections/{id}/sync`; per-kind counts and verdicts on the connection. The Discovered `connection` filter and facets cover both sources.
- **Tests.** `tests/azure_fakes.py` answers Resource Manager through the one seam, in Azure's own response shapes.

**Done when:** on staging a connected subscription is read, its storage accounts and databases appear on the Discovered tab, and one can be made into a technology asset.