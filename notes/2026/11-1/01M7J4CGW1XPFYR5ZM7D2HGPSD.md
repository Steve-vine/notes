---
id: 01M7J4CGW1XPFYR5ZM7D2HGPSD
created: 2026-11-16T12:12:52.481023Z
updated: 2026-11-16T14:27:57.350029Z
type: task
title: 'Check page: "How it''s judged" becomes "Workflows" — a list of every workflow that uses the check (ID, name, status, last run), and workflows get IDs'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1869
sprint: s7nqsy0
comments:
- id: 01M7JC3HQ7XBYY3YKS5TPGAEE6
  author: Steve Vine
  at: 2026-11-16T14:27:47.047733Z
  text: |-
    Done — PR #1863, merged to main (e133da14). Not on staging yet. ADR 0155 amended.

    - Every workflow has an ID within its company, WF-n, like CHK-n. Existing workflows are numbered in the order they were made, new ones take the next number, and a number is never reused.
    - The ID shows on Automation ▸ Workflows, at the head of each workflow's page and on each run. Polaris names workflows by it and accepts it ("change WF-3").
    - On the check's page, "How it's judged" is now Workflows: a table of every workflow that uses the check (in its trigger or a condition), showing ID, Name, Status and Last run (when and outcome, or "Never"). Each row opens the workflow. The sentence, old rule wording and Build a workflow are gone. With no workflows it says "No workflow uses this check."
    - The control's Evidence tab card keeps its "Judged by" line and Build a workflow, since only the check page was asked to drop them. Its links now read "WF-n · name".

    To check on staging: CHK-26's page should list "Compliant workflow for CHK-26" (and Gaps from evidence if it names the check) with IDs and last run. Automation ▸ Workflows should show WF numbers.
assignee: steve
label:
- improvement
priority: medium
task_status: review
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