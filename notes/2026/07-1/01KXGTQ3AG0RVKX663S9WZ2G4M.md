---
id: 01KXGTQ3AG0RVKX663S9WZ2G4M
created: 2026-07-14T17:27:40.624823482Z
updated: 2026-07-14T17:27:40.624823482Z
type: task
title: M21 · Brief 2 backend — Word template upload, CRUD & placeholder extraction
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 94
---
Backend for **ADR 0030 §3** (M21 — Content). Second backend→frontend pair. Largely independent of brief 1.

## Scope

Uploaded Word `.docx` templates as governed library data; bytes in object storage, metadata + detected placeholders in Postgres.

* New `content_templates` table (metadata only): `name`, `slug`, `original_filename`, `storage_key`, `placeholders` (JSON list of detected `[token]`s), uploaded-actor, timestamps. Audited, soft-deletable.
* **Bytes in object storage** under `storage_key` via the `Storage` protocol (local on k3s, S3 in prod) — never in Postgres (ADR 0013).
* **Upload** (multipart `.docx`): validate it is a real docx; **extract** `[placeholder]` **tokens** with `python-docx` into `placeholders` so the UI can show what the template expects.
* **Rename** (edit `name`); **guarded delete** (409 if any content type still maps to it — disable/remap first).
* All management gated `require_library_write` (analyst/admin, ADR 0026).
* Add `content_templates` to the audit allowlist (ADR 0023).
* If brief 1 deferred the `content_types.template_id` FK, add it here.

## Notes

* `python-docx` is the new dep here (pure-Python, light; fine in both images). The heavy LibreOffice render is brief 3, not here.
* Placeholder extraction scans paragraph + table runs for `[...]` tokens; store the bare names.

## Out of scope

Merge/render (brief 3), Templates UI (brief 2 frontend), content types/sections (brief 1).

Refs: ADR 0030 §3, 0013, 0026, 0023, 0008.

---
*Migrated from Linear [DEV-679](https://linear.app/stevevine/issue/DEV-679/m21-brief-2-backend-word-template-upload-crud-and-placeholder) · created 2026-06-27 · completed 2026-06-28*