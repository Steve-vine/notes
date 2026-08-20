---
id: 01M0FW84JE7VTEF8FVF44S8HWQ
created: 2026-08-20T15:22:18.574062Z
updated: 2026-08-20T15:22:18.574062Z
type: task
title: Group kinds look apart on the canvas — per-type icon and colour
task_status: todo
label: improvement
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 322
---
Sprint 36 follow-up (graph improvements, 2026-08-20). Every group on the canvas draws identically (grape, IconUsersGroup) — a security group, an M365 collaboration group and a distribution list read as the same object, which is exactly the ISE-515 mistake ADR 0048's port was meant to avoid. Give each `DirectoryGroupType` its own glyph and colour.

* **Backend first**: the graph payload doesn't say what kind of group a node is. Add `group_type` (nullable — groups only) to `DirectoryGraphNodeOut` and `DirectoryGraphRefOut`; populate from the existing names batch fetch in `directory_graph` (no extra query). Regenerate `schema.d.ts`. Extend the integration tests.
* **Frontend registry** (`graphMeta.ts`, the named-once rule): per group type an icon + colour, all distinct by eye at 18px — security keeps grape/IconUsersGroup (the incumbent); m365, distribution and mail-enabled security each get their own (verify the chosen Tabler glyphs exist in our version; distinct silhouettes, not variants of one shape). Colours must work as pale fills with dark text (the light-fill/dark-text rule) and stay clear of user-blue and role-teal.
* **The node's second line** says the specific kind, reusing `GROUP_TYPE_LABELS` from `directoryLabels.ts` — "Microsoft 365 group", not just "group" (the kind must not live only in the hover title).
* Canvas + model: node styling keys off `group_type` when present, falling back to the generic group treatment for an unknown/absent type (honest fallback, never borrowing another kind's look).
* Tests: registry distinctness (no two group types share an icon or colour), node renders the specific label, backend graph test asserts `group_type` on group nodes and null on users.

Refs: ADR 0048 §1/§4; `api/v1/directory.py` (`directory_graph`), `api/v1/schemas.py`, `src/access/graph/graphMeta.ts`, `DirectoryGraphView.tsx`, `src/access/directoryLabels.ts`.