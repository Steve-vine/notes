---
id: 01KY716S197D4Q3SWX9AJCB5DA
created: 2026-07-23T08:24:23.337144Z
updated: 2026-07-23T12:24:59.771621Z
type: task
title: ToDo list bug
task_status: done
comments:
- id: 01KY716YE5ZC9C4V27JQNFATZM
  author: Steve Vine
  at: 2026-07-23T08:24:28.869313Z
  text: |-
    Steve Vine · 2026-07-05:

    Fixed — PR: https://github.com/Steve-vine/notuvia/pull/185 (first commit; lands with DEV-850).

    **What was done**

    Exactly the agreed one-liner: the project-list effect in `Main.svelte` now fires when the Dashboard view opens, not just Kanban. The ToDo query is scoped to the project ids, so the previously-empty list on first launch was why only loose tasks showed until a Kanban visit populated it.

    **Problems encountered**

    None. To verify: relaunch the app straight into the Dashboard — the full ToDo list (project groups included) should be there immediately.
assignee: steve
label: null
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 203
sprint: sjgxe93
---
There seems to be a bug where when the app is first opened the ToDo list only shows 2 'loose' tasks until I click on Kanban and go back to dashboard.

## Diagnosis & agreed fix

`Main.svelte` (re)loads the project list only when the **Kanban** view is opened (`if (active.mode === "kanban") void loadProjects()`). On first launch into the Dashboard, `projects` is still empty, so the ToDo query — `task_board` scoped to the project ids — returns only unparented ("loose") tasks. Visiting Kanban loads the projects; returning to the Dashboard re-runs the load with the full list, which is why the round-trip "fixes" it.

**Fix:** load the project list when the Dashboard view is opened too (the effect fires for `kanban` *or* `dashboard`).

Lands together with DEV-850 on one branch (both touch the Dashboard; sequencing beats stacking under squash-merge).

---

Linear DEV-856 · Dashboard · created 2026-07-05 · done 2026-07-05