---
id: 01KXGTRJXVJVDB5MH9J6TM6663
created: 2026-07-14T17:28:29.371607471Z
updated: 2026-07-14T17:29:36.88993249Z
type: task
title: M21 · Brief 1 frontend — tabbed Content page, sectioned editor & Mappings tab
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 96
sprint: s28w1cp
label: null
---
Frontend for **ADR 0030 §1, §2** (M21 — Content). Pairs with <issue id="d676c8d4-3445-4790-ba59-103627130778" href="https://linear.app/stevevine/issue/DEV-678/m21-brief-1-backend-sectioned-content-editable-content-types-and">DEV-678</issue>.

## Scope

### Tabbed Content page

* Rename the current content view to a **Content** tab; add **Mappings** and **Templates** tabs (Templates tab content is brief 2 frontend — add the tab shell here or there, coordinate).

### Sectioned authoring editor (ADR 0030 §1)

* In edit mode, content is authored as ordered **named sections** — each with a placeholder name (e.g. `main-policy`) + Markdown body.
* Add / reorder / **individually delete** sections; sections stack top-to-bottom.
* In read mode, sections render stacked.
* Suggest placeholder names from the mapped template's detected placeholders where available.

### Mappings tab (ADR 0030 §2)

* **Content-type management**: create / edit / disable / delete content types (guarded-delete surfaced as 409 → "in use" message).
* **Map** each content type to a template (the `template_id` FK) via a select of available templates.

## Depends on

<issue id="d676c8d4-3445-4790-ba59-103627130778" href="https://linear.app/stevevine/issue/DEV-678/m21-brief-1-backend-sectioned-content-editable-content-types-and">DEV-678</issue> (sections API, content-types CRUD, mappings endpoint).

Refs: ADR 0030 §1/§2, 0026.

---
*Migrated from Linear [DEV-681](https://linear.app/stevevine/issue/DEV-681/m21-brief-1-frontend-tabbed-content-page-sectioned-editor-and-mappings) · created 2026-06-27 · completed 2026-06-28*