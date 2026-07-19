---
id: 01KXGTSZWM212JSVSRJ6SAVZRM
created: 2026-07-14T17:29:15.412542907Z
updated: 2026-07-19T21:30:28.174550697Z
type: task
title: M21 · Brief 3 frontend — Generate PDF (single, new tab) & bulk multi-select
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 98
sprint: s28w1cp
blocked_by:
- 01KXGTQXAP904KYR5S7T62623Z
assignee: steve
task_status: done
priority: medium
---
Frontend for **ADR 0030 §4–§6** (M21 — Content). Pairs with <issue id="5abf4527-efe2-4fb0-bee1-b6e357fe7e45" href="https://linear.app/stevevine/issue/DEV-680/m21-brief-3-backend-merge-and-render-pipeline-libreoffice-on-worker">DEV-680</issue>.

## Scope

### Single (read mode)

* **Generate PDF** action on a content item in read mode: enqueue, show progress while the Celery task runs, then **open the resulting PDF in a new tab** (print/download from there).
* Disabled/with a hint when the content's type has no mapped template.

### Bulk (content list)

* Per-row **tickboxes** on the main content list; select multiple → **Generate PDFs** → receives a **zip** download.
* Select-all / clear; show count selected.

## Depends on

<issue id="5abf4527-efe2-4fb0-bee1-b6e357fe7e45" href="https://linear.app/stevevine/issue/DEV-680/m21-brief-3-backend-merge-and-render-pipeline-libreoffice-on-worker">DEV-680</issue> (merge/render endpoints, job status, single + bulk + download).

Refs: ADR 0030 §4/§5/§6.

---
*Migrated from Linear [DEV-683](https://linear.app/stevevine/issue/DEV-683/m21-brief-3-frontend-generate-pdf-single-new-tab-and-bulk-multi-select) · created 2026-06-27 · completed 2026-06-28*