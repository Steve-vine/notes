---
id: 01M6HKEM9MRX53QJJB9KR0M8FB
created: 2026-11-03T21:01:13.908398Z
updated: 2026-11-04T00:22:41.467779Z
type: task
title: Polaris and initiatives — MCP tools to list and read initiatives with their progress and actions, start one, add or remove controls and items, leave out and put back, mark Requires review, and finish or reopen
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1562
sprint: snyzymp
blocked_by:
- 01M6HKE6Y2BKMFX4SRHQDVDBHE
comments:
- id: 01M6HYY6PJV4YP9A6K2XWK5GCT
  author: Steve Vine
  at: 2026-11-04T00:21:58.610401Z
  text: |-
    Done: PR #1576 merged (9c0b06a2).

    What's there: Polaris has sixteen initiatives tools. Each calls the same API the screen does, as the connected person.
    - **Read:** list, get (owner, target, progress by kind, controls with review marks, and each item with its owners, "via", counted and done, left-out items apart) and list actions (with "counts").
    - **Start and edit:** start (the owner defaults to the caller) and update.
    - **Shape:**
      - add or remove controls (with Requires review);
      - add an item directly, or remove one;
      - leave out or put back;
      - mark or unmark for review.

      The review tools tell Polaris to say whose list the review lands on first.
    - **Finish and reopen.** Finishing is a sign-off, so Polaris asks first.
    - **Its instructions** now describe Initiatives, and the in-app window offers these tools on /initiatives pages.

    My call:
    - **posture_add_risk and posture_create_decision didn't get an initiative argument.** initiatives_add_item does the same in one more call, without widening two tools other areas rely on.
- id: 01M6HYZGHV3SSXBKN5C0VMZ7AS
  author: Steve Vine
  at: 2026-11-04T00:22:41.467593Z
  text: |-
    Pre-UAT (staging 9c0b06a2, 2026-11-04): **Passed** for reading; **Couldn't check** for writing through the in-app window.

    What I saw:
    - Polaris answered "INI-1" from staging: 10% complete (3 of 30 counted), with Gaps 2/27, Treatment 0/2 and Reviews 1/1, and every item with its owners, "via INS.10", and to do or done.
    - The 16 initiatives tools appeared on the Compass connection as soon as the build was live.

    For you to look at: in the Polaris window on an initiative's page, ask it to add a control with Requires review. It should say whose Actions list the review lands on before it acts.
assignee: steve
label:
- feature
priority: medium
task_status: review
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