---
id: 01KY6YRRR36KVGJPTH4CKSAHDT
created: 2026-07-23T07:41:47.13943Z
updated: 2026-07-23T11:03:35.161011Z
type: task
title: Priority taxonomy for tasks + Priority Settings
number: 56
imported_from: linear
assignee: steve
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
sprint: szgfyew
---
Give every Task a **Priority**, with a dedicated **Priority Settings** page to edit the values (like the status settings).

Modelled as a built-in **Priority** taxonomy scoped to Task (ordered values, colours; no `is_done`) — e.g. Urgent / High / Medium / Low / None. Editable via Settings, sharing the editable-built-in-taxonomy model from DEV-573.

**Checklist**

- [ ] Define a built-in Priority taxonomy (Task-scoped) with sensible default values + colours.
- [ ] Priority Settings page: add / remove / reorder / edit values (label, colour), per DEV-573.
- [ ] Surface priority in capture + the note editor, on Kanban cards, and in the project task list.
- [ ] (Stretch) sort cards within a column by priority; group/filter the board by priority.

Blocked by DEV-573 (editable built-in taxonomy model). If we'd rather ship it as a plain user taxonomy first, it can stand alone via the existing taxonomy management (DEV-549) — note the choice.

---

Linear DEV-576 · M7 — Boards & lists · created 2026-06-22 · done 2026-06-22