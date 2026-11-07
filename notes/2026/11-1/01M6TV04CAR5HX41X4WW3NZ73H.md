---
id: 01M6TV04CAR5HX41X4WW3NZ73H
created: 2026-11-07T11:06:17.354284Z
updated: 2026-11-07T11:06:23.055295Z
type: task
title: 'Assessment: a "Not assessed" status, first in the list, that clears a control''s assessment'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1634
sprint: sp69tt3
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Once a control has a status (Not implemented, Partial, Implemented) there's no way back to "not assessed". Steve (2026-11-07): add **Not assessed** as the first status button. It means the same as a control never assessed, so an assessor can clear an assessment after a significant change. Choosing it also removes the maturity score.

**Wanted behaviour:**
- The assessment box's status buttons read: **Not assessed** · Not implemented · Partial · Implemented. Not assessed wears the same grey as the "Not assessed" chip.
- Choosing Not assessed clears the maturity: the maturity buttons empty and can't be picked while Not assessed is chosen. Saving stores no status and no maturity.
- After saving, the control counts as **not assessed everywhere** exactly as one never assessed does: the progress card and its chips, the list's status column, "Assess next unassessed", compliance and coverage, the Statement of Applicability, reports and exports, audits, initiatives, Polaris and the MCP tools.
- Nothing is lost: History keeps every earlier assessment, and the clearing shows as its own entry ("Not assessed", who, when, notes).
- Assumption (Steve to correct): evidence, notes, owner and scope stay on the control so they're there when it's reassessed; only status and maturity are cleared.
- Gaps already raised stay open (they're still true); raising a new gap needs an assessed control, as today.
- On a control never assessed, Not assessed is shown chosen.
- Polaris's assessment tool can set Not assessed too, with the same effect.

**Done when:** in E2E Test Company, a control assessed Partial at maturity 2 is set to Not assessed and saved; its maturity is gone; the list shows it Not assessed; the progress card's assessed count drops by one; "Assess next unassessed" can reach it; its History shows the Partial entry and then the Not assessed one; reassessing it as Implemented works.

**Implementation:** decide the model in the PR. Either a cleared assessment keeps its row with a null/`not_assessed` status (one history thread, but every "assessed?" check that today means "a row exists" must learn the new state), or clearing soft-deletes the row (counts just work, but History and evidence links are keyed on the assessment id and would restart on reassessment). History must survive either way. Grep for every reader of assessment status / row existence (coverage.py, compliance, SoA, audit findings `not_assessed`, initiatives, exceptions, checks "disagree with status", Polaris/MCP posture tools, reports, CSV export) and cover them with tests. Frontend: `STATUS_OPTIONS`/`StatusButtons` in `AssessmentPanel`, `statusNames.ts`, `statusColors.ts`. Mind [[alembic-enum-reuse]] / new-enum-value rules if the enum grows.

**On the chain:** changes the API, likely a migration.