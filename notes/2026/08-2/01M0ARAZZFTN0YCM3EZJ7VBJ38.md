---
id: 01M0ARAZZFTN0YCM3EZJ7VBJ38
created: 2026-08-18T15:37:45.711256Z
updated: 2026-08-19T00:01:51.013947Z
type: task
title: Campaigns — responsible owners resolved at open, and an editable campaign detail view
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 264
sprint: s5gwx0s
blocked_by:
- 01M0AQXC01APZFS3ZSW1WQ2QW9
- 01M0AH2AG3TCTJ223ZXN26Q9Y0
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Three campaign changes from live use, hanging off one distinction to keep sharp throughout: the campaign **definition** (target scope + cadence) is what gets edited; each opened campaign **instance** freezes what it ran with.

* **Responsible owner(s).** Campaigns get targeted individual(s) responsible for completing them: **the owner of the target group/role**. Resolved **when the campaign is triggered** (the Beat opener), frozen on the instance like the membership snapshot — the point of an owner snapshot is that "who was responsible for this review" stays answerable after the owner changes.
  * Role-scoped campaigns: the business-role owner FK (a Compass user — COM-258 makes it required, so resolution is total).
  * Group-scoped campaigns: the Entra group owner(s) from the mirror (COM-252 now syncs them) — **who may not be Compass users**. Match directory owner → Compass user by object id/UPN where possible; where no match, freeze the named owner anyway and surface a visible "owner is not a Compass user — reassign or invite" state rather than silently assigning nobody. An ownerless group at open gets the same explicit unassigned-warning state.
  * Reminders/overdue nagging (the COM-241 digest path) target the resolved responsible owners; the campaign list shows the owner(s) and the dashboard "overdue reviews" slice groups by them.
* **Campaign detail view** — currently campaigns are rows with progress; add a detail screen:
  * **Definition side (editable):** change the **target group/role** and the **cadence** (per-scope cadence from COM-263). Edits apply from the next open — an in-flight instance is never retargeted (its snapshot would be meaningless); the view says so explicitly next to the edit controls.
  * **Instance side (frozen):** the responsible owner(s) **as at trigger time**, cadence-at-open (COM-263), the membership snapshot, item progress, and the evidence record on closed instances. If the current group/role owner has since changed, show both — "owner at open" vs "current owner" — so the drift is visible instead of confusing.
  * Reviewer reassignment on an open instance stays what it is today (item-level, from COM-241) — distinct from the frozen responsible-owner record, which documents accountability, not who clicked.

Refs: COM-241 (opener, reviewers, digests), COM-242 (campaign screens this extends), COM-263 (per-scope cadence — stack on it), COM-252 (group owners in the mirror), COM-258 (role owner required), ADR 0015 §4 (snapshot semantics).