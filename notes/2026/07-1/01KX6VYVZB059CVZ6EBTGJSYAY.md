---
id: 01KX6VYVZB059CVZ6EBTGJSYAY
created: 2026-07-10T20:36:59.499056077Z
updated: 2026-07-19T13:25:10.54817824Z
type: task
title: /api/v1 CRUD for domain model v1
project: 01KX671DATY39VW6GWK3M2T3DN
number: 15
sprint: sqtx330
blocked_by:
- 01KX6VXSDBE12B66M73JW8YX5Y
- 01KX6VYAJEN6473MY7YV0N8NNR
comments:
- id: 01KX852SNYE31X4AC4W1ZFTMCX
  author: Steve Vine
  at: 2026-07-11T08:35:39.837986634Z
  text: 'Development complete on feature/ise-015-crud-api. PR #17: https://github.com/Steve-vine/ise/pull/17. /systems (viewer reads, admin writes), /issues (viewer reads, operator create + lifecycle with enforced state machine), /audit (filterable viewer reads). All writes audited same-transaction; RBAC via typed role aliases. Live verification caught a real bug the suite missed — UUID in audit details crashed JSONB serialization; fixed in routers (mode=json) AND hardened audit.record (default=str) + regression test. 63/63 tests incl. role matrix and contract checks; live compose flow verified; staging deployed green, /api/v1/systems 401 anonymous (boundary holds). Note: openapi.json is intentionally not on the public URL (nginx proxies /api/* only) — ISE-16 generates types from the backend directly. Awaiting smoke test and merge clearance.'
- id: 01KX85B8TVVTJGW0HY4ZQC9EJR
  author: Steve Vine
  at: 2026-07-11T08:40:17.499841288Z
  text: 'Smoke tests passed. PR #17 merged to main (a052e12), branch deleted. Belt-and-braces main run green. Done.'
assignee: steve
label: null
priority: medium
task_status: done
---
Versioned REST endpoints where meaningful over the v1 entities (ADR 0009 — additive-only contract), auth-enforced, with API-contract tests (ADR 0016 priority 5).