---
id: 01KXGTQXAP904KYR5S7T62623Z
created: 2026-07-14T17:28:07.254421526Z
updated: 2026-07-19T21:30:28.339700078Z
type: task
title: M21 · Brief 3 backend — merge & render pipeline (LibreOffice on worker, async)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 95
sprint: s28w1cp
blocked_by:
- 01KXGTPDCJFB4PS00P0PDE4W7E
- 01KXGTQ3AG0RVKX663S9WZ2G4M
assignee: steve
task_status: done
priority: medium
---
Backend for **ADR 0030 §4, §5, §6** (M21 — Content). Third backend→frontend pair. **Depends on brief 1 (sections, type→template mapping) and brief 2 (templates).**

## Scope

Compose a content item's sections into its mapped Word template and render to PDF.

### Merge (ADR 0030 §4) — pure-Python, cheap

* **Placeholder name is the join key**: for each `[token]` in the template, insert the rendered body of the section whose `placeholder == token`.
* Template placeholders with no matching section render **empty**; sections with no matching placeholder are **omitted** from the PDF.
* Section bodies are Markdown → convert to docx content (headings, lists, bold/italic, basic tables — **modest fidelity, documented**) and substitute at the placeholder location with `python-docx`.

### Render (ADR 0030 §6) — heavy, worker-only, async

* `.docx` → PDF via **LibreOffice headless** (`soffice --headless --convert-to pdf`), installed **only in the worker image** (apt; no Java/GUI). API image unchanged.
* Runs as a **Celery task** (ADR 0006). Each invoke uses a unique `-env:UserInstallation` temp profile (LibreOffice serialises on its profile); consider a dedicated low-concurrency queue.

### Cache + endpoints (ADR 0030 §5)

* Generated PDFs **cached in object storage**, keyed by `(content_item_id, content version, template id/version)`; re-render only when content `current_version` or the mapped template changes.
* **Single**: enqueue (skip on cache hit) → job-status poll → download endpoint serves the cached PDF (frontend opens in a new tab).
* **Bulk**: one task renders each selected item (reusing cache) and bundles a **zip**.
* Generate/download endpoints are `require_library_read` (any authenticated user).

## Deploy

* Worker Dockerfile gains LibreOffice; API/backend Dockerfile unchanged. No new deployed service (ADR 0006/0008).

## Out of scope

Generate-PDF UI + bulk multi-select (brief 3 frontend).

Refs: ADR 0030 §4/§5/§6, 0006, 0008, 0013.

---
*Migrated from Linear [DEV-680](https://linear.app/stevevine/issue/DEV-680/m21-brief-3-backend-merge-and-render-pipeline-libreoffice-on-worker) · created 2026-06-27 · completed 2026-06-28*