---
id: 01M0CKVG4RVKNS7HA604C3M8FT
created: 2026-08-19T08:57:52.536851Z
updated: 2026-08-19T08:58:03.025887Z
type: task
title: Graph 400s on $top — roleDefinitions/subscribedSkus refuse paging, masked as "grant missing"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 273
sprint: s5gwx0s
assignee: steve
label:
- bug
priority: high
task_status: active
---
Smoke finding, Sprint 34 (2026-08-19), found live after the COM-252 deploy. With `RoleManagement.Read.Directory` granted and fresh tokens (worker restart), the mirror sync still reported roles unknown. Worker log tells the story plainly:

```
GET /roleManagement/directory/roleAssignments?$top=100 → 200
GET /roleManagement/directory/roleDefinitions?$top=100&$select=id,displayName → 400 Bad Request
WARNING Directory-role resolution unavailable — roles will show as unknown
```

`graph_get_all` unconditionally sends `$top=page_size`, but several Graph collections **reject `$top`**: `roleManagement/directory/roleDefinitions` (hit live), `subscribedSkus` (documented non-pageable — the COM-254 licenses panel will hit it), and the PIM schedule-instance endpoints are unverified. Two compounding failures:

* **The fakes were friendlier than Graph.** The MockTransport tenants accept `$top` everywhere, so CI green ≠ Graph-compatible. The fix must encode the refusal in the fakes (roleDefinitions/subscribedSkus return 400 when `$top` is present) so a regression can't pass.
* **The degrade path lies about the cause.** A 400 surfaces as "roles unknown — grant missing", sending the operator to re-check a consent that was fine (exactly what happened). The visible-degradation principle held — nothing was silent — but the *diagnosis* text overcommitted.

Fix:

* `graph_get_all` accepts `page_size=None` → omit `$top` entirely (still follow `@odata.nextLink` if the server pages by itself).
* Call with `page_size=None` for: `roleDefinitions` (sync `_fetch_directory_roles` + directory.py `_role_definition_names`), `subscribedSkus`, and both PIM schedule-instance endpoints (defensive — unverifiable without P2 traffic).
* Soften the unknown-roles wording in the group badge/modal (and the model comment): "roles could not be resolved — check the RoleManagement.Read.Directory grant", since the cause may not be the grant.
* Fakes reject `$top` on the non-pageable endpoints; unit-test `graph_get_all(page_size=None)` omits `$top`.

Refs: COM-252 (sync role resolution), COM-254 (user detail panels), `core/graph.py` (`graph_get_all`).