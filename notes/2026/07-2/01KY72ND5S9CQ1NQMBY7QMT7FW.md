---
id: 01KY72ND5S9CQ1NQMBY7QMT7FW
created: 2026-07-23T08:49:51.289448Z
updated: 2026-07-23T08:53:23.131174Z
type: task
title: Dependency arrows on the Gantt
task_status: done
imported_from: linear
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 299
label: null
---
Part 5 of the Gantt capability (DEV-685). Depends on DEV-949 (skeleton).

Draw the existing `blocked_by` dependencies (ADR 0026) as arrows between task bars. A new `project_dependencies(projectId)` command exposes the blocked_by pairs whose ends are both tasks of the project (a filtered variant of the vault-wide pairs query). A task whose bar starts before its blocker's due date gets a warning tint.

Core tests: the pairs query filters to the project; cross-project edges are excluded.

---

Linear DEV-952 · Project Enhancements · created 2026-07-11 · done 2026-07-12