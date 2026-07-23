---
id: 01KY72SQS5QXSQSA5KFEN4K1Z1
created: 2026-07-23T08:52:13.221526Z
updated: 2026-07-23T08:52:13.221526Z
type: task
title: 'Taxonomy list: split Custom vs System, not user vs locked'
priority: medium
assignee: steve
imported_from: linear
task_status: done
project: 01KY6W9951TW0904DT0GGJVGE7
number: 313
---
## Context

The taxonomy list splits on the `system` flag, which only Type carries — so the built-ins (Priority, Assignee, Task Status, Project Status) sit under "Your taxonomies" with a chip, even though they're system-generated like Type; they merely have editable value pools. Misleading.

## Change

* **Custom taxonomies** (top, with the New button): only genuinely user-created taxonomies (`!system && !isBuiltinTaxonomy`).
* **System taxonomies** (bottom): Type plus the four built-ins. The built-ins stay clickable into the editor (values editable, frame locked as today); Type stays a read-only row, marked as such.

## Acceptance

* Priority/Assignee/Task Status/Project Status appear under System taxonomies and still open the editor with their values editable.
* Type appears under System taxonomies, not clickable, marked read-only.
* Custom section shows only user-created taxonomies (with delete).

---

Linear DEV-966 · Settings Window · created 2026-07-12 · done 2026-07-12