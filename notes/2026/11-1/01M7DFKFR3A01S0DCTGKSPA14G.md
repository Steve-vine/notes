---
id: 01M7DFKFR3A01S0DCTGKSPA14G
created: 2026-11-14T16:52:42.883188Z
updated: 2026-11-14T17:42:11.385977Z
type: task
title: A collected check that has a rule shows its next capture on its own page, and its can't-read line uses the card's words with a full stop
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1831
sprint: spsp226
comments:
- id: 01M7DGNT8YMV8JGTBKKBEFZ2CF
  author: Steve Vine
  at: 2026-11-14T17:11:27.774516Z
  text: |-
    Built — PR #1826 (04843637), auto-merge on. No API, schema or migration change.

    What you now see: a collected check with a pass/fail rule (All checks ▸ CHK-2) shows "Collected: weekly · next 21 Nov 2026" on its own page, or "Collected: weekly · next: due now" once the capture has come (the card's words); a switched-off check shows just "Collected: weekly". Its can't-read line reads "The check can't read: The Collection integration this check reads was deleted. The read isn't allowed any more: ask Polaris to re-create the check." — the card's error line, with full stops, laid out like the no-rule page. The reason under "Rule … Can't tell" in the card's Details is fixed the same way (corrected where Compass hands it out), so results saved before the rewording read right without being re-judged.

    Choices: where a saved can't-read reason meets a check that has an error now, today's error wording is used; where the check reads again, the saved wording keeps with a full stop added; other reasons ("All 4 users meet the rule") are left as saved. The check's Changes list keeps past events exactly as recorded, so an old "can't tell — That Collection integration doesn't exist" entry stays as it was.

    Tests: unit 2428 passed; collection rules (incl. a new test), control checks API, check ids, hold and switch-on integration tests passed; full vitest 4,189 passed; ruff/mypy/eslint/tsc/prettier clean.
- id: 01M7DJE2NS2GEAFEM8PFG8217Y
  author: Steve Vine
  at: 2026-11-14T17:42:11.385802Z
  text: |-
    Pre-UAT check on staging 816a380d (E2E Test Company, Admin A): **Passed**.

    CHK-2's own page (All checks ▸ CHK-2): "Collected: weekly · next 21 Nov 2026" (the 16:41/17:41 hourly runs had moved it on from due now — a correct future date), and "The check can't read: The Collection integration this check reads was deleted. The read isn't allowed any more: ask Polaris to re-create the check." The rule line in the card's Details on ACC.13 ▸ Evidence now reads "The check can't read: The Collection integration this check reads was deleted." — full stop, the card's words. The card itself still reads "last collected 6 Nov 2026, 12:21 · next 21 Nov 2026" and its full error line. The Changes list keeps past events as recorded. Screenshots ~/compass-uat/spsp226/COM-1831/.
assignee: steve
label:
- bug
priority: low
task_status: review
---
## What happened

Claude's re-check of COM-1830 on staging 4bdc9be2 (2026-11-14, E2E Test Company, Admin A). CHK-2's card on ACC.13 ▸ Evidence and Polaris read correctly ("next: due now"; "The Collection integration this check reads was deleted. The read isn't allowed any more: ask Polaris to re-create the check."). But **CHK-2's own check page** (Checks ▸ All checks ▸ CHK-2) — a collected check that has a pass/fail rule — has:

1. **no next-capture line at all**; and
2. a line reading "The check can't read: That Collection integration doesn't exist" — no full stop, and different words from the card. The same text shows under "Rule … Can't tell" in the card's Details. It comes from the check's stored result (`check.reason` from `GET /api/v1/checks/collected:<id>`).

COM-1830 changed only the page for a check with no rule (`NoRuleCheckPage`); a check with a rule opens the normal check page, which wasn't touched.

Screenshots: ~/compass-uat/spsp226/COM-1830/COM-1830-uat-03-check-page.png.

## What people see

- A collected check's page shows "Collected: weekly · next …" (or "next: due now") whether or not it has a rule, with the same words as its card.
- Its can't-read line reads as a sentence with a full stop, and says the same as the card's error line. The reason under the rule in the card's Details does too.

## Done when

- CHK-2's page shows its next capture ("next: due now" or a date) and a full-stopped can't-read line matching the card.
- Vitest for the check page of a collected check with a rule; a unit test for the stored reason's wording if it's made in the backend.

**Independent.** Follow-up to COM-1830.