---
id: 01M0FHD3HY8R5BMC4S4A6K8BH6
created: 2026-08-20T12:12:47.038918Z
updated: 2026-08-20T13:34:00.332878Z
type: task
title: Use Graph $batch for the per-group members/owners crawl
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 315
sprint: s5yxs5a
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
The members + owners loop is two sequential GETs per group at ~150ms each — the bulk of the ~27-minute pass. Graph's JSON `$batch` endpoint packs 20 requests per round-trip: batch the first page of members/owners for 10 groups at a time (paging the rare group with >999 members individually). Cuts the crawl to roughly a twentieth and shrinks the transient-failure window with it.