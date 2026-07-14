---
id: 01KXGWK63YWC5PS26HE7SN1DX9
created: 2026-07-14T18:00:29.566458898Z
updated: 2026-07-14T18:33:41.102238044Z
type: task
title: 'Managed content PDF export: Graph ?format=pdf + review-record injection'
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 132
sprint: ssdk92z
label: null
blocked_by:
- 01KXGWJN5DFYQJSY7MFFJPHANF
---
Second half of ADR 0034's build (M23): downloadable PDF for `managed` content, rendered by Microsoft and stamped with the Compass review record.

**Backend**

* Productionise the spike flow: Graph `GET /drives/{drive}/items/{item}/content?format=pdf` (follow the 302) → render a **review-record page** from the item's real review records (ReportLab, house style to match the existing reports; paginates properly) → merge with `pypdf` → stream.
* Runs on the **worker** like templated PDF generation (Graph fetch can be slow), cached in storage under `generated/`, invalidated when the SharePoint `eTag`/`lastModifiedDateTime` or the review records change.
* Graceful degradation: Graph unreachable → 503 with a clear message (serve the cached copy if present); unsupported source format (400/415 from Graph) → surfaced as "no PDF available for this document type".
* New dependency: `pypdf`.

**Frontend**

* **Download PDF** action on managed items (same UX as templated content's PDF), with a pending state while the worker generates.

**Follow-up potential (not this issue):** apply the same review-record merge to templated and uploaded PDFs so every kind's PDF carries provenance.

Blocked by <issue id="fac324af-ba03-46f0-97c5-e57d895b5077" href="https://linear.app/stevevine/issue/DEV-758/managed-content-m365sharepoint-kind-resolve-link-open-in-m365">DEV-758</issue>.

---
*Migrated from Linear [DEV-759](https://linear.app/stevevine/issue/DEV-759/managed-content-pdf-export-graph-formatpdf-review-record-injection) · created 2026-07-02 · completed 2026-07-02*  
*Related to (Linear): DEV-782*