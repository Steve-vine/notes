---
id: 01KY72MHH29YDDNFZRQR6AT911
created: 2026-07-23T08:49:22.97818Z
updated: 2026-07-23T08:53:23.117346Z
type: task
title: Start dates on tasks and projects
imported_from: linear
task_status: done
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 295
label: null
---
Part 1 of the Gantt capability (DEV-685). Add an optional `start` core date field (`YYYY-MM-DD`), the exact sibling of `due` (ADR 0022) at every layer: frontmatter → index column + SCHEMA_VERSION bump → runtime (NoteView, update_note, BoardCard) → Tauri command params → ops/MCP patch semantics (omit-to-keep, empty-to-clear) → properties pane date row above Due.

* For projects, the pair is labelled **Start / End** in the properties pane (End is the existing `due` field — no second new field).
* `start` joins the ghost-mirrored field set (ADR 0039) beside `due` — in `sync_ghost_mirrors` and the ghost-creation copy.
* ADR 0040 (Gantt view and start dates) and the `brief/data-model.md` update land with this issue.
* Core tests: round-trip, indexing, ghost mirroring of start.

---

Linear DEV-948 · Project Enhancements · created 2026-07-11 · done 2026-07-12