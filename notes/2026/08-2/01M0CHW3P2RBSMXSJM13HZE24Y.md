---
id: 01M0CHW3P2RBSMXSJM13HZE24Y
created: 2026-08-19T08:23:15.394177Z
updated: 2026-08-19T21:25:38.903146Z
type: task
title: View Groups list — Members column with member count
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 270
sprint: s5gwx0s
comments:
- id: 01M0D94PNBA47EBKH8Q6PZTNT6
  author: Steve Vine
  at: 2026-08-19T15:09:54.219415Z
  text: |-
    Merged to main in PR #273. Members column added to View Groups, right-aligned between Membership and Email — no backend change needed: the COM-252 list endpoint already computed `member_count` as one grouped query over `directory_group_members` (no N+1, no live Graph), so the count is as fresh as the mirror like every other cell, and the modal's Members panel reads the same rows so list and modal agree by construction.

    Sorting by the count landed with COM-272 (PR #274), which sorts the aggregate in SQL — "largest groups first" is one click.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Add a **Members** column to the View Groups list (COM-253): the count of members in each group, from the mirror.

* Computed in the list query as an aggregate over the mirrored member rows (`directory_group_members`) — one grouped join/subquery on the COM-252 endpoint, not an N+1 and not a live Graph call; the count is as fresh as the mirror, same as every other cell.
* Sortable, so "largest groups first" is a click — the count column that can't sort is the one everyone curses.
* Display note: dynamic-membership groups carry real member rows in the mirror too (the sync stores evaluated membership), so the count is honest there; a group whose members haven't synced yet shows 0 with the usual staleness caveat covered by the Admin sync status, not a special state.
* The modal's Members panel already shows the same data paginated — the list count and the modal must agree (same source, so they will; just don't fetch them differently).

Refs: COM-252 (list endpoint), COM-253 (the screen), COM-237 (member rows).