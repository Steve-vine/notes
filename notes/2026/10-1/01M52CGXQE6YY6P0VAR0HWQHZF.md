---
id: 01M52CGXQE6YY6P0VAR0HWQHZF
created: 2026-10-16T12:55:50.766172Z
updated: 2026-10-21T09:36:15.755303Z
type: task
title: Reorder roadmap sprints
project: 01KY6W9951TW0904DT0GGJVGE7
number: 547
sprint: sd52non
comments:
- id: 01M5EX2X7XJNNRY4P8HGWRJV9H
  author: Steve Vine
  at: 2026-10-21T09:36:10.492433Z
  text: 'Merged to main as #541 (brief-547-reorder-roadmap-sprints). Each sprint linked to a roadmap entry on a project/initiative note now has a grip (shown on hover); dragging it reorders the sprint within that entry''s list, using the NOT-546 pointer row drag with an insertion line. The order is the entry''s list order, which set_roadmap already persists (ADR 0072) — no backend change. NoteDoc.moveRoadmapSprint is unit-tested. Not yet seen in-app: worth a quick pass — drag a linked sprint up/down, reload, and confirm the order sticks and the Roadmap chart (date-sorted) is unaffected.'
assignee: steve
priority: medium
task_status: review
tech: null
---
Add the ability to reorder sprints in roadmaps in the project note.