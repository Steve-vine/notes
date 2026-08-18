---
id: 01M0AQXC01APZFS3ZSW1WQ2QW9
created: 2026-08-18T15:30:19.265543Z
updated: 2026-08-18T23:09:15.964365Z
type: task
title: Recertification — cadence per campaign, not one global setting
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 263
sprint: s5gwx0s
comments:
- id: 01M0BJ5Q9W4ZH2Y4RFH9YV9SWZ
  author: Steve Vine
  at: 2026-08-18T23:09:15.963857Z
  text: |-
    Built and merged to main (PR #262, CI green; migration 0074).

    Cadence moved onto a first-class, audited scope definition (recert_scopes). The Beat opener auto-provisions a scope for every active business role at the company default — behaviour unchanged on deploy, no data backfill needed (a writer's first look at the Schedules tab provisions too) — then evaluates every scope, role or group, against its own clock. period_label gained the semi-annual form (2026-H2).

    The mid-period rule landed exactly as specified and is asserted in tests: a cadence edit never touches an in-flight campaign — a campaign opened under a different cadence parks the scope (no retro-close, no double-open) and the new cadence takes effect from the next open. Ordinary period rollover is unchanged. Campaigns freeze the cadence they were opened under (shown on the list and the detail header) — the auditor's "how often do you review this group" reads straight off the record; hand-opened campaigns adopt the scope's cadence so they land in the same period stream.

    UI: a new Schedules tab on Recertification — every scope with an inline cadence editor (Monthly/Quarterly/Semi-annual/Annual), last period and next-due date ("Due now" when uncovered), plus hand-added group schedules with duplicate-refusal; deleting one stops scheduling and keeps the campaigns as evidence. The settings cadence is relabelled "Default cadence for new scopes". COM-264 (campaign owners + detail view) can now stack on this.
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Today recert runs off a single cadence in settings (COM-241/242); every scope recertifies on the same clock. Different groups deserve different clocks — privileged groups quarterly or monthly, low-risk membership annually. Make cadence **per campaign definition**:

* **Model**: cadence moves onto the campaign *scope* configuration (the per-group / per-business-role definitions COM-242's management screen edits) — e.g. `monthly | quarterly | semi_annual | annual`. The existing global setting becomes the **default for new scopes** rather than the rule for all; existing scopes migrate carrying the current global value so nothing changes behaviour on deploy.
* **Opener**: the daily Beat task (`tasks/recert.open_recert_campaigns`) evaluates each scope against **its own** cadence; the `(company, scope, period)` dedupe key already makes this safe — the period just derives from the scope's cadence instead of the global one. A scope whose cadence changes mid-period keeps its open campaign untouched; the new cadence takes effect from the next open (no retro-closing, no double-opening — state this in the tests).
* **UI** (COM-242's campaign management): cadence selector on each scope row/definition, showing **next due date** derived from cadence + last campaign so the operator can see the schedule they've built; the settings-page global cadence relabelled "default cadence for new scopes".
* Campaign records display which cadence they were opened under (frozen on the campaign like the rest of its evidence — an auditor asking "how often do you review this group" reads it off the record).
* Config changes are governance: the scope/cadence table joins `_AUDITED_TABLES` if it isn't already there.

Refs: COM-241 (opener + dedupe key), COM-242 (management screen), ADR 0045 §8, 0044 §4 (scheduling pattern).