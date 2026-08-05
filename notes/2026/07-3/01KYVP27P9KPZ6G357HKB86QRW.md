---
id: 01KYVP27P9KPZ6G357HKB86QRW
created: 2026-07-31T08:53:43.241624Z
updated: 2026-08-05T14:24:59.23091Z
type: task
title: Cloudflare DNS + cache actions — update_dns_record, purge_cache
project: 01KX671DATY39VW6GWK3M2T3DN
number: 395
order: 1.0
sprint: s39ax46
blocked_by:
- 01KYVP1J34DFAEJ4VNBX5BADX7
comments:
- id: 01KYVPMTV4BNBJN7J2DE1ZSE56
  author: Steve Vine
  at: 2026-07-31T09:03:52.675901Z
  text: |-
    Built and in review — PR #362 (feature/ise-395-cloudflare-dns-cache-actions, stacked on #361, targeting main), merged to staging (8cbf56b).

    Delivered: the DNS and cache half of the ADR 0065 catalogue, all exercised through the full act() gate path (catalogue membership → schema validation → protected targets → handler). update_dns_record (T2) fetches the record first — prior content/TTL/proxied ride `before` as the rollback substrate, a stale id is a failed "not found" change never an implicit create (pinned by test), and the PATCH carries exactly the approved fields with nothing merged from current state. Schema safety: anyOf refuses an edit that names no field to change (a drafting mistake dies at proposal time), and the 32-hex id patterns refuse a hostname pasted where a record id belongs. purge_cache_urls (T1) enforces Cloudflare's own 30-URL per-call cap in the schema; purge_cache_everything (T2) is deliberately a separate operation — tier is a property of the operation, fixed in code, never a runtime choice — with the origin-load consequence spelled out in its expected_effect. Cloudflare errors (e.g. a permission-lacking write's success:false) contain into failed ActionResults on the audit trail.

    9 new tests; ruff + mypy (429 files) green; PR CI running.
assignee: steve
label: null
priority: medium
task_status: done
---
The DNS and cache half of the ADR 0065 catalogue (decided with Steve 2026-07-31: update-existing-only for DNS).

- `update_dns_record` (T2): edit ONE existing record's content / TTL / proxied via `PATCH /zones/{zone_id}/dns_records/{record_id}`. Before-capture: GET the record first — prior content/ttl/proxied ride `before` (the rollback substrate); a missing record is a failed change ("not found"), never a create. **No create, no delete** — deliberately out of v1.
- `purge_cache_urls` (T1): `POST /zones/{zone_id}/purge_cache` with a bounded `files` list (≤30 URLs, Cloudflare's own cap). Repeatable, no config change.
- `purge_cache_everything` (T2): same endpoint with `purge_everything: true` — separate operation because the tier differs (origin load spike risk) and tier is fixed per op, never chosen at runtime.
- All handlers contain Cloudflare errors into failed ActionResults (audit trail, never a crashed worker); execution-path tests for every op against the stubbed client (ADR 0016 priority 2).