---
id: 01M3EFMTS7ZH111VAEPWW9NPVY
created: 2026-09-26T09:11:07.800225Z
updated: 2026-09-26T09:36:19.745857Z
type: task
title: Alignment differences
project: 01KY6W9951TW0904DT0GGJVGE7
number: 447
sprint: sqsolof
comments:
- id: 01M3EG6243Q3WF0SEKNNZTQ3KG
  author: Steve Vine
  at: 2026-09-26T09:19:18.658809Z
  text: 'PR #449: the Live image widget''s wrap carried margin: 0.3rem 0 that the read view''s bare inline <img> never had; both sit on the baseline with the same ~8px strut gap beneath, so the margin was the whole drift (9px per image). Removed, and a side-by-side lab readout shows every image and line box at identical offsets in both views.'
assignee: steve
priority: medium
task_status: done
tech: null
---
There seems be a slight alignment difference around images between Read and Live view, below are images of the same note in both modes.

## Read Mode
![CleanShot 2026-09-26 at 10.09.25@2x.png](attachments/2026/09/01M3EFMTS7ZH111VAEPWW9NPVY/CleanShot-2026-09-26-at-10.09.25@2x.png)

## Live Mode
![CleanShot 2026-09-26 at 10.11.16@2x.png](attachments/2026/09/01M3EFMTS7ZH111VAEPWW9NPVY/CleanShot-2026-09-26-at-10.11.16@2x.png)
