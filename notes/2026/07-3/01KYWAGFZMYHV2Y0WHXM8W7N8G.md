---
id: 01KYWAGFZMYHV2Y0WHXM8W7N8G
created: 2026-07-31T14:51:02.004507Z
updated: 2026-07-31T14:51:02.004507Z
type: task
title: 'Docs: new section — Dashboards (+ sidebar group)'
assignee: steve
task_status: backlog
priority: medium
label: feature
project: 01KX671DATY39VW6GWK3M2T3DN
number: 433
---
**Owns the new sidebar group.** Add a `Using ISE` group to the Starlight sidebar in `astro.config.mjs` (autogenerate over `src/content/docs/using-ise/`) — the home for the operator-surface pages (Dashboards, Assist, Events, Tags, Proposals). ISE-434..437 depend on this.

Then write `using-ise/dashboards.md`: what a dashboard is for (a glanceable wallboard, not an operator working surface — rolled up, readable across a room, colour **plus** a written status word); curating tiles from groups and the rules that make a tile red; latched state so an overnight blip is still visible in the morning; the tokened public read route for a TV with no login; how it differs from the Incidents screen.

Ground in ADR 0053 (plus 0037/0028 for group membership, 0038 for what an ack does not do). Operator audience, released capability only.