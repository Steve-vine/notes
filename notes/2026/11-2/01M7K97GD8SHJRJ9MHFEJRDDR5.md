---
id: 01M7K97GD8SHJRJ9MHFEJRDDR5
created: 2026-11-16T22:56:45.480945Z
updated: 2026-11-17T19:50:15.449758Z
type: task
title: 'Workflow IDs: WF-n becomes WFL-n'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1891
sprint: s7nqsy0
comments:
- id: 01M7KJC4665NTHFQ2H7DQT73FM
  author: Steve Vine
  at: 2026-11-17T01:36:33.990313Z
  text: |-
    Done — PR #1882, merged e2b3f3fe.
    Every workflow now reads WFL-n with its old number. That covers Automation ▸ Workflows (the ID column still sorts by number), the workflow page and builder, a check's Workflows panel, runs, evidence-status explanations, Activity from now on, and Polaris. Each company's new workflows carry on as WFL-(next).
    WF-n still finds the workflow: given to Polaris ("change WF-3"), or in the address. /automation/workflows/WF-3 opens WFL-3 in the company you're in and moves to the workflow's own address.
    Gap text and Activity lines already written keep "WF-n". ADR 0155 has a dated note and ADR 0157 lists WFL.
    Assumptions: no migration, because a workflow's number is unique within its company and the old prefix is read. An address with a workflow ID opens it in the company you're in, since each company numbers its own.
    Small fix on the way: the workflow page no longer briefly treats its workflow as another company's while your company is still loading.
    To check on staging: Automation ▸ Workflows reads WFL-n and sorts by number; open /automation/workflows/WF-<n>; ask Polaris "read WF-<n>". Staging check: all 14 workflow numbers are unique within their companies. Before release, run the same check on a copy of production.
- id: 01M7MGZ5EXXB84MJK4NJPY8QDH
  author: Steve Vine
  at: 2026-11-17T10:31:15.165671Z
  text: |-
    Pre-UAT on staging 44d15b9a — Passed
    - Every workflow reads WFL-n with its old number: Passed. As E2E Admin A:
      - Automation ▸ Workflows shows WFL-1…WFL-9 in the ID column. Sorting by ID goes WFL-9…1 on one click and back to 1…9 on the next.
      - The workflow page reads WFL-3, and check CHC-2's Workflows panel lists WFL-2, 3, 6, 7 and 8.
      - Polaris answers with WFL-n in list_workflows and get_workflow, and explain_evidence_status says "WFL-1 · Gaps from evidence".
    - WF-n still resolves: Passed. In the address, as Admin A and the Viewer, /automation/workflows/WF-3 opens WFL-3, and WF-1 and WF-9 open WFL-1 and WFL-9; each page moves to the workflow's own address. Polaris's get_workflow "WF-3" answers WFL-3. The main search finds no workflow by either WF-3 or WFL-3: workflows were never part of search, as the Done comment says.
    - New workflows are WFL-(next): Passed. Admin A created "E2E pre-UAT COM-1891 workflow", which became WFL-9 (Disabled) and shows in the list with 1 problem, because it's empty.
    - ADR 0155 note and ADR 0157: Passed. ADR 0155 has the 2026-11-17 amendment "workflow IDs read WFL-n", and ADR 0157 has the WF- → WFL- row.
    - Switch-over check on a copy of production: Couldn't check on staging, because it's a step before release.
    - Tests: PR #1882 changes 10 test files. No app/e2e selector reads a workflow ID.
    Screenshots: ~/compass-uat/s7nqsy0/COM-1891/
    Left behind: WFL-9 "E2E pre-UAT COM-1891 workflow", Disabled (there's no delete).
assignee: steve
priority: medium
task_status: done
---
From Steve's testing of round 2 (staging 43d03f09): every reference should be three letters, a dash and a number. Workflows have been **WF-n** since COM-1869.

**Behaviour.** This works the same way as COM-1887 (risks and gaps) and COM-1886 (checks):
- WF-7 becomes **WFL-7**, keeping its number, and the counter carries on.
- The new form shows everywhere an ID is shown:
  - Automation ▸ Workflows (the ID column and its sort);
  - the workflow page and builder;
  - a check's Workflows section;
  - gap text ("Raised by workflow WFL-3: <name>");
  - evidence status explanations;
  - Activity from now on;
  - Polaris's workflow tools, answers and MCP instructions.
- Old WF-n IDs still find the workflow in the address, in search and through Polaris, and old links redirect.
- Text written before the change keeps its wording, including gap text already written.

**Done when**
- On staging, every workflow reads WFL-n with its old number, and WF-n still resolves.
- New workflows are numbered WFL-(next).
- An ADR 0155 note, and the three-letter reference ADR (from COM-1887), record WFL.
- The switch-over is checked on a copy of production data before release.
- Tests cover formatting, old IDs resolving, a new workflow, the Workflows list sort, and the e2e selectors.

**Where** (for the builder): models/workflow.py (`WORKFLOW_REF_PREFIX`), core/workflows (gap wording, explanations), the route or search that resolves an ID, frontend pages/WorkflowsPage.tsx, WorkflowPage.tsx and the check page's Workflows section, assistant/tools and MCP instructions. Built after COM-1887.