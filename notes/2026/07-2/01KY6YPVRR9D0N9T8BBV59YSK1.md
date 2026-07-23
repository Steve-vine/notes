---
id: 01KY6YPVRR9D0N9T8BBV59YSK1
created: 2026-07-23T07:40:44.69628Z
updated: 2026-07-23T11:04:50.882426Z
type: task
title: Kanban board view (replaces the main note panel)
task_status: done
assignee: steve
number: 50
imported_from: linear
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
sprint: szgfyew
---
A Linear-like **Kanban board** that takes the place of the main note-view panel. Columns are the status values (in `order`), cards are the notes, and dragging a card between columns changes that note's status.

**Checklist**

- [ ] A board view mode for the main panel (replacing the note view when active) — Tasks grouped by `task_status` (and/or Projects by `project_status`). Consumes the board data IPC (DEV-560).
- [ ] Columns in status `order`, headed with the value `label`/`colour`; a trailing "no status" column. Cards show the note title; clicking opens it.
- [ ] **Drag a card to another column** writes the note's status field and reindexes (reuse the note write/reindex path + self-write guard; board refreshes from the index).
- [ ] `is_done` columns marked terminal.

Builds on DEV-560. Comes after the project-note task list (DEV-561). UI — needs design sign-off. Per-card manual ordering within a column is out of scope (needs a new per-note sort key).

---

Linear DEV-562 · M7 — Boards & lists · created 2026-06-21 · done 2026-06-22