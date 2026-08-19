---
id: 01M0CKXX5JYC689TE4EPQAVCS2
created: 2026-08-19T08:59:11.410204Z
updated: 2026-08-19T08:59:14.919919Z
type: task
title: View Groups & View Users — "Showing x of y" indicator and page-size selector
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 274
sprint: s5gwx0s
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
On both directory inventory lists (COM-253 View Groups, COM-255 View Users), add a control at the **right-hand end of the filter row**:

* **"Showing x of y"** — x = entries visible on the current page under the active filters, y = the filtered total (not the unfiltered tenant total; when no filters are active they're the same number and it reads naturally either way). Updates live as filters/search change — it's the at-a-glance answer to "how much did that filter bite".
* **Page-size selector** beside it — **50 (default), 100, 200, 300, 400, 500**; changing it refetches at the new size and resets to page one (staying on page 7 of a differently-sized pagination is meaningless).
* Server side: the list endpoints (COM-252/254) take a `page_size` capped at 500 and must return the **filtered total count** alongside the page — if the response shape doesn't carry it yet, add it once for both endpoints rather than a separate count round-trip.
* Persist the chosen page size with the other persisted list preferences (COM-259's local-storage pattern); the indicator is derived state, nothing to persist.
* One shared component for both pages — same scaffolding rule as the sorting work (COM-272); land them together if both are open, they touch the same header row.

Refs: COM-252/254 (endpoints), COM-253/255 (screens), COM-272 (same filter/header row), ADR 0022.