---
id: 01KXGTPDCJFB4PS00P0PDE4W7E
created: 2026-07-14T17:27:18.162325414Z
updated: 2026-07-14T17:29:36.821872378Z
type: task
title: M21 · Brief 1 backend — sectioned content, editable content types & template mappings
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 93
sprint: s28w1cp
label: null
---
Backend for **ADR 0030 §1, §2, §7** (M21 — Content). First of three backend→frontend pairs.

## Scope

Reshape content into placeholder-named sections and turn content types into editable, template-mapped library data.

### Sections (ADR 0030 §1)

* New `content_sections` table: `content_item_id` FK, `placeholder` (join key, stored without brackets, e.g. `main-policy`), `display_order`, `heading` (optional), `body` (Markdown). Audited, soft-deletable.
* `ContentItem.body` becomes a **derived rollup** — recomputed as the ordered concatenation of section bodies on save (keeps M6 global search, published view and version snapshots working unchanged).
* `content_versions` gains nullable `sections_json` capturing the ordered section set at publish (alongside the existing `body` snapshot).
* CRUD API for sections within a content item (add / reorder / edit / delete).

### Content types → table (ADR 0030 §2)

* `ContentType` **enum →** `content_types` table: `name`, `slug`, `display_order`, `status` (`active|disabled`), `template_id` (nullable FK → content_templates), audited, soft-deletable. Seed the existing five (policy, standard, process, procedure, runbook).
* `ContentItem.type` (enum) → `type_id` FK, backfilled.
* CRUD gated `require_library_write` (analyst/admin, ADR 0026); reversible **disable**; **guarded delete** (409 "in use — disable instead").
* **Mappings**: the `type → template` association (the nullable FK); endpoint to set/clear it.

### Cross-cutting (ADR 0030 §7)

* Add `content_types`, `content_sections` (and `content_templates` when it lands in brief 2) to the audit allowlist (ADR 0023).
* Content-types seed is **insert-missing-only** (by slug); user edits survive redeploys.

### Migration 0024 (down_revision `0023_decision_fuzzy_declined`)

Create `content_types` (seeded, `content_type_status` enum) + `content_sections`; add `content_items.type_id` (backfill from enum, drop old column), `content_versions.sections_json`; backfill one section (placeholder `body`) per existing content item. `content_types.template_id` FK added now (nullable) or when templates land in brief 2.

## Out of scope

Templates upload (brief 2), merge/render (brief 3), all UI (brief 1 frontend).

Refs: ADR 0030 §1/§2/§7, 0013, 0027, 0028, 0026, 0023, 0015.

---
*Migrated from Linear [DEV-678](https://linear.app/stevevine/issue/DEV-678/m21-brief-1-backend-sectioned-content-editable-content-types-and) · created 2026-06-27 · completed 2026-06-28*