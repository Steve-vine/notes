---
id: 01M3ST0FF1P8KQ0DT1942KYQER
created: 2026-09-30T18:42:40.225944Z
updated: 2026-09-30T18:47:03.595265Z
type: task
title: A control can't be marked out of scope without saying why
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 800
sprint: s0zzctz
blocked_by:
- 01M3SSXGXPWVAWH64CKQR6KE1Z
assignee: steve
label:
- improvement
priority: medium
task_status: backlog
---
Part of sprint 65, UI Upgrade (ADR in COM-794). The prototype says a reason is required when a control is out of scope, and Steve confirmed it on 2026-09-30. Today the reason is optional, so a control can drop out of a company's figures with nothing to say why.

## What people see

- **Turning "In scope" off opens a "Why is it out of scope?" box, which must be filled in.** Saving without a reason stops at the box with "Say why this control is out of scope."
- **A reason of only spaces doesn't count.**
- **Existing out-of-scope assessments without a reason stay as they are.** The next time someone edits one, they must add a reason to save it.
- **The rule holds everywhere an assessment is saved:** the Assessments screen, and the API for anything else that writes one.

## Notes (technical)

- **API.** `AssessmentUpsert` (`api/v1/schemas.py` ~3304) gains a validator: when `applicable` is false, the justification field must be non-blank after stripping. Otherwise return 422 with the message above.
- **No migration.** Existing rows are untouched. Say so in the PR.
- **Frontend.** `AssessmentPanel.tsx` marks the justification as `required` when out of scope and shows the server's error on the field. Use the submit-then-explain pattern the other forms use: no disabled Save.
- **Check the other writers.** Any other writer of assessments (bulk tools, seeders, imports) must respect the rule, or be listed in the PR as exempt with the reason.
- **Tests:**
  - integration tests for a 422 on blank or whitespace, 200 with a reason, and 200 for an unrelated edit to an in-scope assessment;
  - a vitest for the field error.

**Done when:** on staging, marking a control out of scope without a reason won't save, and saving with a reason works.