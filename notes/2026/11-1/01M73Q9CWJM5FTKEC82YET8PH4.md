---
id: 01M73Q9CWJM5FTKEC82YET8PH4
created: 2026-11-10T21:54:36.562323Z
updated: 2026-11-10T21:58:12.766543Z
type: task
title: 'Inventory from a feed: what a service holds arrives on Discovered for a person to decide, with discovery rules applying, and is marked gone when a complete read no longer finds it'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1699
sprint: sep79bz
assignee: steve
label:
- feature
priority: high
task_status: todo
---
The Inventory side of ADR 0145 (COM-1695), plugged into feeds (COM-1697).

**Chain:** on the chain — migration + API

## What the person sees

- A feed into Inventory adds **discovered resources** to the company's Discovered list, alongside what AWS, Azure, Google Cloud and the directory find. Each one says it came from the service (name and logo) and through which account.
- Each resource carries the mapped **kind** ("Repository", "Cluster", "Zone"), **name**, the service's own ID, when it was created, and up to a handful of **facts** the feed chose by name (e.g. visibility, default branch, region). Facts are configuration, never a whole response (ADR 0099).
- Everything Discovered does today works for these too: make a technology asset, attach to one, discard with a reason, and **discovery rules** (a rule can be limited to the service, and match on kind and name).
- **Gone:** a resource a complete read no longer finds is marked gone, exactly as for cloud resources. One attached to an asset shows on that asset as gone.
- The kinds a feed brings appear in Discovered's kind filter. Its category (compute, data, network…) is mapped by the feed, with *other* as the default.

## Done when

- A feed can map ADR 0145's Inventory shape. The preview lists the resources it would add, update or mark gone.
- Discovered, attach and discard, rules and gone all behave as for a cloud connection, tested with a fake service against real Postgres.
- `inventory_list_discovered` and `inventory_get_discovered_resource` show feed resources and their source.
- Switching off or deleting the feed marks nothing gone.
- No service name in code (COM-1696).

## Notes

- `models/discovery.py` `DiscoveredResource`: `provider` is `String(16)` and `connection_id` points at `discovery_connections`. A feed resource needs its source to be the Collection account, so add a nullable `collection_account_id` and a provider value meaning "a Collection service". Don't add a provider per service.
- `uq_discovered_resources_identity` is (company, provider, native_id). Make sure two services' IDs can't collide, e.g. by scoping native_id with the integration's key.
- What's never read (ADR 0099 §7) still applies. Facts are a short named list, so keep their size bounded.