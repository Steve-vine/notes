---
id: 01KY70HD0YPGPQRGWFY8SZ76C1
created: 2026-07-23T08:12:42.910249Z
updated: 2026-07-30T13:00:43.231994Z
type: task
title: Blocked / blocking task dependencies — data & behaviour
project: 01KY6W9951TW0904DT0GGJVGE7
number: 151
sprint: sa8cznq
assignee: steve
label: null
priority: medium
task_status: done
---
Follow-up from DEV-754 (Revamp UI): the kanban card renders blocked/blocking icons when set (DEV-769), but nothing produces the data yet — `blocked?`/`blocking?` are optional TS-only fields on `BoardCard`.

Scope: model task dependencies (likely edges, ADR 0006 style), populate the flags on board cards, and define the behaviour (e.g. what "blocked" prevents). The icons and card slot already exist; the backend fields + one type line light them up.

---

Linear DEV-775 · Revamp UI · created 2026-07-02 · done 2026-07-06