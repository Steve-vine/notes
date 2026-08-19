---
id: 01M0CHW3P2RBSMXSJM13HZE24Y
created: 2026-08-19T08:23:15.394177Z
updated: 2026-08-19T14:35:02.971126Z
type: task
title: View Groups list — Members column with member count
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 270
sprint: s5gwx0s
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Add a **Members** column to the View Groups list (COM-253): the count of members in each group, from the mirror.

* Computed in the list query as an aggregate over the mirrored member rows (`directory_group_members`) — one grouped join/subquery on the COM-252 endpoint, not an N+1 and not a live Graph call; the count is as fresh as the mirror, same as every other cell.
* Sortable, so "largest groups first" is a click — the count column that can't sort is the one everyone curses.
* Display note: dynamic-membership groups carry real member rows in the mirror too (the sync stores evaluated membership), so the count is honest there; a group whose members haven't synced yet shows 0 with the usual staleness caveat covered by the Admin sync status, not a special state.
* The modal's Members panel already shows the same data paginated — the list count and the modal must agree (same source, so they will; just don't fetch them differently).

Refs: COM-252 (list endpoint), COM-253 (the screen), COM-237 (member rows).