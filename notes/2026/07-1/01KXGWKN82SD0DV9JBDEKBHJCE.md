---
id: 01KXGWKN82SD0DV9JBDEKBHJCE
created: 2026-07-14T18:00:45.058811427Z
updated: 2026-07-14T18:33:41.984105138Z
type: task
title: 'Content library follow-ups: review record on all PDFs, release tracking'
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 133
sprint: ssdk92z
label: null
blocked_by:
- 01KXGWK63YWC5PS26HE7SN1DX9
---
Stretch items once the four kinds are live (M23) — split into separate issues when picked up:

* **Review record on every PDF**: apply the <issue id="40deb6d1-2fb9-4680-9e11-1612dfe3e8a1" href="https://linear.app/stevevine/issue/DEV-759/managed-content-pdf-export-graph-formatpdf-review-record-injection">DEV-759</issue> review-record merge to `templated` and `uploaded` (Office/PDF) downloads too, so every PDF leaving Compass carries its provenance page regardless of kind.
* **Release tracking for managed content**: read SharePoint version history via Graph (`GET /drives/{d}/items/{i}/versions`) and surface it on the History tab, aligning M365 releases with Compass review records.
* **Retire or demote Markdown authoring?** Once uploaded/managed cover real usage, decide whether `templated` remains first-class (would supersede parts of ADR 0030 — needs its own ADR).

Blocked by <issue id="40deb6d1-2fb9-4680-9e11-1612dfe3e8a1" href="https://linear.app/stevevine/issue/DEV-759/managed-content-pdf-export-graph-formatpdf-review-record-injection">DEV-759</issue>.

---
*Migrated from Linear [DEV-760](https://linear.app/stevevine/issue/DEV-760/content-library-follow-ups-review-record-on-all-pdfs-release-tracking) · created 2026-07-02 · completed 2026-07-03*  
*Related to (Linear): DEV-784, DEV-783, DEV-782*