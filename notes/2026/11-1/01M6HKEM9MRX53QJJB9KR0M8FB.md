---
id: 01M6HKEM9MRX53QJJB9KR0M8FB
created: 2026-11-03T21:01:13.908398Z
updated: 2026-11-03T21:01:22.202019Z
type: task
title: Polaris and initiatives — MCP tools to list and read initiatives with their progress and actions, start one, add or remove controls and items, leave out and put back, mark Requires review, and finish or reopen
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1562
sprint: snyzymp
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint "Initiatives - New Feature" (ADR 0140, COM-1552). Builds on COM-1561. It follows the MCP pattern from sprints 70–74, where tools are auto-discovered.

## What Polaris can do

Each tool works as the connected person, with exactly their permissions.

- **Reading:**
  - `initiatives_list`: name, owner, target, percentage, open actions, status; filter mine / active.
  - `initiatives_get`: the header, the progress breakdown, and each kind of item with its owner, status, where it came from, counted or not, and done or not.
  - `initiatives_list_actions`: the initiative's open actions, as the Actions tab shows them.
- **Starting and editing:**
  - `initiatives_start`;
  - `initiatives_update` (name, description, owner, target).
- **Shaping:**
  - `initiatives_add_controls`, with a Requires review flag and due date;
  - `initiatives_remove_control`;
  - `initiatives_add_item` (risk, decision, content);
  - `initiatives_remove_item`;
  - `initiatives_leave_out`, with a reason;
  - `initiatives_put_back`;
  - `initiatives_mark_review` and `initiatives_unmark_review`.
- **Finishing:**
  - `initiatives_finish` (complete or cancel, with a note);
  - `initiatives_reopen`.
- **Working the items** uses the existing posture and playbook tools. `posture_add_risk` and `posture_create_decision` take an optional initiative.
- **What tools return.** Answers name items by reference (INI-3, G-41, R-12, D-9) as the screen does. Text other people wrote (names, descriptions, notes) comes back marked as data, like the other modules.
- **Before acting.** Marking for review puts work on someone else's list, so the tool description tells Polaris to say whose before it calls.

## Notes (technical)

- Put the tools in a new `mcp/tools/initiatives.py`, calling the same core functions as the API. No logic is duplicated.
- Update the tool count tests.
- Add a line on Initiatives to the server instructions.

**Chain:** on the chain (API: initiative on two existing tools).

**Done when:** on staging, Polaris, as admin in E2E Test Company:
- answers "how far along is INI-1 and what's left?" with the percentage and the open actions;
- adds a control with Requires review, after saying whose list it lands on.