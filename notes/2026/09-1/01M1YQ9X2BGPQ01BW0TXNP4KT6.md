---
id: 01M1YQ9X2BGPQ01BW0TXNP4KT6
created: 2026-09-07T20:00:11.851488Z
updated: 2026-09-07T20:01:34.207275Z
type: task
title: 'Sorting the long lists: order_by on the paged endpoints'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 609
sprint: sa2t9sq
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Three lists in Compass are long enough to page on the server: **Activity**, **Admin → Files**, and **Access Control → Report library**. On those, sorting the rows the browser happens to be holding would be a lie — you would reorder page 1 and page 2 would carry on where the old order left off. The server has to do it.

## What a reader sees

Nothing different from anywhere else. Click a heading, the whole list reorders, and you are looking at the first page of the new order.

## Work

Give the three list endpoints the `order_by` + `direction` query parameters that `directory.py` already has, using the helpers already written there — `_order_column` (a whitelist map of sortable column name → SQLAlchemy column, raising a 422 for anything not in it) and `_directed`. Do not invent a second shape.

- `api/v1/activity.py` — the activity log list
- `api/v1/admin_files.py` — the stored-files list
- `api/v1/report_definitions.py` — the report library

Each keeps its current ordering as the default so nothing changes for a caller that does not ask. Reset to the first page whenever the order changes.

The front-end halves of these three lists are picked up by *Admin lists sort* and *Access Control lists sort*, which consume the parameters this task adds and reuse the server-side `SortState` path already in `components/sort.ts`.

Tests: one integration test per endpoint covering ascending, descending, and an unknown `order_by` returning 422.
