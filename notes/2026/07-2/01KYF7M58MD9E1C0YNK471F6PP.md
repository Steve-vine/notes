---
id: 01KYF7M58MD9E1C0YNK471F6PP
created: 2026-07-26T12:50:28.756893Z
updated: 2026-07-30T13:00:44.758653Z
type: task
title: Create Scheduled Tasks
project: 01KY6W9951TW0904DT0GGJVGE7
number: 373
sprint: segj1dz
comments:
- id: 01KYFF8FAF0EJTF6FHX22XNG65
  author: Steve Vine
  at: 2026-07-26T15:03:54.444183Z
  text: 'Plan agreed and PR1 open: https://github.com/Steve-vine/notuvia/pull/364 — ADR 0047 + the Schedule note type + timing fields (recurrence/next_fire/last_fired as core frontmatter; taxonomy can''t hold typed values, so the ticket''s "timing in taxonomy" became core fields — the schedule''s taxonomy carries the template''s task vocabulary instead). Landing as three PRs: PR1 core type, PR2 trigger engine + commands (desktop-app-only sweeper, one task per missed occurrence, deterministic occurrence ids), PR3 the Schedules tab.'
- id: 01KYFJG4BXXNJJEZ326X71TX65
  author: Steve Vine
  at: 2026-07-26T16:00:31.09881Z
  text: 'PR2 open: https://github.com/Steve-vine/notuvia/pull/365 — the trigger engine (60s sweep + startup catch-up, one task per missed occurrence, deterministic occurrence ids so crash retries and git-sync peers converge on identical files), the list_schedules/set_schedule/fire_schedule_now commands, and schedule timing on the MCP create/update tools. Remaining: PR3, the Schedules tab UI.'
- id: 01KYFJZ86MZA4YGJVFW9NMKNBD
  author: Steve Vine
  at: 2026-07-26T16:08:46.547751Z
  text: 'PR3 open: https://github.com/Steve-vine/notuvia/pull/366 — the Schedules tab (soonest-firing-first list with rule summaries, next-fire, taxonomy pills, paused chip, New schedule button) and the recurrence editor in NoteProperties (once/daily/weekly/monthly/yearly, nth-weekday incl. Last, weekday chips, live summary). This completes the NOT-373 sequence once merged; PR4 candidates noted in the PR (keyboard nav, row pause/fire-now, sidebar filters).'
- id: 01KYFN8GVDA8M45H92HSSSX59Y
  author: Steve Vine
  at: 2026-07-26T16:48:47.469025Z
  text: 'Done — all three PRs merged to main: #364 (ADR 0047 + Schedule note type + timing fields), #365 (trigger engine + commands + MCP params), #366 (Schedules tab + recurrence editor, incl. the live-mode-on-create and occurrence-timestamp fixes found in testing). Follow-up candidates not tracked yet: bare-arrow keyboard nav on the schedules list, row-level pause/fire-now actions, sidebar filter section.'
assignee: steve
label: null
priority: medium
task_status: done
---
This is a new tab alongside workspace, dashboard etc.
Add the ability to create scheduled tasks.  The tab should comprise a list of task templates with a schedule. A schedule itself should be a new note type called schedule, and the taxonomy contains the schedule timing.  The new tab allows a user to create new schedule tasks add content and set the schedule.

Scheduling should allow:
Date and time plus optional recurring.
Recurrence (x y of z - E.g. 1st Monday of each month)
One off trigger (on the 1st July 2027)

The schedule list should show all schedule tasks in order of what is due to fire next along with taxonomy details.

When triggered, a new task of the task specified in the schedule taxonomy is created with the specified content.
If the schedule was a one off, it gets marked as complete, if recurring, the date updates to the next triggered run.