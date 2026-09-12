---
id: 01M2A6PXPFY2D9WAC0E900ZT38
created: 2026-09-12T07:01:05.871266Z
updated: 2026-09-12T07:17:27.979445Z
type: task
title: Technology assets tab — the Environment filter defaults to Production; the scope line goes
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 680
sprint: skdc1az
comments:
- id: 01M2A7MVZ5VPGHJJPCWE4RZ5KV
  author: Steve Vine
  at: 2026-09-12T07:17:27.141423Z
  text: |-
    Done — PR #688 merged to main (0ac963f).

    The "Production unless an entry says otherwise." line is gone from the Technology Assets tab. The Environment filter now opens on Production; clearing it shows every asset, Non-Production shows the rest, and a link that names an environment (?environment=non_production) still wins. When Production is selected and nothing matches, the empty state reads "No production technology assets. Clear the Environment filter to see non-production ones." ADR 0072 §2 amended in one line.

    Tests cover the default, clearing, the empty state and the query-string link. Awaiting staging deploy with the rest of the sprint.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Smoke finding, 2026-09-12 (Steve): the "Production unless an entry says otherwise." line beside the filters on Inventory ▸ Technology Assets is prose the screen should not need (*A screen does not explain itself*). The scope is expressed by the filter instead.

* Remove the `Text` after the Environment filter in `InventoryPage.tsx` (the technology tab head).
* The **Environment filter defaults to Production** rather than "All": initial state `searchParams.get('environment') ?? 'production'`. Clearing the filter shows everything; choosing Non-Production shows the rest. A dashboard-tile link that passes `environment` explicitly still wins.
* The empty state when Production is selected and nothing matches says what the filter is doing: "No production technology assets. Clear the Environment filter to see non-production ones." (the one line that is the entire body of an empty state).
* ADR 0072 §2's "the register page states its scope" becomes "the register's default filter is Production" — one-line amendment.
* Tests: the tab renders with Production selected by default; a non-production asset is hidden until the filter is cleared; a `?environment=non_production` link opens filtered to that.

**Acceptance**: no scope sentence on the tab; opening the tab shows production assets with the Environment filter reading Production; clearing it shows all.