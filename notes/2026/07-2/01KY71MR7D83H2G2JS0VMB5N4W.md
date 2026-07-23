---
id: 01KY71MR7D83H2G2JS0VMB5N4W
created: 2026-07-23T08:32:01.261519Z
updated: 2026-07-23T12:24:57.552105Z
type: task
title: 'notuvia-mcp: task dependency support (blocked_by read + write)'
task_status: done
assignee: steve
label: null
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 232
sprint: sndmea4
---
Expose task dependencies (ADR 0026) over MCP. The core already has the full surface — `set_blocked_by(id, blockers)` (full-replace list via the single-field write path) and `dependency_info(id, reverse)` (blockers or blocked tasks, with done-status resolution) — but no MCP tool reads or writes them, and `get_note` doesn't surface them (dependencies live outside the note view, like comments).

Scope — MCP tools wrapping the core commands:

* `set_blocked_by(id, blockers)` — full replacement of a task's blocker list; validate the ids are existing tasks so a typo errors rather than writing a dangling edge.
* Read side: graft `blocked_by` / `blocks` onto `get_note` output when non-empty (the comments idiom from DEV-884), or a dedicated `dependency_info` tool if the done-flags/display-ids are worth surfacing.

Out of scope: sub-tasks. Notuvia's data model has no parent-task concept (tasks parent to projects only) — that would be a new core feature, not an MCP exposure, and should be its own issue if ever wanted.

Context: third of the gaps found while assessing project management over notuvia-mcp instead of Linear (sprints DEV-883 and comments DEV-884 are done).

---

Linear DEV-885 · MCP Server · created 2026-07-07 · done 2026-07-07