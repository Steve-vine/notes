---
id: 01KY6YPCBD3NK10VZ25R3HMSHS
created: 2026-07-23T07:40:28.909202Z
updated: 2026-07-23T09:18:04.813972Z
type: task
title: Board/list data — group Tasks & Projects by status (backend read IPC)
assignee: steve
label:
- brief
task_status: done
number: 48
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
sprint: szgfyew
---
The status-grouping data foundation for M7's **Kanban board** (DEV-562). A read query that groups a Type's notes into ordered status columns.

For a given Type, the **status axis** is the system status taxonomy: Task → `task_status`, Project → `project_status` (Memo has none, per `brief/data-model.md`).

Note: the project-note **task list** (DEV-561) uses the Project→Task edge (`children_of`) instead, not this grouping — so this foundation is specifically for the board view.

**Checklist**

- [X] Runtime read method `board(note_type)` → ordered columns: one per status value in the registry's `order`, plus a trailing "no status" column for notes of that Type carrying no status value.
- [X] Each column carries the value's `id`, `label`, `colour`, `is_done`, `order` and its notes as `NoteSummary` (reusing `notes_with_summaries` / `notes_of_type`).
- [X] Tauri command + a thin frontend wrapper in `$lib`.
- [X] Errors for a Type with no status axis (Memo).
- [X] Rust unit tests: columns status-ordered; a note lands in its status column; an unstatused note lands in "none"; `is_done`/`colour` surface.

Backed by the `is_done`/`colour`/`order` value fields from ADR 0005 (no migration). PR #45.

---

Linear DEV-560 · M7 — Boards & lists · created 2026-06-21 · done 2026-06-21