---
id: 01KY6YR1JERGMCHY4RP3Q06TTA
created: 2026-07-23T07:41:23.406691Z
updated: 2026-07-23T07:41:23.406691Z
type: task
title: 'Settings: edit Task Status & Project Status values'
imported_from: linear
task_status: done
label: brief
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 54
---
A Settings surface to **add / remove / reorder / edit** the values of **Task Status** and **Project Status** — label, colour, and the terminal `is_done` flag — so the Kanban columns are user-configurable.

Today these are read-only system taxonomies (ADR 0009); this is gated on the ownership/editability decision in DEV-573.

**Checklist**

- [ ] In Settings, make Task Status & Project Status editable (reuse the in-app taxonomy management UI from DEV-549 — currently it lists them under "System taxonomies (read-only)").
- [ ] Add / remove / reorder values; edit label & colour; toggle `is_done`.
- [ ] Guardrails per DEV-573 (e.g. keep ≥1 `is_done`; the Type taxonomy stays locked).
- [ ] Persist per the storage decision in DEV-573; the Kanban board, capture, and editor pick up the changes (existing `taxonomyRev` / hot-reload path).
- [ ] Reindex / handle notes carrying a value that was removed or renamed (reuse the rename/merge-with-reindex work, DEV-551).

Builds on DEV-549 / DEV-551. Blocked by DEV-573 (ADR).

---

Linear DEV-574 · M7 — Boards & lists · created 2026-06-22 · done 2026-06-22