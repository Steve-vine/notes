---
id: 01M4JE5HXV0BGRXXXAZ3RDECWX
created: 2026-10-10T08:16:44.475498Z
updated: 2026-10-10T10:07:23.36295Z
type: task
title: 'Initiative note: Add project, Reference, and richer project rows (excerpt, progress, dates, task count)'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 525
sprint: sqcp1k3
blocked_by:
- 01M4JD9ASMB7CTMSQ546TNBX2A
- 01M4JCVEM0XB8W3VXFB7VMHD9C
comments:
- id: 01M4JM20KD6B0HWDYWAGZA838D
  author: Steve Vine
  at: 2026-10-10T09:59:39.883718Z
  text: 'Backend half landed as its own PR (the NOT-511/512 way): InitiativeProject gains tasks_open / tasks_done / excerpt via note::excerpt (50 words) and a struct ChildProjectRow with task-count subqueries. Frontend half (Add project, Reference, sprint-shaped rows) follows once it merges. Reference section on the initiative note already shipped with NOT-523 (#502).'
assignee: steve
label:
- feature
priority: medium
task_status: review
tech: null
---
So that the initiative note reads like the project note one level up: its project list carries the same facts the sprint list does — a description excerpt, a progress bar, the date span and the task count — and projects can be added from here rather than only from the project's own Initiative field. Builds on NOT-515's Projects section in `NotePane.svelte`.

## Agreed work

### Backend (`notuvia-core`, Tauri)

- [ ] `InitiativeProject` gains `tasks_open: u32`, `tasks_done: u32` (tasks on the project via `edges kind='project'`, done per `task_status` `is_done`, live tasks only — the `project_tasks` counting rule) and `excerpt: Option<String>`: the body's first paragraph from `notes_fts.body`, markdown stripped, capped at **50 words** with an ellipsis; `None` for an empty or sealed body (encrypted bodies index empty by construction). Do the capping in Rust so the MCP/HTTP views get the same excerpt; a small `excerpt(body, max_words)` helper in `note.rs` with its own tests (heading/list markers, links, 49/50/51 words, empty).
- [ ] `child_projects` joins `notes_fts` for the body and a tasks subquery for the counts; `initiative_projects()` maps them. Tauri `InitiativeProject` and `src/lib/notes.ts` updated.

### Frontend (`NotePane.svelte`, initiative branch)

- [ ] **Add project** button on the Projects `sec-head`, the Add sprint button's style (`btn-outline`, `plus` icon). Opens a picker — the Properties pane's project menu idiom (backdrop + list with the ListFilter box) — listing live projects not yet in this initiative; a project already in another initiative shows that initiative's name muted beside it and picking it re-links. Picking calls `setInitiative(projectId, noteId)`; the list refetches via `noteRev`. Empty-state copy updated from "Pick this initiative from a project's Initiative field…" to point at the button too.
- [ ] **Reference** section below Projects, listing `initiativeMemos()` on the project note's Reference idiom (ADR 0038) — this is NOT-523's last checklist item; whichever lands first owns it, the other confirms.
- [ ] **Project rows** reshaped to the sprint row's layout (`.sprint-fields` + `.sprint-progress`), read-only:
  - line 1: project icon, title (opens the project in place).
  - line 2: the excerpt, muted, `sprint-desc` typography (plain text, not an input).
  - line 3 (meta): `identifier · status` with the status dot — moved down from the title line — then the date span `fmtRange`-style from `start`/`due` ("10 Oct → 16 Oct 2026"; one date alone when only one is set; omitted when neither), then the task count (`check-square` icon, "N tasks") as a button that opens that project's task board when `onOpenSprint`-style routing is available (`onOpenProjectBoard` prop — add it to the `NotePane` prop surface and wire it in Main to the NOT-521 `selectBoard`), else a plain span.
  - right: the `progress` snippet with `{ open: tasks_open, closed: tasks_done }`; state `done` when the project `is_done`, `late` when `due` is past and not done, else `normal` — the sprint `barState` rule.
  - A project with no tasks shows the bar at 0% and "0 tasks", not an empty slot.
- [ ] Narrow-pane behaviour matches the sprint row's media query (progress drops under the fields).
- [ ] Tests: Rust for the counts and the excerpt helper; a `fmtRange`-equivalent helper test if the date formatting is extracted to `.ts` (prefer sharing the sprint one — move it to `src/lib/dates.ts` if it is inline today).

## Notes

Depends on NOT-523 (`initiativeMemos`, Reference) and NOT-521 (`selectBoard`, for the task-count jump). The backend half can land as its own PR first, the NOT-511/512 way. `SCHEMA_VERSION` unchanged — new columns are read from tables that already exist. The MCP sidecar needs a restart to serve the new fields.