---
id: 01M2AAA6S6TQKN0TZCSJ1J8XJB
created: 2026-09-12T08:04:03.494489Z
updated: 2026-09-12T11:17:51.228426Z
type: task
title: Technology assets gain a Notes field at the bottom of the form
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 686
sprint: skdc1az
comments:
- id: 01M2AND19TNH5JSXD4ZVAVNKN0
  author: Steve Vine
  at: 2026-09-12T11:17:50.521895Z
  text: |-
    Merged to main in PR #695 (2026-09-12).

    A Notes field on technology assets: the last field on the modal, internal and portal, a textarea the same size as Description. Saved text shows in a Notes section at the end of the detail and portal pages, only when there is any. The CSV template and importer take an optional notes column. Changes are audited like every other column. Not searched — Description is; Notes is for things that should not surface in search results.

    Tests: create/edit round trip and clearing; portal owner edit; CSV import with and without the column; detail page shows the section only with text; modal seeds and saves it with Description's size.

    Deploys to staging with the rest of sprint 59. Smoke: the modal ends with Notes; saved text on the detail and portal pages; the audit trail records a change.
assignee: steve
label:
- improvement
priority: low
task_status: review
---
Requested by Steve, 2026-09-12: a free-text **Notes** field on a technology asset — anything worth writing down that has no field of its own.

* `containers.notes` (Text, nullable). Migration append-only, one head.
* **The form**: the last field on the technology asset modal, internal and portal (the owner may edit it), a `Textarea` the same size as Description (same `rows`/`autosize` settings — copy Description's, do not invent a second size). Label "Notes", no description needed.
* **Detail page**: a Notes section after everything else, rendered only when there is text; same on the portal asset page.
* **CSV**: an optional `notes` column on the template and importer; included in any export.
* Audited like every other column (the table is already in `_AUDITED_TABLES`; nothing to add beyond the column).
* Not searchable by global search for now — Description is; Notes is the place for things that should not surface in search results. Revisit if asked.
* Regenerate `schema.d.ts`; tests: round-trip on create/edit, portal edit, import.

**Acceptance**: the modal ends with a Notes textarea the size of Description; text saved shows on the detail and portal pages and survives edit; the audit trail records changes to it.