---
id: 01M0FHD0480ZEYDXYD46ZCHS7Y
created: 2026-08-20T12:12:43.528898Z
updated: 2026-08-20T13:24:36.059001Z
type: task
title: Raise Graph page size to 999 in the directory sync
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 314
sprint: s5yxs5a
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
`graph_get_all` asks for `$top=100`; the directory endpoints (`/users`, `/groups`, `/groups/{id}/members`, `/owners`) accept `$top=999` with `ConsistencyLevel: eventual` (already sent). ~10x fewer round-trips on the paged collections for a one-line change; keep the `page_size=None` escape hatch for the endpoints that reject `$top` (COM-273).