---
id: 01KY71N77ECZ5F0Q7YAPN3MMHN
created: 2026-07-23T08:32:16.622831Z
updated: 2026-07-23T11:03:35.890902Z
type: task
title: 'notuvia-mcp: taxonomy vocabulary management'
task_status: done
imported_from: linear
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 233
sprint: sndmea4
label: null
---
Over MCP, taxonomy vocabulary is read-only: agents can apply existing values (`list_taxonomies` + validated `values` on create/update) but cannot add a status, a priority level, or a new taxonomy. The core has the full in-app management surface (ADR 0011): `create_taxonomy`, `update_taxonomy`, `delete_taxonomy`, `rename_taxonomy_value`, `merge_taxonomy_value`.

Scope — decide how much of that to expose. A sensible split:

* **Safe tier (likely worth it):** add a value to an existing taxonomy's pool, rename a value's label (`rename_taxonomy_value` — ids are stable, so notes don't rewrite). This covers the common agent need ("there's no `blocked` status — add one").
* **Structural tier (decide deliberately):** `create_taxonomy` / `update_taxonomy` for whole definitions.
* **Destructive tier (probably keep in-app):** `delete_taxonomy` and `merge_taxonomy_value` rewrite/strip values across the vault — the kind of bulk mutation an agent typo shouldn't be able to trigger. Consider excluding these, mirroring how encryption stays in-app-only.

System taxonomies (`type`, and the ownership rules from ADR 0009) must stay protected regardless — the core already enforces this; the MCP layer should surface those errors clearly.

Context: fourth gap found while assessing project management over notuvia-mcp instead of Linear (sprints DEV-883, comments DEV-884 done; dependencies DEV-885).

---

Linear DEV-886 · MCP Server · created 2026-07-07 · done 2026-07-07