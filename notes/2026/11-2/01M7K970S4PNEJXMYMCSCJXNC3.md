---
id: 01M7K970S4PNEJXMYMCSCJXNC3
created: 2026-11-16T22:56:29.476481Z
updated: 2026-11-16T22:57:06.834791Z
type: task
title: 'Decision record IDs: D-n becomes DEC-n'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1888
sprint: s7nqsy0
assignee: steve
priority: medium
task_status: backlog
---
From Steve's testing of round 2 (staging 43d03f09): every reference should be three letters, a dash and a number. Decision records (the playbook's, shared by every company) are **D-n** today.

**Behaviour.** This works the same way as COM-1887 (risks and gaps) and COM-1886 (checks):
- D-7 becomes **DEC-7**, keeping its number, and the counter carries on.
- The new form shows everywhere an ID is shown:
  - the Decisions list and page;
  - every link to a decision (risks, controls, exceptions, incidents);
  - exports and packs from now on;
  - Polaris's tools, answers and MCP instructions.
- Old D-n IDs still find the record in the address, in search and through Polaris, and old links redirect.
- Text written before the change keeps its wording.

**Done when**
- On staging, every decision record reads DEC-n with its old number, and D-n still resolves.
- New decision records are numbered DEC-(next).
- The three-letter reference ADR (from COM-1887) lists DEC.
- The switch-over is checked on a copy of production data before release.
- Tests cover formatting, old IDs resolving, a new record, and the e2e selectors.

**Where** (for the builder): models/decision_record.py (`DECISION_REF_PREFIX`), the route or search that resolves an ID, frontend decision pages, assistant/tools (posture decisions) and MCP instructions. Built after COM-1887.