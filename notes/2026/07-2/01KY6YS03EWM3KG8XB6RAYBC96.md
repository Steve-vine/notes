---
id: 01KY6YS03EWM3KG8XB6RAYBC96
created: 2026-07-23T07:41:54.670392Z
updated: 2026-07-23T12:24:59.305933Z
type: task
title: Project Identifier & per-project task numbers (<identifier>-NNN)
number: 57
label: null
assignee: steve
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
sprint: szgfyew
---
Give Projects a human-friendly **Identifier**, and each Task in that project a unique display id `<identifier>-NNN` (Linear-style, e.g. `WEB-014`). This is a **display id**, separate from the note's ULID storage id (ADR 0004) and the `project` edge (ADR 0006).

**Checklist**

- [ ] Add an `identifier` property to Project notes (short, e.g. uppercase slug); editable in the project note / capture; uniqueness across projects.
- [ ] Assign `<identifier>-NNN` to a Task when it's created in / linked to a project; decide the **sequence source** (per-project monotonic counter) and where it lives (project frontmatter counter vs derived from existing children — beware deletes/reuse and concurrent capture).
- [ ] Persist the assigned number on the task (frontmatter) so it's stable; index it for display/lookup.
- [ ] Show the task number on Kanban cards, the project task list, search results, and the note header.
- [ ] Decide behaviour when a task moves projects or a project's identifier changes (renumber vs keep).

**Design note:** the numbering scheme (counter persistence, collision/reuse, stability) is load-bearing and has sync implications (M9) — likely warrants an ADR or a `brief/data-model.md` addition before building.

---

Linear DEV-577 · M7 — Boards & lists · created 2026-06-22 · done 2026-06-22