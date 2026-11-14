---
id: 01M7DFKFR3A01S0DCTGKSPA14G
created: 2026-11-14T16:52:42.883188Z
updated: 2026-11-14T16:52:47.223772Z
type: task
title: A collected check that has a rule shows its next capture on its own page, and its can't-read line uses the card's words with a full stop
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1831
sprint: spsp226
assignee: steve
label:
- bug
priority: low
task_status: active
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