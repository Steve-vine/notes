---
id: 01KYQXFV6A8D0JEJ4Q6NA66GT8
created: 2026-07-29T21:46:31.498307Z
updated: 2026-07-29T21:46:32.091204Z
type: task
title: 'Status page incidents: fan out alert signals per affected tracked service'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 370
sprint: s9cqr80
assignee: steve
label:
- bug
priority: medium
task_status: backlog
---
A multi-component provider incident only lights ONE component on the dashboard.

**Symptom (seen live 2026-07-29):** the Claude status page shows 4 of 5 tracked services in `major_outage`, but the ISE business-service dashboard shows only 1 of the 5 Claude API entities in error.

**Root cause:** `reconcile_signals()` (`app/backend/src/ISE_api/status_pages.py`) mirrors each provider incident to a **single** Alert Finding attached only to the **first** affected tracked service (`entity_key=affected[0]`, `entity = next(...)`). The full affected list survives only in `details["affected"]`, which the dashboard never reads — `present_signals_for_members()` (`dashboards.py`) matches on `Finding.entity_id` only. Anthropic's one incident ("Elevated errors across all models") names 4 components, so one finding lights one tile.

**Fix:** fan the signal out per affected tracked service — dedup key `source_key = "{page_id}:{ext_id}:{service}"`, one Finding per (incident x tracked service), each attached to its own third-party entity. Recovery already works off the `source_key` prefix so the resolve/recover and stale-TTL paths carry over.

- [ ] `reconcile_signals`: per-service fan-out with the new `source_key` shape; migrate/recover findings with old-shape keys
- [ ] Check auto-incident promotion so one provider incident spanning N services doesn't over-count toward the threshold
- [ ] Contract test: one incident naming multiple tracked components raises a finding on each entity; resolution recovers all
- [ ] Verify on the dashboard: all affected member tiles go red (matches the status page detail screen)

Secondary gap (note, possibly its own task): component statuses alone never raise signals — only incidents do. A component marked `major_outage` with no incident naming it still shows OK on the dashboard.
