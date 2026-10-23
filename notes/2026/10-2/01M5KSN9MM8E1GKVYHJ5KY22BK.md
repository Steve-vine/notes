---
id: 01M5KSN9MM8E1GKVYHJ5KY22BK
created: 2026-10-23T07:12:30.868545Z
updated: 2026-10-23T07:37:53.043086Z
type: task
title: A DPIA whose processing won't go ahead gets no next-review date
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1270
sprint: s33gwqy
comments:
- id: 01M5KV365CZ60QDKJD1F9Q55CQ
  author: Steve Vine
  at: 2026-10-23T07:37:34.635929Z
  text: |-
    Done — merged in PR #1261 (no migration). Not on staging yet; it goes with the next deploy.

    - Approving a DPIA after the ICO said the processing should not go ahead leaves Next due empty. The Status card says "None — the processing will not go ahead".
    - With no date, there's no "DPIA review due" in Actions, and the Overview doesn't count it as due for review.
    - Changing the DPIA review cadence in Settings doesn't give it a date.
    - "Processing changed — review DPIA" still appears if a covered data asset changes afterwards: that's someone trying again, and it calls for a fresh DPIA.

    The test approves a DPIA after a "should not go ahead" reply. It checks there's no next-due date, still none after the DPIA cadence is cut to one month, and no due action. It failed before the change. A DPIA approved after the ICO's deadline passed with no reply still gets its date.
assignee: steve
label:
- improvement
priority: low
task_status: review
---
Steve's decision, 2026-10-23, on the question raised in COM-1237: a DPIA approved after the ICO said the processing should not go ahead has nothing to review, so it gets no next-review date.

**Chain:** independent (no migration, no API change expected)

## What people see

- Approving a DPIA whose prior consultation came back "Processing should not go ahead" leaves **Next due** empty; the page says it won't be reviewed because the processing will not go ahead.
- No "DPIA review due" in Actions for it, and the Overview doesn't count it as due for review.
- Changing the DPIA review cadence in Settings doesn't give it a date.
- "Processing changed — review DPIA" still appears if a covered data asset changes afterwards: that's the sign someone is trying again, and a fresh DPIA is needed.

## Notes (technical)

- `approve()` sets `next_due_on` from the kind's cadence (`core/risk_assessment_approval.py`); `redate_current()` (`core/risk_assessment_settings.py`) re-dates current approved ones. Both should skip a DPIA where `dpia_prior_consultation.will_not_proceed()`.

**Done when:** a DPIA approved after a "should not go ahead" reply has no next due, isn't in Actions as due, and a cadence change leaves it undated.