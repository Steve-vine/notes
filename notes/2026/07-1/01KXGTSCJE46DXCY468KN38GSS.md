---
id: 01KXGTSCJE46DXCY468KN38GSS
created: 2026-07-14T17:28:55.630833924Z
updated: 2026-07-14T17:28:55.630833924Z
type: task
title: M21 · Brief 2 frontend — Templates tab (upload, rename, delete, placeholders)
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 97
---
Frontend for **ADR 0030 §3** (M21 — Content). Pairs with <issue id="7d0a691e-6700-473d-9553-542b241f353a" href="https://linear.app/stevevine/issue/DEV-679/m21-brief-2-backend-word-template-upload-crud-and-placeholder">DEV-679</issue>.

## Scope

* **Templates** tab on the Content page: list uploaded Word templates.
* **Upload** a `.docx` (multipart); **rename**; **delete** (surface 409 "in use" guard → remap/disable first).
* Show each template's **detected** `[placeholder]` **tokens** so authors know what sections the template expects.
* Gated to library-write roles (analyst/admin) — hide/disable controls for viewers (ADR 0026).

## Depends on

<issue id="7d0a691e-6700-473d-9553-542b241f353a" href="https://linear.app/stevevine/issue/DEV-679/m21-brief-2-backend-word-template-upload-crud-and-placeholder">DEV-679</issue> (templates upload/CRUD API + placeholder extraction).

Refs: ADR 0030 §3, 0026.

---
*Migrated from Linear [DEV-682](https://linear.app/stevevine/issue/DEV-682/m21-brief-2-frontend-templates-tab-upload-rename-delete-placeholders) · created 2026-06-27 · completed 2026-06-28*