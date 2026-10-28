---
id: 01M5YAEM77WFFFT1FKV4E180D0
created: 2026-10-27T09:18:22.43957Z
updated: 2026-10-28T18:16:47.85835Z
type: task
title: The Dashboard and the vulnerability-management controls show the register's figures — critical and high open, overdue and days to fix — so an assessment is judged against what's really there
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1387
sprint: svnkdj7
blocked_by:
- 01M5YA88GK0JWX1SGY1TX762TB
- 01M5YAEBVKEGRZYSZ3VYCKVHK9
comments:
- id: 01M611HANT4F9E630QKYGQK3NC
  author: Steve Vine
  at: 2026-10-28T10:40:17.082365Z
  text: |-
    Done — PR #1405 merged to main (376b7aa0). Deploying to staging with the rest of the sprint.

    What you'll see
    - Dashboard: a Vulnerabilities card (needs view vulnerabilities) — critical and high open, overdue, a 90-day sparkline of the critical-and-high count (gaps where no figures were kept), and "Open →" to the Overview.
    - Assessments of the controls below: a "What the register shows" section under "Evidence of operation" — open by severity, overdue against the fix-by targets, average days to fix over 90 days, and which sources have read in the last 30 days ("Nessus: last read 3 days ago"; "AWS: nothing read in the last 30 days (last …)"; "No pen test recorded this year" / "Pen test: last tested …"), with links to the Register. It says the assessor weighs it; Compass doesn't score the control. Needs view vulnerabilities.
    - Vulnerabilities ▸ Overview: "Save today's figures as evidence" (Manage evidence) — a PDF of the day's figures in Audit ▸ Evidence, classified Internal, linked to those controls, with a link to it once saved.

    Controls chosen, by key (please confirm):
    - PAM.1, PAM.2, PAM.3, PAM.4 — patching (shown as VUM.1–VUM.4 since the renumber)
    - VUM.1 internal scanning, VUM.2 external scanning
    - VUM.3 external pen tests, VUM.8 internal pen tests
    - VUM.4 the vulnerability management process, VUM.5 severity rating
    - VUM.10 mitigation where a vulnerability can't be fixed
    Left out on purpose: dev-side scanning (SOD.2, s42.SOD.2 dependencies, s42.CLD.5 container images, s42.SOD.3 secrets) and threat intelligence/threat modelling — easy to add.

    My calls
    - The list is kept in the code by key rather than as a new column in the controls file — same effect, no change to the seed data.
    - "Lately" = 30 days; pen test = one confirmed this calendar year.
assignee: steve
label:
- feature
priority: medium
task_status: done
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