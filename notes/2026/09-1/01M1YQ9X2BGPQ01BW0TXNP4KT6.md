---
id: 01M1YQ9X2BGPQ01BW0TXNP4KT6
created: 2026-09-07T20:00:11.851488Z
updated: 2026-09-08T20:08:50.774204Z
type: task
title: 'Sorting the long lists: order_by on the paged endpoints'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 609
sprint: sa2t9sq
comments:
- id: 01M1YYVNXY1KV4YFVTRA48M6W6
  author: Steve Vine
  at: 2026-09-07T22:12:14.398559Z
  text: |-
    Done — PR #619 merged to main.

    What landed:
    - api/v1/ordering.py: order_column (whitelist → 422 for anything else), directed, DIRECTION_PATTERN — moved out of directory.py so there is one shape; directory.py imports them, no behaviour change.
    - activity.py: order_by = created_at (default, desc) | action | entity_type | actor (snapshot name, joined name as fallback, case-insensitive).
    - admin_files.py: uploaded_at (default, desc) | filename | owner_type | company (joined name) | size.
    - report_definitions.py: name (default, asc, case-insensitive) | subject | updated_at. The shipped set still sorts ahead whatever the column — the page splits on it anyway.
    - Id tie-breaks so equal values do not jitter across pages. schema.d.ts regenerated.

    One finding: the report library endpoint does not actually page (no limit/offset), so client-side sorting would also have been honest there. The parameters are added as specified so COM-613 can use the server-side SortState path like the directory tabs.

    Tests: one integration test per endpoint — asc, desc, unknown order_by → 422, bad direction → 422; Files also proves sort + paging compose.

    Front-end halves: COM-613 (report library), COM-615 (Files, Activity).
assignee: steve
label:
- feature
priority: high
task_status: done
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
