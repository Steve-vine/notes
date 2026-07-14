---
id: 01KXGWHZ2QVEGCPY4YER08Z3DV
created: 2026-07-14T17:59:49.591661565Z
updated: 2026-07-14T18:05:45.076685599Z
type: task
title: 'Uploaded content: file upload/download kind'
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 130
sprint: ssdk92z
label: null
---
The `uploaded` kind (M23) — any standard document (Word, Excel, PDF, …) uploaded and stored on the platform via the existing storage abstraction (local/EFS in k3s, S3-ready).

**Model / API**

* Nullable file columns on content: `storage_key`, `original_filename`, `content_type`, `size` — same shape as `content_templates` (bytes in storage, never Postgres, per ADR 0013).
* Upload endpoint (multipart) sets/replaces the file on an `uploaded` item; replacing bumps `current_version` so review history stays meaningful. Download endpoint streams with the original filename/content type.
* Allow-list of content types (Office formats, PDF, plain text/CSV, images) + a sane size limit.

**Frontend**

* Create: choosing kind Uploaded gives a Mantine Dropzone/FileInput.
* Detail: filename + size shown; **Download** action; **Replace file** for editors. PDFs render inline where trivial (iframe/object), others download.
* Governance panel identical to other kinds.

**PDF**

* PDF files download as-is. Office files: render via LibreOffice in the worker (same seam as templated content) so the review-record injection issue can later apply uniformly. Non-convertible types simply have no PDF action.

Blocked by <issue id="b485e441-4fea-4751-a073-e770fe3ab46d" href="https://linear.app/stevevine/issue/DEV-755/content-kinds-foundation-sourcekind-migration-kind-column-domain">DEV-755</issue>.

---
*Migrated from Linear [DEV-757](https://linear.app/stevevine/issue/DEV-757/uploaded-content-file-uploaddownload-kind) · created 2026-07-02 · completed 2026-07-02*