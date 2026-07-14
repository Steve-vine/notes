---
id: 01KXGWV93JA93KR9HV7A119WKG
created: 2026-07-14T18:04:54.770675601Z
updated: 2026-07-14T18:05:44.615632902Z
type: task
title: Review record on every PDF export (templated + uploaded)
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 136
sprint: ssdk92z
label: null
---
Split from <issue id="6775eddc-ed1e-46f6-8320-100b0cca996c" href="https://linear.app/stevevine/issue/DEV-760/content-library-follow-ups-review-record-on-all-pdfs-release-tracking">DEV-760</issue>. Every PDF leaving Compass carries its provenance page (the <issue id="40deb6d1-2fb9-4680-9e11-1612dfe3e8a1" href="https://linear.app/stevevine/issue/DEV-759/managed-content-pdf-export-graph-formatpdf-review-record-injection">DEV-759</issue> review record), regardless of kind.

**Templated**

* `generate_content_pdf` appends the review-record page after the LibreOffice render (current and versioned exports; the version PDF carries the review history *as of export*). Cache keys gain the reviews digest so a new review invalidates.
* Bulk zips inherit automatically (per-item keys feed the zip key).

**Uploaded**

* The raw **Download** stays byte-identical to what was uploaded (it's the original document — never modified).
* New worker task `generate_uploaded_pdf`: PDF files → append the record; Office files (docx/xlsx/pptx) → LibreOffice render then append; other types 409 "no PDF for this type". Cached keyed by file + reviews digest.
* `/content-pdf` routes uploaded single slugs to it; detail page gains **Download PDF** beside Download.

Tests across task/endpoint/frontend as per the <issue id="40deb6d1-2fb9-4680-9e11-1612dfe3e8a1" href="https://linear.app/stevevine/issue/DEV-759/managed-content-pdf-export-graph-formatpdf-review-record-injection">DEV-759</issue> patterns.

---
*Migrated from Linear [DEV-782](https://linear.app/stevevine/issue/DEV-782/review-record-on-every-pdf-export-templated-uploaded) · created 2026-07-02 · completed 2026-07-03*  
*Related to (Linear): DEV-760, DEV-759*