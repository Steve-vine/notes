---
id: 01KY2MSYN0HVX0F5PRY15AVPAH
created: 2026-07-21T15:30:42.46479Z
updated: 2026-07-21T17:44:28.611746Z
type: task
title: Tag Cloud page
project: 01KX671DATY39VW6GWK3M2T3DN
number: 181
sprint: sth83hw
blocked_by:
- 01KY2MSWERYNM2R9G943DRPNVB
assignee: steve
label: null
priority: medium
task_status: backlog
---
New "Tags" nav entry (after Estate) + `/tags` route. `GET /tags/cloud?window=24h|7d|30d&system_id=…` — alert_count = distinct alert findings active in window carrying the tag directly or via linked entity (UNION), top 200. TagCloudPage: integration MultiSelect, window SegmentedControl (default 7d), text filter (all persisted), 30s refetch. Heat: font size `13 + 15·sqrt(t)` px + `heatColor(t)` in `statusColors.ts` — discrete Mantine ladder gray→green→lime→yellow→orange→red, `t = log1p(count)/log1p(max)`. [Regenerate API types]

**Accept:** cloud defaults to 7d/all integrations; changing window or integration re-ranks; zero-alert tags render small/gray; filters persist across reload; top-200 cap enforced.