---
id: 01KY6YQ44NGB1KFJ6YNFVMTKEJ
created: 2026-07-23T07:40:53.269564Z
updated: 2026-07-23T11:04:50.694793Z
type: task
title: Live-refresh board & project-task list on note changes
task_status: done
assignee: steve
number: 51
imported_from: linear
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
sprint: szgfyew
---
Follow-up from DEV-561 / DEV-562. The Kanban board and the project-note Tasks list refetch on (re)selection / navigation and on a `taxonomyRev` bump, but **not** when a note they show is edited elsewhere in-app (e.g. a task's status/title changed in another pane, or a new task linked to the project). Those edits write the file and record a self-write, so the watcher suppresses the echo and no refresh signal reaches the views.

**Done when:** changing a task's status/title (or linking/unlinking a task) in one place updates an open Kanban board / project Tasks list without a manual re-select.

**Sketch:** emit a lightweight "note saved" frontend signal from the in-app write path (akin to `taxonomyRev`), and have the board / `NotePane` Tasks list depend on it. (The existing `note-changed` event only fires for *external* disk changes, so it doesn't cover in-app edits by design.)

---

Linear DEV-571 · M7 — Boards & lists · created 2026-06-22 · done 2026-06-22