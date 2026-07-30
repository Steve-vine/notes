---
id: 01KYPBT3EQXN8370AAY02EVK8S
created: 2026-07-29T07:18:18.839558Z
updated: 2026-07-30T13:16:46.029261Z
type: task
title: Make column visibility scoped
project: 01KY6W9951TW0904DT0GGJVGE7
number: 380
order: 1.125
sprint: segj1dz
comments:
- id: 01KYSFXY6H7SSRMDXDHE1H014Z
  author: Steve Vine
  at: 2026-07-30T12:28:02.12912Z
  text: 'Landed with NOT-377 in PR #369 — the visible-columns ticks now persist per Tasks selection (keyed scope|axis:value), with your existing global ticks answering for any scope you haven''t retuned, so nothing un-hides on upgrade.'
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Make the visible columns section on Kanban view scoped to the selected Tasks section (All tasks, Loose tasks or individual projects).