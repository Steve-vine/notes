---
id: 01KY716884CV5ME1YWNNE1VE5E
created: 2026-07-23T08:24:06.148223Z
updated: 2026-07-23T12:24:59.484948Z
type: task
title: Recent Notes
assignee: steve
task_status: done
comments:
- id: 01KY716EXZ0DR4A5XHXB5BQ2SS
  author: Steve Vine
  at: 2026-07-23T08:24:12.990976Z
  text: |-
    Steve Vine · 2026-07-05:

    Built as agreed — PR: https://github.com/Steve-vine/notuvia/pull/185 (second commit; lands with DEV-856).

    **What was done**

    - One `recent_notes(axis, limit)` command: axis `"created"` or `"updated"`, strictly validated (it's interpolated into the SQL — the test asserts an injection-shaped axis errors); newest first, notes missing the timestamp last; rows carry id/title/type plus the timestamp.
    - Two Dashboard panels after Favourites — **Recently Created** and **Recently Updated** — rendered from one shared snippet in the ToDo list format: title, muted Type, date on the right. No filter/sort menus, click/Enter opens over the dashboard, refresh via `noteRev`, last 10 each.

    **Decisions made on the fly**

    - Rows show the ranking date (created or updated respectively) via the shared `dateLabel` — the issue didn't ask for it, but a recency list without the date reads as an unordered list. Say if you'd rather drop the column.
    - Both panels load together in one effect (a single `Promise.all`), so they appear at once.

    **Problems encountered**

    None. Visual pass: panel order (To Do → Favourites → Recently Created → Recently Updated) and the date column width against the ToDo panel's due column.
label: null
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 202
sprint: sjgxe93
---
Add a section for recently created notes.  Show all note types, the last 10 created notes.  Format like the ToDo list but without filter and sort.

Also create a recently updated notes section, same as the recently created one.

Both of these in separate panels.

## Agreed work

**Backend** — one `recent_notes(axis, limit)` command (axis `"created"` | `"updated"`, validated): notes of any Type ordered by that timestamp descending (missing timestamps last), limited to 10 by the caller. Rows carry id / title / type plus the timestamp so the panel can show when. Index query + runtime passthrough + test.

**Dashboard** — two new panels after Favourites, sharing the `.panel` styling: **Recently Created** and **Recently Updated**. Each is a table like the Favourites list — title, muted Type, and the created/updated date (via `dateLabel`) on the right. Click/Enter opens the note over the dashboard. No filter or sort menus. Refresh via `noteRev`.

Lands together with DEV-856 on one branch (both touch the Dashboard; sequencing beats stacking under squash-merge).

Checks: `cargo test`, `npm run check`, `npm test`.

---

Linear DEV-850 · Dashboard · created 2026-07-05 · done 2026-07-05