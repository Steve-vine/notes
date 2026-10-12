---
id: 01M4RP1V03QB96VP4QJV8T6Z2S
created: 2026-10-12T18:29:57.891862Z
updated: 2026-10-12T18:29:57.891862Z
type: task
title: Compass reads what holds data in a connected Azure subscription — storage accounts, SQL databases, PostgreSQL and MySQL servers and Cosmos DB accounts — every six hours and on demand
priority: high
task_status: todo
label: feature
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 919
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