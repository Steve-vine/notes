---
id: 01KY70PPMZYGG0TQCK45NS712S
created: 2026-07-23T08:15:36.607957Z
updated: 2026-07-23T08:22:32.906505Z
type: task
title: Projects section
task_status: done
assignee: steve
imported_from: linear
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 163
comments:
- id: 01KY70PVY85YZWQW5PAB6CZFT7
  author: Steve Vine
  at: 2026-07-23T08:15:42.023581Z
  text: |-
    Steve Vine · 2026-07-03:

    **Done building** — PR: https://github.com/Steve-vine/notuvia/pull/145

    **What was done:** The Projects section now lists **All Projects** (renamed, brackets dropped), **Active Projects**, and **Closed Projects**. The projects board selection carries an optional `scope`; the Kanban view filters the loaded project board's status columns by their `is_done` flag (ADR 0005's terminal flag), so this needed no backend change. Scope persists per tab and revives safely from old documents.

    **Decisions on the fly:** Interpreted the "2 new sections" as two new *entries* in the existing Projects section (matching the sidebar's list idiom) rather than two more collapsible headers. "Active" shows every not-done column **including "no status"** — an unstatused project is not done. Whole columns are filtered rather than individual cards, so the scoped boards keep column drag/drop and add-card behaviour; a project dragged to a done column on the Active board disappears from it on the next load, which is the expected reading.

    **Problems:** None. `npm run check`, `npm test` (110, incl. a new scope round-trip test) green.
label: null
---
In kanban mode, in the projects section, rename "[All Projects]" to "All Projects".

Also add 2 new sections - "Active Projects" showing any projects not in a "done" status. And "Closed Projects" showing any with a "done" status.

## Agreed work

* Rename the Projects section's "[All Projects]" entry to "All Projects" and add two more entries: "Active Projects" and "Closed Projects".
* The projects `BoardSel` gains an optional `scope` ("active" | "closed"; absent = all). Old persisted workspaces revive as the unfiltered board, unchanged.
* The Kanban view keeps loading the full projects board and, for a scoped selection, shows only the status columns whose `is_done` flag matches — "Active Projects" shows the not-done columns (including "no status"), "Closed Projects" the done ones. No backend change.
* Serialization round-trips the scope; a round-trip test is added.
* Checks: `npm run check`, `npm test`.

---

Linear DEV-801 · Left Panel Improvements · created 2026-07-03 · done 2026-07-04