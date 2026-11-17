---
id: 01M7K97GD8SHJRJ9MHFEJRDDR5
created: 2026-11-16T22:56:45.480945Z
updated: 2026-11-17T00:33:36.419132Z
type: task
title: 'Workflow IDs: WF-n becomes WFL-n'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1891
sprint: s7nqsy0
assignee: steve
priority: medium
task_status: active
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