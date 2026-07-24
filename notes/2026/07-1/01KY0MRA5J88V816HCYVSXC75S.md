---
id: 01KY0MRA5J88V816HCYVSXC75S
created: 2026-07-20T20:51:19.858054Z
updated: 2026-07-24T07:17:35.203062Z
type: task
title: 'Enrich DataDog alert details: monitor tags/query/message + host: entity keys'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 172
order: -1.0
sprint: skj7tft
comments:
- id: 01KY1X7D2F4HTAFW3241XAY8SY
  author: Steve Vine
  at: 2026-07-21T08:38:37.391695Z
  text: |-
    PR #150 → main, merged to staging. Stacked on ISE-153 + ISE-151.

    Both halves done. `details` now carries `query`, `message` (truncated to 1000 chars — free text persisted per firing group) and `tags`; `_entity_key_from_group` resolves `host:` to the `datadog:host:{name}` entity ISE-151's discovery mints, ordered most-specific-first so a service on a named host still resolves to the service.

    Signal drill-in renders query as monospace, message as wrapped prose and tags as badges, full width — none fits a two-column grid cell. An alert without them renders exactly as before.
assignee: steve
priority: medium
task_status: done
---
A DataDog alert in ISE carries almost none of the context DataDog has about it — e.g. "Low Disk Space is Warn" names neither the instance nor the volume. The scope half is ISE-153 (per-group state → `host:…,device:…` in title/key/details). This task is the *enrichment* half: carry across what `list_monitors()` already returns but `_group_finding` discards (`connectors/datadog.py:717-740` — `details` keeps only monitor_id/group/state/type/monitor_url).

## 1. Enrich `details` at detect time

Add to each Alert finding's `details`:

- **`tags`** — the monitor's tags (already fetched; the monitors state slice keeps them, the finding drops them).
- **`query`** — the monitor query: names the metric, scope and thresholds (for a disk monitor, exactly the "what and where").
- **`message`** — the monitor's notification message (often carries runbook context/links). Truncate sensibly; passes through the standard redaction on any surface that already redacts connector output.

Surface them on the signal drill-in (`SignalDetail`, `SignalsPage.tsx`) — query/message as readable blocks, tags as badges. Idempotent upsert unaffected (details are overwritten each sync).

## 2. Map `host:` scope tags to estate entity keys

`_entity_key_from_group` (`datadog.py:168-187`) resolves only `service:` and `kube_namespace`+`kube_deployment` — a host-scoped alert (the Low Disk Space case) can never join the estate graph even once ISE-153 delivers the group. Add `host:` → a host-native entity key (align the key shape with what ISE-151 chooses for DataDog host entity discovery — coordinate: an entity_key with no matching discovered entity resolves to nothing).

## Dependencies / companions (all Sprint 16)

- **ISE-153** — per-group state; without it there is no group to derive scope or entity keys from. Land first or together.
- **ISE-151** — DataDog entity discovery (service catalogue + scope tags/hosts); provides the entities the new `host:` keys resolve to.
- ISE-171 — relatedness fallback; better details make bad matches easier to spot besides.

## DoD

For a real host-scoped monitor: the ISE signal shows the triggering scope, the monitor query, message and tags in the drill-in; a `host:`-scoped alert carries an entity_key; findings for group-less simple monitors still work with the new fields present.