---
id: 01KXGWVTFXYD88JSFWJRT31B8J
created: 2026-07-14T18:05:12.573307921Z
updated: 2026-07-14T18:05:20.720702156Z
type: task
title: 'Managed content release tracking: SharePoint version history on the History tab'
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 137
sprint: ssdk92z
---
Split from <issue id="6775eddc-ed1e-46f6-8320-100b0cca996c" href="https://linear.app/stevevine/issue/DEV-760/content-library-follow-ups-review-record-on-all-pdfs-release-tracking">DEV-760</issue>. Managed items' History tab shows the document's **SharePoint version history** (Graph `GET /drives/{d}/items/{i}/versions`) so M365 releases sit alongside Compass review records.

* `core/graph.py`: `list_item_versions` → version id, modified date, modified-by display name, size (app-only token; Graph errors mapped as usual).
* API: `GET /content/{slug}/m365-versions` (managed-only 409 otherwise; library-read). Live call, no persistence.
* Frontend: History tab for managed items renders the SharePoint versions table (and hides the templated versions/revert machinery, which is meaningless for managed).
* Graceful degradation: Graph down → the tab shows the error message, not a crash.

---
*Migrated from Linear [DEV-783](https://linear.app/stevevine/issue/DEV-783/managed-content-release-tracking-sharepoint-version-history-on-the) · created 2026-07-02 · completed 2026-07-03*  
*Related to (Linear): DEV-760*