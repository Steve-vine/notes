---
id: 01KX8GY8VRP7405VR5X6MYFNGV
created: 2026-07-11T12:02:54.456173404Z
updated: 2026-07-24T12:49:31.686939Z
type: task
title: /api/v1 read endpoints for state snapshots + findings
project: 01KX671DATY39VW6GWK3M2T3DN
number: 25
sprint: sdm5e08
blocked_by:
- 01KX8GXWT9Q8DGJ7WJHB6RM8VA
comments:
- id: 01KX8ZCMTYY8ZMCJ8W1RXNF5T4
  author: Steve Vine
  at: 2026-07-11T16:15:25.534578127Z
  text: 'Development complete on feature/ise-025-state-read-api. PR #26: https://github.com/Steve-vine/ise/pull/26. Additive viewer-gated reads: GET /systems/{id}/state (latest snapshot per slice via DISTINCT ON — summaries+taken_at, no payload), GET /systems/{id}/state/{slice} (drill-in with payload), GET /findings (cross-system, filter by system_id/severity/status open|resolved|all). 119/119 tests incl. 6 new integration tests through the real sync engine; OpenAPI regenerated (3 new paths, api-types green). Fixed a shared-test-DB isolation issue with TRUNCATE at fixture setup. VERIFIED LIVE on staging against real data: g5 /state = config28/ns13/nodes1/workloads(20+3+2); datadog /state = dashboards77/metrics4051/monitors90(13 alerting); datadog /findings open = 13 (No-Data monitors). Side-note: g5 open findings now 0 — earlier Unhealthy/Alert findings auto-resolved as issues cleared (ISE-22 resolve path confirmed over time). ISE-31 follow-up filed for deferred DataDog service-map + event detect. Awaiting smoke test + merge clearance.'
- id: 01KX8ZSEXKA9CFSQRE393N6KE0
  author: Steve Vine
  at: 2026-07-11T16:22:25.45954158Z
  text: 'Smoke tests passed. PR #26 merged to main (2ddd17a), branch deleted. Belt-and-braces main run green. Done.'
assignee: steve
priority: medium
task_status: done
---
Versioned read endpoints (ADR 0009, additive) over StateSnapshot and Finding per system — state slices with per-slice sync times, native findings; viewer-gated. Feeds Overview cards and System detail. Regenerate frontend types (ISE-16 gate).