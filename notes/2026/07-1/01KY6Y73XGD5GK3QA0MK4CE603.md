---
id: 01KY6Y73XGD5GK3QA0MK4CE603
created: 2026-07-23T07:32:08.752116Z
updated: 2026-07-23T12:24:58.605138Z
type: task
title: Project link picker in capture (Task → Project)
comments:
- id: 01KY6Y79YRX6TF06HQ09YC93X0
  author: Steve Vine
  at: 2026-07-23T07:32:14.936333Z
  text: |-
    Steve Vine · 2026-06-21:

    Shipped in PR #33 (https://github.com/Steve-vine/notula/pull/33), merged to main (`10572dc`). Tested OK by Steve.

    - Backend: `Index::notes_of_type` + `list_projects` command; `NewNote.project`; `save_note` writes a validated `project:` link (reserved relationship key). The index already makes the `project` edge / `children_of` resolves it.
    - Frontend: Type-conditional **Project pill** in capture (Tasks only) with a "No project" + Projects popover; sent on save, cleared when Type leaves Task.

    43 cargo tests (incl. a new task→project link test), 28 vitest, check + bundle green. Capture-only (editing a Task's Project in the main editor rides with DEV-519 / M6).

    (Status updates were delayed earlier — the Linear token expired mid-task; reconnected now.)
label: null
task_status: done
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 17
sprint: sevsjkn
---
Deferred from DEV-511. The capture window's `project` link for Tasks (ADR 0006) was held back because `project` is a relationship/edge, not a taxonomy — it doesn't come from the taxonomy registry, and a real picker needs a "list projects" query. Belongs with M5's Project↔Task UI work.

**Checklist**

- [ ] Add an index query / command to list Project notes (notes where `type = project`, returning id + title) — `notes` table already has `note_type`/`title`
- [ ] Render a `project` picker on Tasks in the capture window (and later the editor), populated from that list; "no project" allowed (membership is optional, ADR 0006)
- [ ] Write the chosen Project's id as `project:` in the Task's frontmatter → the index already turns it into a `project` edge (DEV-484); `children_of` already queries it
- [ ] Resolve a dangling `project` id (deleted Project) to "orphaned" rather than erroring in the UI

**Done when:** a Task created/edited in the app can be linked to an existing Project, written as the `project:` id and reflected in the Project↔Task views.

**Notes:** `Index::children_of` and the edge population already exist (DEV-484); this is the UI + the list-projects read. No new ADR (implements ADR 0006).

---

Linear DEV-512 · M5 — Tasks & projects · created 2026-06-20 · done 2026-06-21