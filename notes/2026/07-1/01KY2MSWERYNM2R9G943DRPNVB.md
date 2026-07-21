---
id: 01KY2MSWERYNM2R9G943DRPNVB
created: 2026-07-21T15:30:40.216483Z
updated: 2026-07-21T16:54:24.841706Z
type: task
title: Datadog tags join the pool
project: 01KX671DATY39VW6GWK3M2T3DN
number: 180
sprint: sth83hw
blocked_by:
- 01KY2MSN1Q3W82KAAF3G52913D
assignee: steve
priority: medium
task_status: backlog
---
Datadog feeds the tag pool: host tags via `tags_by_source` on the already-fetched `list_hosts()` result (verify field on pinned client); service-definition tags in `_catalogue_services`; `FindingData.tags` from monitor tags + parsed scope tags (so a monitor scoped `env:prod` heats that tag); `reconcile_finding_tags` wired into sync.

**Accept:** a host tagged in Datadog shows those tags on entity detail; a monitor's tags land in `finding_tag`; `env:prod` shared across both integrations is one tag row with two provenance badges.