---
id: 01M7DGKVHPYTNT9WZBFKGA1MY3
created: 2026-11-14T17:10:23.54208Z
updated: 2026-11-14T17:10:29.588503Z
type: task
title: All checks' Controls column opens the control's page, not its assessment
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1833
sprint: spsp226
assignee: steve
label:
- bug
priority: low
task_status: todo
---
## What happened

Seen in Claude's pre-UAT pass on staging (53965a3b, 2026-11-14), E2E Test Company. On Checks ▸ All checks, the control links in the Controls column (e.g. ACC.13) open `/assessments/ACC.13`, the company's assessment of that control, rather than the control's own page. Not caused by sprint 116's work.

## What people see

- Clicking a control in All checks' Controls column opens the control's page (where its Evidence tab, with this check, lives), the same as other control links in Checks.
- If the assessment is still wanted from here, it's reachable from the control's page as today.

## Done when

- ACC.13 in All checks' Controls column opens the control's page for the company.
- The other places Checks links to a control (Overview side panel, a check's page) are checked for the same thing and agree.
- The Browser smoke still passes.

**Independent.** Not started; logged at Steve's request on 2026-11-14.