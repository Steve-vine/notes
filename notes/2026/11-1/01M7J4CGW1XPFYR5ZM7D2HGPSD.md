---
id: 01M7J4CGW1XPFYR5ZM7D2HGPSD
created: 2026-11-16T12:12:52.481023Z
updated: 2026-11-16T23:03:23.14945Z
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
- id: 01M7JEC0KXN3VESEEZ2T2MNTCF
  author: Steve Vine
  at: 2026-11-16T15:07:21.597466Z
  text: |-
    **Pre-UAT: Passed** (staging 43d03f09, E2E Test Company, E2E Admin A). Two items couldn't be seen here.

    Steps and what I saw:
    - Automation ▸ Workflows lists WF-1 to WF-6, numbered in the order they were made. New workflows I saved today took WF-7 and WF-8.
    - A workflow's page shows "WF-7" at its head.
    - Polaris accepts the ID: reading "WF-8", "WF-2" and "WF-6" by ID through Polaris on staging returned each with "id": "WF-n".
    - CHK-2's page: the panel is now "Workflows", a table with ID / Name / Status / Last run, each row linking to the workflow. It lists:
      - WF-2, WF-3, WF-6 and WF-8, which name CHK-2 in their trigger;
      - WF-7, which names CHK-2 only in a condition.
      Status shows Enabled or Disabled, and Last run "Never". The explanatory sentence, the old rule's wording and Build a workflow are gone from this page.
    - ACC.13's Evidence tab card keeps "Judged by" with links reading "WF-n · name", as the Done comment says.

    Not covered:
    - A last run with an outcome: none of CHK-2's workflows have run, since it can't collect.
    - "No workflow uses this check.": E2E's only collected check has workflows.

    Steve to look at CHK-26's page in Test Company.

    Screenshots: ~/compass-uat/s7nqsy0/COM-1869/ (chk2-workflows-table.png), ~/compass-uat/s7nqsy0/COM-1863/chk2-page-history-status-column.png (shows the table with WF-7/WF-8), ~/compass-uat/s7nqsy0/COM-1871/workflows-default-id-asc.png
assignee: steve
label:
- improvement
priority: medium
task_status: done
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