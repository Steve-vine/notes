---
id: 01KZVBFWDGGYGRWR4SAZGP51ZX
created: 2026-08-12T16:04:37.936961Z
updated: 2026-08-12T16:05:56.650512Z
type: task
title: First-class tags system on Assets
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 121
sprint: s1yya2y
assignee: steve
imported_from: linear
label:
- feature
priority: null
task_status: backlog
---
Add a first-class tags/labels system to Assets, enabling tag-based asset selection and grouping. Deferred from Brief 037 / DEV-183.

## Context

The asset-query Selector (Brief 037 / DEV-183) ships v1 with filtering by AssetKind, value glob, presence, and recency. Tag-based filtering ("every host tagged `web-frontend`") was deferred — Assets have no `tags` column today, `meta` is freeform, and a JSONB-containment convention is rough.

ADR 020 named tag-based selection as a future capability. Trigger this issue when tag-based asset filtering becomes a real ask from a Workflow author.

## Scope (sketch — refine when picked up)

* Data model: probably a `text[]` column or a separate `asset_tag` join table — decide based on cardinality + write-pattern assumptions.
* UX: where tags are set (manually on the Asset detail view? automatically from scanner output? both?).
* A new `tags` field on `AssetQuerySelectorOpts` once the data model lands.
* Likely warrants a feature brief plus possibly an ADR (depending on column-vs-join-table choice).

## Done when

* Workflow authors can compose an asset-query Selector that filters by one or more tags.
* A defined UX for setting and clearing tags on Assets.

---

Imported from Linear [DEV-244](https://linear.app/stevevine/issue/DEV-244/first-class-tags-system-on-assets)