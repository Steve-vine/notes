---
id: 01M5YAEM77WFFFT1FKV4E180D0
created: 2026-10-27T09:18:22.43957Z
updated: 2026-10-28T09:13:57.670097Z
type: task
title: The Dashboard and the vulnerability-management controls show the register's figures — critical and high open, overdue and days to fix — so an assessment is judged against what's really there
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1387
sprint: svnkdj7
blocked_by:
- 01M5YA88GK0JWX1SGY1TX762TB
- 01M5YAEBVKEGRZYSZ3VYCKVHK9
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Sprint 93, Vulnerabilities - Cloud sources (ADR amendment in COM-1382). The last task across the three Vulnerabilities sprints.

Compass holds the playbook and measures reality against it. This task connects the two for vulnerabilities.

## What people see

- **Dashboard** (company posture): a **Vulnerabilities** card with:
  - critical and high open;
  - overdue;
  - the 90-day trend as a sparkline;
  - a link to the Overview.
  - Shown to people who can view vulnerabilities.
- **The controls that cover vulnerability management and patching**, and the pen-testing and scanning controls:
  - on a company's assessment of one of them, a **"What the register shows"** panel:
    - open by severity;
    - overdue against the fix-by rubric;
    - average days to fix in the last 90 days;
    - which sources have reported in the last 30 days, e.g. "Nessus: last scan 3 days ago; no pen test recorded this year";
  - with a link to the filtered Register.
  - The assessor still sets status and maturity. Compass doesn't score the control itself.
- **Audit ▸ Evidence:** a one-click **"Save today's vulnerability figures as evidence"** on the Overview. It saves a PDF of the Overview, classified Internal and linked to those controls, for an auditor.

## Who can do what

- The Dashboard card and the assessment panel need view vulnerabilities.
- Saving as evidence needs whoever can add evidence today.

## Notes (technical)

- Which controls get the panel: tag them in the controls data (a `shows_vulnerabilities` flag in `controls.csv`, looked up by `CoreControl.key`, not Control ID), chosen from the VM/patching/testing controls.
- List the chosen keys in the Done comment for Steve to confirm.
- The PDF through the existing document writer (ADR 0110).

**Chain:** on the chain (seed data + API).

**Done when:**
- the Dashboard card and the assessment panel show true figures;
- the evidence PDF saves and links to the controls;
- the control list is in the Done comment.