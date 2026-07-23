---
id: 01KY732H0KP3DNHBRM14T6QF4X
created: 2026-07-23T08:57:01.203357Z
updated: 2026-07-23T11:04:50.375462Z
type: task
title: Conflict copies are re-numbered on their next save, undoing the number drop
assignee: steve
imported_from: linear
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 343
---
Observed 2026-07-18: the keep-both merge correctly created the ISE-73 conflict copy (`01KXV0ET3RF3YM0PB17W2WFT7E`) with **no** task number — the DEV-942 drop worked. But the next in-app save of the copy (16:29:29, likely just opening it in a pane given the no-op-save behaviour) ran `allocate_task_number`, which saw a project-linked task without a number and stamped the next free one. The conflict copy became "ISE-118": it masquerades as a real new task, consumes a number that is never reclaimed (numbers are monotonic by design), and misleads anyone scanning the board.

**Change:** number allocation should skip notes carrying `conflict_of` — a conflict copy is a holding pen for divergent content, not a task in its own right. It should only earn a number if the user deliberately promotes it (e.g. clears `conflict_of` / resolves the conflict by keeping it).

---

Linear DEV-996 · created 2026-07-18 · done 2026-07-19