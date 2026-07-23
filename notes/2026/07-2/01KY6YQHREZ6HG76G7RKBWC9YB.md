---
id: 01KY6YQHREZ6HG76G7RKBWC9YB
created: 2026-07-23T07:41:07.214422Z
updated: 2026-07-23T07:41:07.214422Z
type: task
title: Manual card ordering within a Kanban column
imported_from: linear
task_status: done
assignee: steve
label: follow_up
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 52
---
Follow-up from DEV-562. Cards within a Kanban column are currently ordered by title. Linear-style boards let you **drag to reorder** cards within a column and persist that order.

This needs a **per-note sort key** — the taxonomy value `order` (ADR 0005) orders the *columns* (status values), not individual notes, so a new field is required to rank notes within a status.

**Checklist**

- [ ] Decide & record the per-note ordering field (e.g. a frontmatter `order`/`rank` key; consider a sparse/fractional rank to avoid rewriting siblings on every move). Likely warrants an ADR or a note in `brief/data-model.md`.
- [ ] Index it; order the board columns' notes by it (fallback to title).
- [ ] Drag-to-reorder within a column writes the new rank (+ reindex), reusing the board's write path.

Not MVP; depends on the cross-machine-merge implications of a per-note order (sync, M9).

---

Linear DEV-572 · M7 — Boards & lists · created 2026-06-22 · done 2026-06-22