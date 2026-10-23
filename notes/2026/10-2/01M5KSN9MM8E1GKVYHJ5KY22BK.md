---
id: 01M5KSN9MM8E1GKVYHJ5KY22BK
created: 2026-10-23T07:12:30.868545Z
updated: 2026-10-23T07:12:30.868545Z
type: task
title: A DPIA whose processing won't go ahead gets no next-review date
label: improvement
task_status: active
assignee: steve
priority: low
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1270
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