---
id: 01M0AQXC01APZFS3ZSW1WQ2QW9
created: 2026-08-18T15:30:19.265543Z
updated: 2026-08-18T15:30:21.95871Z
type: task
title: Recertification — cadence per campaign, not one global setting
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 263
sprint: s5gwx0s
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Today recert runs off a single cadence in settings (COM-241/242); every scope recertifies on the same clock. Different groups deserve different clocks — privileged groups quarterly or monthly, low-risk membership annually. Make cadence **per campaign definition**:

* **Model**: cadence moves onto the campaign *scope* configuration (the per-group / per-business-role definitions COM-242's management screen edits) — e.g. `monthly | quarterly | semi_annual | annual`. The existing global setting becomes the **default for new scopes** rather than the rule for all; existing scopes migrate carrying the current global value so nothing changes behaviour on deploy.
* **Opener**: the daily Beat task (`tasks/recert.open_recert_campaigns`) evaluates each scope against **its own** cadence; the `(company, scope, period)` dedupe key already makes this safe — the period just derives from the scope's cadence instead of the global one. A scope whose cadence changes mid-period keeps its open campaign untouched; the new cadence takes effect from the next open (no retro-closing, no double-opening — state this in the tests).
* **UI** (COM-242's campaign management): cadence selector on each scope row/definition, showing **next due date** derived from cadence + last campaign so the operator can see the schedule they've built; the settings-page global cadence relabelled "default cadence for new scopes".
* Campaign records display which cadence they were opened under (frozen on the campaign like the rest of its evidence — an auditor asking "how often do you review this group" reads it off the record).
* Config changes are governance: the scope/cadence table joins `_AUDITED_TABLES` if it isn't already there.

Refs: COM-241 (opener + dedupe key), COM-242 (management screen), ADR 0045 §8, 0044 §4 (scheduling pattern).