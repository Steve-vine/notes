---
id: 01KY71M1TGEEGYWJHA749KSJAG
created: 2026-07-23T08:31:38.320288Z
updated: 2026-07-23T08:33:20.480693Z
type: task
title: 'notuvia-mcp: sprint/milestone write support (create + assign notes)'
task_status: done
assignee: steve
imported_from: linear
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 230
label: null
---
Expose the existing sprint/milestone capability over MCP. `get_note` already *reads* a note's project/milestone/sprint relationships, but no MCP tool can create sprints or assign notes to them — sprint-based project management is read-only over MCP.

The model and core implementation already exist: sprints are an ordered `sprints:` frontmatter list on the project note with stable slug ids and positional numbering (ADR 0024, same shape as milestones per ADR 0019), and `notuvia-core`'s runtime has `project_sprints` plus save/round-trip support including task→sprint assignment resolved against the linked project.

Scope — MCP tools wrapping the core commands:

* Manage a project's sprints: add, retitle/redescribe, reorder, delete (or a single save-list tool mirroring the core surface).
* Set/clear a task's sprint (and milestone) via `update_note` or a dedicated tool — patch semantics consistent with the existing `project` field; reference the sprint's stable `id`, not its positional number.
* Validate the target sprint/milestone belongs to the task's linked project (the core already resolves this at read time).

Context: surfaced while assessing whether a project could be managed end-to-end via notuvia-mcp instead of Linear — this and comments (see sibling issue) were the two blocking gaps.

---

Linear DEV-883 · MCP Server · created 2026-07-07 · done 2026-07-07