---
id: 01M7DBWMV7KR4A5W2FH7YWVRMA
created: 2026-11-14T15:47:48.711274Z
updated: 2026-11-14T15:47:53.549165Z
type: task
title: 'A check whose next capture is already due reads "next: due now" instead of a date in the past, and its error line puts a full stop between sentences'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1830
sprint: spsp226
assignee: steve
label:
- bug
priority: low
task_status: active
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