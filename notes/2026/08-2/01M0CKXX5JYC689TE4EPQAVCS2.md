---
id: 01M0CKXX5JYC689TE4EPQAVCS2
created: 2026-08-19T08:59:11.410204Z
updated: 2026-08-19T16:23:40.614817Z
type: task
title: View Groups & View Users — "Showing x of y" indicator and page-size selector
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 274
sprint: s5gwx0s
comments:
- id: 01M0DDBSA6J35K780RXF0ZYTB7
  author: Steve Vine
  at: 2026-08-19T16:23:40.614684Z
  text: |-
    Merged to main in PR #275. Both inventory lists gained, at the right-hand end of the filter row:

    - "Showing x of y" — x = rows on the current page, y = the filtered total, live as filters/search change.
    - Page-size selector: 50 (default), 100, 200, 300, 400, 500 — changing it refetches and resets to page one. Persists per page via localStorage (compass-groups-page-size / compass-users-page-size), read synchronously so the first fetch already uses it.
    - One shared PageSizeControl component for both pages; server-side the two list endpoints raised their limit cap 200 → 500 (they already returned the filtered total, so no response-shape change).
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
On both directory inventory lists (COM-253 View Groups, COM-255 View Users), add a control at the **right-hand end of the filter row**:

* **"Showing x of y"** — x = entries visible on the current page under the active filters, y = the filtered total (not the unfiltered tenant total; when no filters are active they're the same number and it reads naturally either way). Updates live as filters/search change — it's the at-a-glance answer to "how much did that filter bite".
* **Page-size selector** beside it — **50 (default), 100, 200, 300, 400, 500**; changing it refetches at the new size and resets to page one (staying on page 7 of a differently-sized pagination is meaningless).
* Server side: the list endpoints (COM-252/254) take a `page_size` capped at 500 and must return the **filtered total count** alongside the page — if the response shape doesn't carry it yet, add it once for both endpoints rather than a separate count round-trip.
* Persist the chosen page size with the other persisted list preferences (COM-259's local-storage pattern); the indicator is derived state, nothing to persist.
* One shared component for both pages — same scaffolding rule as the sorting work (COM-272); land them together if both are open, they touch the same header row.

Refs: COM-252/254 (endpoints), COM-253/255 (screens), COM-272 (same filter/header row), ADR 0022.