---
id: 01KY71A89KHS60WM1TYJ4GB8J6
created: 2026-07-23T08:26:17.267322Z
updated: 2026-07-23T08:26:17.267322Z
type: task
title: Taxonimies across a project and its tasks
task_status: done
assignee: steve
imported_from: linear
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 211
---
Dealing with taxonomies within projects has become complex when adding and removing tasks and taxonomies.  The simplify this, the behaviour should change as described below.

Tasks in a project always inherit the taxonomies of the parent project.

1. When creating a new task in a project, it gets all taxonomies of the project note
2. When adding a task to a project, it gets all taxonomies of the project note
3. When removing a task to become a loose task it keeps all its taxonomies
4. When removing a task to another project, rule 2 applies and existing taxonomies that don't exist in the new project are removed.
5. When adding a taxonomy to the parent project, all tasks get that taxonomy
6. When removing a taxonomy from the parent project all tasks lose that taxonomy
7. When adding a taxonomy to a task in a project, all tasks and the parent project note get that taxonomy
8. When removing a taxonomy from a task, all tasks in the project and the project note lose that taxonomy

In short, a project note and all associated task notes always have the same taxonomies.

---

Linear DEV-864 · Revamp UI · created 2026-07-06 · done 2026-07-06