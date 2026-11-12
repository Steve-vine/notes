---
id: 01M78AQ6NBASQ38TTMHKP7XF6J
created: 2026-11-12T16:51:09.611194Z
updated: 2026-11-12T16:51:12.278006Z
type: task
title: Deleting an asset from its page leaves no errors in the browser
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1766
sprint: spsp226
assignee: steve
label:
- bug
priority: medium
task_status: active
---
Found in the sprint 116 round-3 pre-UAT pass on staging (3175d2ad, 2026-11-12); caused by COM-1758. Fix forward.

**What happens:** deleting a technology, data or software asset from its page (plain Delete, or "Move N links and delete") works and returns to Inventory, but the page then asks again for the deleted asset — the asset itself, its access holders, its risks and the new "what stops the delete" read — and each gets a 404 in the console. Seen 5 times, e.g. `GET /api/v1/containers/<id>/deletion`, `/holders`, `/risks`, `/containers/<id>`; the same for `/data-assets/<id>` and `/software-assets/<id>`.

**What it should do:** deleting from the page leaves no failed requests and nothing in the console (the deleted asset's queries are removed, not refreshed — the same pattern as COM-1760).

**Done when:** deleting a technology, a data and a software asset, including as a duplicate, logs no console errors and lands on Inventory as today; a test fails without the fix. Frontend only, independent.