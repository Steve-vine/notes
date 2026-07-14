---
id: 01KXH04QAERP9C4ZAW7P7FCX2W
created: 2026-07-14T19:02:29.966075842Z
updated: 2026-07-14T19:02:29.966075842Z
type: task
title: 'Docs: switch working-practice docs from Linear to Notuvia (ADR 0038)'
label: chore
task_status: active
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 164
---
Update the repo documentation to reflect that Notuvia (not Linear) is the work-tracking tool, following the 2026-07-14 migration.

- [x] New ADR `decisions/0038-work-tracking-moves-to-notuvia.md` — records the switch, amends the work-tracking clauses of ADR 0016/0019 (append-only, so those stand as history)
- [x] CLAUDE.md — "How we work": Notuvia tasks/sprints, COM-123 references, `notuvia` MCP, `feature/com-NNN` branches; ADR list
- [x] CONTRIBUTING.md — workflow, branch example, Definition of Done
- [x] brief/ways-of-working.md — board statuses (Backlog → ToDo → Active → Review → Done + Cancelled), 7-step loop, labels table, resolved section
- [x] docs/ci.md — branch convention
- [x] README.md + app/backend/README.md — one-line mentions
- Historical DEV-NNN references left intact (resolve via the migration map memo)

First task taken through the full loop under the new tracking system.