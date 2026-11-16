---
id: 01M7J4CGW1XPFYR5ZM7D2HGPSD
created: 2026-11-16T12:12:52.481023Z
updated: 2026-11-16T12:12:52.481023Z
type: task
title: 'Check page: "How it''s judged" becomes "Workflows" — a list of every workflow that uses the check (ID, name, status, last run), and workflows get IDs'
label: improvement
priority: medium
assignee: steve
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1869
---
Asked for by Steve while testing sprint "Automation - Workflows" on staging (2026-11-16).

## Today

The check page's "How it's judged" panel has:
- an explanatory sentence;
- the workflows as a row of name links;
- the old pass/fail rule's wording;
- Build a workflow.

Workflows have no ID.

## Done when

- **Workflows get an ID within their company,** WF-n, the way checks have CHK-n. Existing workflows are numbered in the order they were created, and an ID is never reused. The ID shows on Automation ▸ Workflows (list and page). Polaris names workflows by it and accepts it ("change WF-3").
- **The check page's panel is called Workflows** and holds only a table of every workflow that uses the check, in its trigger or in a condition. Each row is linked to the workflow's page:
  - **ID**, e.g. WF-3;
  - **Name**;
  - **Status**: Enabled or Disabled;
  - **Last run**: when it last ran (on any evidence), with its outcome (met, not met, failed). "Never" if it hasn't run.
- The explanatory sentence, the old rule's wording and the Build a workflow button are removed. With no workflows, the panel says "No workflow uses this check."
- Tests cover numbering (existing workflows are backfilled, new ones take the next number, numbers aren't reused), and the table lists workflows found by trigger and by condition, with their last run.

On the chain (a migration and API changes).