---
id: 01M0ARAZZFTN0YCM3EZJ7VBJ38
created: 2026-08-18T15:37:45.711256Z
updated: 2026-08-25T18:42:58.031722Z
type: task
title: Campaigns — responsible owners resolved at open, and an editable campaign detail view
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 264
order: 1.25
sprint: s5gwx0s
blocked_by:
- 01M0AQXC01APZFS3ZSW1WQ2QW9
- 01M0AH2AG3TCTJ223ZXN26Q9Y0
comments:
- id: 01M0BS1T1G7A59QT6GHTAWPDV6
  author: Steve Vine
  at: 2026-08-19T01:09:27.72881Z
  text: |-
    Built and merged to main (PR #268, CI green; migration 0078).

    The definition/instance distinction runs through it all. Responsible owners are resolved by the Beat opener and frozen on the campaign (responsible_owners on recert_campaigns): role-scoped campaigns freeze the role owner (total since COM-258); group-scoped campaigns freeze the mirrored Entra owners from COM-252, matched to Compass users by UPN/mail against email where possible — an unmatched owner is frozen by name with a visible "(no account) — reassign or invite" state, and an ownerless group opens explicitly Unassigned, never silently nobody. Tests assert the freeze survives a later owner change — that being the point of the snapshot.

    Nagging: the reminders digest now targets the resolved responsible owners of open campaigns with pending items ("you are the responsible owner"), with the notification dedupe collapsing owner-as-reviewer duplicates. The campaign list gained an Owner column and the header's overdue count reads grouped by owner.

    Campaign detail: an Edit-definition panel changes the scope's target role and cadence — PATCH /recert-scopes/{id} grew retargeting with same-kind, mirror-presence and duplicate-target validation — with the explicit statement that edits apply from the next open; the in-flight instance is never retargeted (asserted: the open campaign keeps its scope after a retarget; the next open follows the new target). The instance side shows the frozen owners with owner-at-open vs current-owner drift made visible when they differ, alongside the COM-263 cadence-at-open and the existing snapshot/progress/evidence. Reviewer reassignment stays item-level — who clicks, distinct from who is accountable.
assignee: steve
company: null
label:
- feature
priority: medium
task_status: cancelled
---
**Superseded (2026-08-19) by the Recertification v2 redesign — COM-280…COM-284.** Its concerns are absorbed there: responsible owners become schedule owners (defaulted from the group/role owner, resolved and frozen at trigger); the editable definition vs frozen instance split becomes schedule vs instance; the detail/oversight views land with COM-284.

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