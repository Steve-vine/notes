---
id: 01M0CYFKA2603HVQCECTZAF8EH
created: 2026-08-19T12:03:36.898322Z
updated: 2026-08-19T12:03:36.898322Z
type: task
title: Two-pane picker — Map/remove actions pushed off-screen by the ScrollArea table wrapper
assignee: steve
label: bug
priority: high
task_status: active
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 278
---
Smoke finding, Sprint 34 (2026-08-19). On the role detail two-pane picker (COM-258), group rows render but the Map button (and the mapped pane's remove icon) is nowhere to be seen — "the map button has disappeared".

Cause: Mantine's `ScrollArea` (Radix underneath) renders its viewport content in a `display: table; min-width: 100%` wrapper that sizes to **content**, not to the pane. Inside it, `truncate` has no width constraint to truncate against, so a row with a long real-tenant group description stretches to its natural width and the whole list adopts the widest row — the trailing action lands beyond the pane's clipped right edge. Everything looked fine in development and CI because the fixtures had short names and jsdom performs no layout: the COM-258 "the button never shrinks" work solved flex-shrink, then the ScrollArea wrapper reintroduced the same disease one layer up.

Fix: replace both `ScrollArea.Autosize` wrappers in `RoleDetailPage` (candidates pane + mapped pane) with a plain scrolling `Box` (`mah` + `overflow-y: auto`) — a normal block context constrains row width to the pane, truncation works, actions stay visible. No other Access screens use ScrollArea (checked); the sidebar's ScrollArea (COM-268) scrolls a narrow nav and is unaffected.

Verified server-side before diagnosis: the mappable feed is healthy (814 assigned security groups, 200 OK responses, only 6 legitimately role-assignable in the first page) and permissions intact — this is purely a rendering defect.

Refs: COM-258 (the pane), COM-268 (unrelated nav ScrollArea), `access/RoleDetailPage.tsx`.