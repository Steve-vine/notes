---
id: 01M6TV04CAR5HX41X4WW3NZ73H
created: 2026-11-07T11:06:17.354284Z
updated: 2026-11-08T09:00:06.130271Z
type: task
title: 'Assessment: a "Not assessed" status, first in the list, that clears a control''s assessment'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1634
sprint: sp69tt3
comments:
- id: 01M6V0PBS4VDT8H5F1PBWCSJV4
  author: Steve Vine
  at: 2026-11-07T12:45:48.708648Z
  text: |-
    Done: PR #1653, merged to main as adab90b9.

    What changed: Not assessed is now the first status button, and it's the one shown chosen on a control nobody has assessed. Choosing it clears the maturity, and the maturity buttons stay greyed out until you pick a status. Saving it:
    - keeps the assessment's history, notes, owner, scope, evidence and any gaps already raised. History shows the earlier versions, then "Not assessed" as its own entry.
    - counts the control exactly as never assessed everywhere: Dashboard and compliance figures, coverage, the Statement of Applicability, What changed, the Assessments list ("Assess next unassessed" reaches it), audits and audit packs, initiatives, the plan's controls, and Compass's own checks (no automatic gap).
    - sets no review date and doesn't count as a review an initiative asked for.
    - assessing it again carries on the same history (v3 after v1 and v2, not a fresh v1).
    A new gap can't be raised against it until it's assessed again. Polaris can read it and set it.

    How: a new "not assessed" status kept on the record (database change 0794), rather than deleting the record, because history, evidence and gaps all hang off it.

    Your assumption held: evidence, notes, owner and scope stay; only status and maturity are cleared.

    Tested: a new backend test covering clear, history kept, gap refused, every figure equal to never-assessed, and reassess on the same history; out of scope still wins over Not assessed; panel and list tests. Backend unit suite and the related integration tests green locally and in CI.
assignee: steve
label:
- improvement
priority: medium
task_status: done
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