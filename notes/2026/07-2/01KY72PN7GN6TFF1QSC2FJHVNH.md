---
id: 01KY72PN7GN6TFF1QSC2FJHVNH
created: 2026-07-23T08:50:32.304295Z
updated: 2026-07-23T11:04:51.28778Z
type: task
title: Timeline interactions — drag Start/End, double-click into the Gantt
assignee: steve
imported_from: linear
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 303
sprint: scnde4j
---
Part 2 of the Timeline (DEV-946). Depends on DEV-955 (skeleton).

* **Drag to reschedule**: dragging a project's bar moves its Start/End together; edge handles move one date (the Gantt's applyDrag semantics, live preview, optimistic commit via the existing `set_note_dates`). When the project has no explicit dates, the drag's origin is the *derived* envelope, so the write makes them explicit.
* **Double-click into the Gantt**: double-clicking a project row/bar scopes the board to that project with the time view kept — landing on its task Gantt. Single click keeps selecting for the properties panel.

---

Linear DEV-956 · Project Enhancements · created 2026-07-12 · done 2026-07-12