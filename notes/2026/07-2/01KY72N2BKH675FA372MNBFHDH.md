---
id: 01KY72N2BKH675FA372MNBFHDH
created: 2026-07-23T08:49:40.211282Z
updated: 2026-07-23T11:03:36.325972Z
type: task
title: Drag to reschedule on the Gantt
imported_from: linear
task_status: done
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 298
sprint: scnde4j
label: null
---
Part 4 of the Gantt capability (DEV-685). Depends on DEV-949 (skeleton).

Dragging a task bar moves it (start and due shift together); dragging an edge changes just the start or due. Writes go through a new direct-write command `set_note_dates(id, start, due)` (the single-purpose write idiom: touch updated, reconcile, git touch) which also syncs ghost mirrors (ADR 0039 — dates are mirrored fields). The chart and board refresh live via the usual notes bump.

Core tests: date writes round-trip and reach ghost mirrors; clearing behaviour.

---

Linear DEV-951 · Project Enhancements · created 2026-07-11 · done 2026-07-12