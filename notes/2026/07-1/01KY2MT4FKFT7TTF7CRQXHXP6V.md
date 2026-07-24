---
id: 01KY2MT4FKFT7TTF7CRQXHXP6V
created: 2026-07-21T15:30:48.435631Z
updated: 2026-07-24T12:49:43.132773Z
type: task
title: Tags on signals click through + hardening
project: 01KX671DATY39VW6GWK3M2T3DN
number: 186
order: 1.59375
sprint: sth83hw
blocked_by:
- 01KY2MT0R9685DXTCQ53NABPN1
assignee: steve
priority: medium
task_status: done
---
SignalsPage tag badges become `TagBadge`s linking to the tag drilldown when the tag exists in the pool. Hardening: tests for per-entity/per-finding caps and the deny-list; explain-checked index pass on the cloud aggregation + seeded perf test (~10k findings × 50 tags).

**Accept:** clicking a tag on an alert lands on its drilldown; cloud endpoint stays <300ms on the seeded dataset.