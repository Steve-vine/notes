---
id: 01M07P560ZPTMWWJG5YEXNJ1KA
created: 2026-08-17T11:01:54.847394Z
updated: 2026-08-17T11:02:15.34065Z
type: task
title: A DataDog host alert doesn't reach the registered server — IN-1403 named no entity at all
project: 01KX671DATY39VW6GWK3M2T3DN
number: 753
sprint: sevhjex
assignee: steve
label:
- bug
priority: medium
task_status: backlog
tech: null
---
Found 2026-08-17 on IN-1403, "DD Agent Offline is Alert on host:MPWXDataWH".

`issue.entity_id` is **NULL** — the incident names no entity. Yet both ends exist:

- a `host` entity `mpwxdatawh` (`8c37bab4-8780-42cc-860c-ace57d501ec8`), last seen 10:50 — after the incident opened at 10:43;
- a `registered_server` `mpwxdatawh`, state `reachable`, profile `s.vine-3`.

So the alert carries the hostname in its own title and key (`host:MPWXDataWH`), the host is in the estate, and the machine is registered in the servers integration — and none of it is joined. The investigation had to find the box **by reading the hostname out of the incident title**, which is why it went looking for a connection to make rather than a record to read.

The cost is not only inconvenience: an incident with no entity loses impact, playbooks and AI context, and says none of it — the shape [ISE-698] and the ISE-647 disambiguation work were about.

**Scope**
- Resolve a DataDog host-scoped alert to the `host` entity on ingest, via the hostname it already carries. Case-insensitive: DataDog says `MPWXDataWH`, the estate says `mpwxdatawh`, and hostname-as-identity is already the Canon rule.
- Check the registered-server ↔ host-entity binding while here: whether the join failed because the alert never resolved an entity, or because the server row and the entity are not bound to each other. The `registered_server` table has no `entity_id` column, so confirm how that link is meant to be expressed before assuming which half is missing.
- Watch the 2026-08-10 lesson (`ISE-647`): four clusters carry the same workload names, so a hostname join needs its disambiguation rule stated rather than assumed unique. A domain is available here — `domain_name = moneypenny.local` on the server row.
- Related and already known: DataDog monitor alerts that name no entity while carrying the tags that would place them. Check whether that fix covers this path or stops short of host-scoped service checks.

**Acceptance**: IN-1403's successor opens against the `mpwxdatawh` host entity, and the incident offers the registered server's own state without anyone typing the hostname.
