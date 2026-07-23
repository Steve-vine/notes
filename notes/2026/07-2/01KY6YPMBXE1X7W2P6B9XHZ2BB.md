---
id: 01KY6YPMBXE1X7W2P6B9XHZ2BB
created: 2026-07-23T07:40:37.117751Z
updated: 2026-07-23T12:24:57.748404Z
type: task
title: 'Project note: associated Tasks list (with state)'
assignee: steve
task_status: done
label: null
number: 49
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
sprint: szgfyew
---
Augment the **Project note view** with a list of the Tasks associated to it. Below the existing title and description (body), a Project note shows its child Tasks (the `project` edge, ADR 0006), each with relevant info such as **state** (`task_status`).

This is an embedded list on the note, **not** a standalone status-grouped view (that grouping is the Kanban's job, DEV-560/DEV-562).

**Checklist**

- [ ] Backend: a read returning a Project's child Tasks with their `task_status` (value id → label/`colour`/`is_done` via the registry), ordered. Reuses the `project` edge already in the index (`children_of`).
- [ ] Tauri command + `$lib` wrapper.
- [ ] In `NotePane`, for a Project note only, render a "Tasks" section below the body: each row shows the task title + a status chip (colour, `is_done` de-emphasised); clicking a row opens that Task.
- [ ] Refreshes when notes change (a task's status edit / a new task linked) — reuse the existing note-change signal.
- [ ] Empty state when the Project has no tasks.

Only Project notes show this. UI — needs design sign-off.

---

Linear DEV-561 · M7 — Boards & lists · created 2026-06-21 · done 2026-06-21