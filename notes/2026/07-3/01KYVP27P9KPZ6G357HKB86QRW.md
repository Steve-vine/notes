---
id: 01KYVP27P9KPZ6G357HKB86QRW
created: 2026-07-31T08:53:43.241624Z
updated: 2026-07-31T08:55:29.261229Z
type: task
title: Cloudflare DNS + cache actions — update_dns_record, purge_cache
project: 01KX671DATY39VW6GWK3M2T3DN
number: 395
order: 1.0
sprint: s39ax46
blocked_by:
- 01KYVP1J34DFAEJ4VNBX5BADX7
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
The DNS and cache half of the ADR 0065 catalogue (decided with Steve 2026-07-31: update-existing-only for DNS).

- `update_dns_record` (T2): edit ONE existing record's content / TTL / proxied via `PATCH /zones/{zone_id}/dns_records/{record_id}`. Before-capture: GET the record first — prior content/ttl/proxied ride `before` (the rollback substrate); a missing record is a failed change ("not found"), never a create. **No create, no delete** — deliberately out of v1.
- `purge_cache_urls` (T1): `POST /zones/{zone_id}/purge_cache` with a bounded `files` list (≤30 URLs, Cloudflare's own cap). Repeatable, no config change.
- `purge_cache_everything` (T2): same endpoint with `purge_everything: true` — separate operation because the tier differs (origin load spike risk) and tier is fixed per op, never chosen at runtime.
- All handlers contain Cloudflare errors into failed ActionResults (audit trail, never a crashed worker); execution-path tests for every op against the stubbed client (ADR 0016 priority 2).