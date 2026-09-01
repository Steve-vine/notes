---
id: 01M0FHD0480ZEYDXYD46ZCHS7Y
created: 2026-08-20T12:12:43.528898Z
updated: 2026-09-01T13:55:50.573197Z
type: task
title: Raise Graph page size to 999 in the directory sync
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 314
sprint: s5yxs5a
comments:
- id: 01M0FRVAQHVEW5PDHESHHQSEB3
  author: Steve Vine
  at: 2026-08-20T14:22:53.168829Z
  text: |-
    Implemented in PR #308 (feature/com-314-page-size, stacked on #307) — CI green.

    graph_get_all's default $top goes 100 → 999 (~10x fewer round-trips on /users, /groups, members, owners). roleManagement/directory/roleAssignments pinned to the known-good 100 — its sibling roleDefinitions 400s on $top (COM-273) — and the page_size=None escape hatch is untouched. The FakeTenant now asserts every $top it sees.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
`graph_get_all` asks for `$top=100`; the directory endpoints (`/users`, `/groups`, `/groups/{id}/members`, `/owners`) accept `$top=999` with `ConsistencyLevel: eventual` (already sent). ~10x fewer round-trips on the paged collections for a one-line change; keep the `page_size=None` escape hatch for the endpoints that reject `$top` (COM-273).