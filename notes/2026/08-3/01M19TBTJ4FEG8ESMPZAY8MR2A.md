---
id: 01M19TBTJ4FEG8ESMPZAY8MR2A
created: 2026-08-30T17:09:37.476597Z
updated: 2026-08-30T18:10:14.848876Z
type: task
title: Compliance % measures the whole applicable library, not just what has been assessed
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 540
sprint: s2fcksg
assignee: steve
company: null
label:
- bug
priority: high
task_status: active
---
The Dashboard says a company is 100% compliant when 2 of 383 controls have been assessed and both are implemented. It is dividing by what has been assessed instead of by everything that applies, so the headline flatters the company exactly when it knows least.

**Expected** — a control nobody has looked at is a control that is not in place. It counts against the score. 2 implemented out of 383 applicable reads as 1%, and the number climbs as real work is done rather than starting at 100% and falling.

**Scope**
- The headline Compliance figure and the per-domain Compliance column on the Dashboard.
- Only controls marked *not applicable* leave the denominator — that is the existing "applicable" count (control library minus not-applicable), which is already computed and shown next to it.
- Coverage % ("how much have we assessed") is unchanged and keeps the honest denominator conversation. It is the number that answers "how far through are we".

**Screen behaviour to settle**
- With nothing assessed the figure is now **0%**, not "Not assessed" — the score is genuinely zero. "Not assessed" / "n/a" survives only where nothing is applicable at all (an empty or fully not-applicable domain).
- The colour bands on the ring and the domain badges will read red for a while on a young company. That is correct and is the point of the fix; no band retuning as part of this task.

**Implementation** (`app/backend/src/compass_api/api/v1/dashboard.py`)
- Per domain and in the totals, `compliance_percent` becomes `implemented / applicable`, null only when `applicable == 0` — currently `implemented / assessed`, null when `assessed == 0` (lines ~191 and ~207).
- The module docstring already describes the intended behaviour ("implemented ÷ applicable controls (a control with no assessment is applicable-by-default and so counts as a shortfall)") — the code drifted from it, so the docstring stands.
- Fix the two stale comments in `api/v1/schemas.py` (~2573, 2595) that document the field as implemented / assessed.
- `DashboardPage.tsx`: `fmtCompliance` / the ring's null branch still handle null, but null now means "nothing applicable", so check the wording reads right in that case.
- Update the dashboard API tests and `DashboardPage.test.tsx` fixtures — several will assert the old ratio.
