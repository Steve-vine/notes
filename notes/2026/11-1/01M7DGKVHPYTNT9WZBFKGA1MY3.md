---
id: 01M7DGKVHPYTNT9WZBFKGA1MY3
created: 2026-11-14T17:10:23.54208Z
updated: 2026-11-14T18:55:11.265229Z
type: task
title: All checks' Controls column opens the control's page, not its assessment
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1833
sprint: spsp226
comments:
- id: 01M7DPKMRWW19DKTXXW5J6QSME
  author: Steve Vine
  at: 2026-11-14T18:55:08.059832Z
  text: |-
    Built and merged: PR #1828, main edbde4e9.

    Cause: three places linked a control (e.g. ACC.13) to the company's assessment of it: All checks' Controls column, a check's own page, and a no-rule collected check's page. The Overview side panel and the Review tab already opened the control's own page.

    Now:
    - Every place Checks links to a control opens the control's page for the company, at its Evidence tab (where the check is).
    - On a no-rule check's page, the separate "its Evidence tab" link is gone, because the control's ref now goes there itself.
    - The assessment is still one click away from the control's page.
    - Left as it was: the control heading on a Review card opens the control's page on its default tab, which an existing test expects (COM-1803).

    Tests: Vitest checks that the link goes to the control's Evidence tab from the All checks Controls column, a check's own page and a no-rule check's page. No Browser smoke spec asserted the old link, so none needed changing. The smoke runs on the staging deploy.
assignee: steve
label:
- bug
priority: low
task_status: review
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