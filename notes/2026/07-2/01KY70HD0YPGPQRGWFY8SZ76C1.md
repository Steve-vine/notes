---
id: 01KY70HD0YPGPQRGWFY8SZ76C1
created: 2026-07-23T08:12:42.910249Z
updated: 2026-07-23T11:03:35.18147Z
type: task
title: Blocked / blocking task dependencies — data & behaviour
imported_from: linear
task_status: done
assignee: steve
number: 151
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
sprint: sa8cznq
---
Follow-up from DEV-754 (Revamp UI): the kanban card renders blocked/blocking icons when set (DEV-769), but nothing produces the data yet — `blocked?`/`blocking?` are optional TS-only fields on `BoardCard`.

Scope: model task dependencies (likely edges, ADR 0006 style), populate the flags on board cards, and define the behaviour (e.g. what "blocked" prevents). The icons and card slot already exist; the backend fields + one type line light them up.

---

Linear DEV-775 · Revamp UI · created 2026-07-02 · done 2026-07-06