---
id: 01M7DBWMV7KR4A5W2FH7YWVRMA
created: 2026-11-14T15:47:48.711274Z
updated: 2026-11-14T16:52:33.316536Z
type: task
title: 'A check whose next capture is already due reads "next: due now" instead of a date in the past, and its error line puts a full stop between sentences'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1830
sprint: spsp226
comments:
- id: 01M7DD16CDJ9VR26S1XDWJE1X6
  author: Steve Vine
  at: 2026-11-14T16:07:46.317033Z
  text: |-
    Built — PR #1824 (db91ed03), auto-merge on. No API shape or migration change.

    What you now see: once a live check's next capture has already come, its card on a control's Evidence tab and its check page read "next: due now" instead of a past date (CHK-2, Weekly, last captured 6 Nov, reads "next: due now" on 14 Nov); Polaris says "due now" too (get check, how collected, and after a schedule change). Future captures read as before. The error line has a full stop between sentences ("The Collection integration this check reads was deleted. The read isn't allowed any more: ask Polaris to re-create the check."), on the card and the check page; a Checks row's "The check can't read: …" reason ends with a full stop too.

    Choices: the backend's next-capture words say "due now" for any schedule once the date has passed, and the card/check page also work it out in the browser so an open page flips without a reload; the check page now uses the card's wording (a quarterly/yearly check's page reads "next early April …", not a bare date); the error is made a sentence when Compass hands it out, not when stored, so existing broken checks like CHK-2 are fixed with no migration.

    Tests: backend unit 2417 passed; 29 integration passed; full vitest 4,181 passed; ruff/mypy/eslint/tsc/prettier clean; drift OK.
- id: 01M7DFK6D4ZKEWGC8EPRFG5E8G
  author: Steve Vine
  at: 2026-11-14T16:52:33.316274Z
  text: |-
    Pre-UAT re-check on staging 4bdc9be2 (E2E Test Company, Admin A): **Failed on one part** → small fix in a new task.

    Passed: CHK-2's card on ACC.13 ▸ Evidence reads "last collected 6 Nov 2026, 12:21 · next: due now" and the error line "The Collection integration this check reads was deleted. The read isn't allowed any more: ask Polaris to re-create the check."; Polaris (get check) returns next_capture "due now" and a full-stopped broken line. (The 16:41 hourly run had moved it to 21 Nov; Daily → Weekly recounted it to due now.)

    Failed: CHK-2's own check page (All checks ▸ CHK-2) has no next-capture line at all, and its line reads "The check can't read: That Collection integration doesn't exist" — no full stop, different words from the card (the same unpunctuated text is under "Rule … Can't tell" on the card). Likely: the PR changed only the no-rule check page; CHK-2 has a rule. Screenshots ~/compass-uat/spsp226/COM-1830/.
assignee: steve
label:
- bug
priority: low
task_status: review
---
## What happened

Claude's re-check on staging 55b58a1b (2026-11-14, E2E Test Company, Admin A):

1. After CHK-2 (ACC.13) was set back to Weekly, its card read **"next 13 Nov 2026"** on 14 Nov — a date in the past. Changing a schedule recounts the next capture from the last one (COM-1815: last capture 6 Nov + a week = 13 Nov), so it's simply due at the next hourly run, but a past date reads like a mistake.
2. CHK-2's error line runs two sentences together with no full stop: "…this check reads was deleted The read isn't allowed any more: …" (existed before this round).

## What people see

- When a check's next capture is already due, the card (and the check's page, and Polaris's answers) reads **"next: due now"** (or "next: at the next run"), not a past date. Future dates read as now.
- The error line puts a full stop between its sentences.

## Done when

- CHK-2, Weekly with its last capture on 6 Nov, reads "next: due now" on 14 Nov.
- The error line reads "…was deleted. The read isn't allowed any more: …".
- Vitest for the due-now wording; a unit test for the joined error text.

**Independent.** Small follow-up from COM-1815 / COM-1826.