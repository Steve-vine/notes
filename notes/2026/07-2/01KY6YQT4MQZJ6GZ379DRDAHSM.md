---
id: 01KY6YQT4MQZJ6GZ379DRDAHSM
created: 2026-07-23T07:41:15.796341Z
updated: 2026-07-23T09:08:57.304245Z
type: task
title: ADR — user-editable status & priority taxonomies (amend ADR 0009)
number: 53
label: brief
task_status: done
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
---
Enabling decision for the editable **Task Status / Project Status** settings (DEV-574) and the built-in **Priority** taxonomy (DEV-576).

[ADR 0009](<../decisions/0009-system-taxonomy-ownership.md>) makes the three system taxonomies (Type, Task Status, Project Status) **app-owned, compiled-in, and not user-editable** — and explicitly defers customisation: *"if we ever want user-customisable system taxonomies, that is a new ADR."* We now want exactly that for the status taxonomies (and a new built-in Priority).

**Decision to record:**

* How a built-in/behaviour-bearing taxonomy (Task Status, Project Status, Priority) becomes **value-editable** — add / remove / reorder values, edit label·colour, and set the terminal `is_done` flag — while keeping the load-bearing invariants safe:
  * **Type stays locked** (the three Types carry behavioural hooks; not in scope here).
  * At least one `is_done` status must remain (board/list completion semantics).
* **Where the definitions live** once editable: stay code-owned with a user override layer, or move to `taxonomies.yaml` with app-seeded defaults (revisits ADR 0009's "file is user-only" stance)? Consider sync/versioning (the reason 0009 kept them code-owned).
* Migration for existing vaults.

**Done when:** an accepted ADR in `decisions/` settles the ownership/editability model and the storage location; supersede/amend 0009 per the append-only rule (`decisions/0001`). Blocks DEV-574 and DEV-576.

---

Linear DEV-573 · M7 — Boards & lists · created 2026-06-22 · done 2026-06-22