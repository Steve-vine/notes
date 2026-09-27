---
id: 01M3J2X9NQBARPWN855XF7CTSH
created: 2026-09-27T18:44:17.719929Z
updated: 2026-09-27T18:48:07.537018Z
type: task
title: Traffic lights sit above the tab strip's centre line
project: 01KY6W9951TW0904DT0GGJVGE7
number: 461
sprint: sqsolof
comments:
- id: 01M3J2Y1W2A5XAWZES77J78R9Q
  author: Steve Vine
  at: 2026-09-27T18:44:42.498383Z
  text: 'PR #464: trafficLightPosition.y 15 → 21 in tauri.conf.json, centring the 12px buttons in the 42px strip. Config only; confirm in a real window after a restart.'
assignee: steve
label:
- bug
priority: low
task_status: done
tech: null
---
The close/minimise/zoom buttons are centred ~25px from the window's top while the 42px tab strip's labels are centred ~34px down. trafficLightPosition y was set for a shorter strip; centre a 12px button in the strip: y 21.