---
id: 01KYWAGFZMYHV2Y0WHXM8W7N8G
created: 2026-07-31T14:51:02.004507Z
updated: 2026-08-07T10:57:37.593577Z
type: task
title: 'Docs: new section — Dashboards (+ sidebar group)'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 433
order: 0.0009765625
sprint: sp3en5k
comments:
- id: 01KYWBQ0J0Y4S27HJJZW8ZGFKF
  author: Steve Vine
  at: 2026-07-31T15:12:04.160665Z
  text: |-
    Done on feature/ise-433-docs-dashboards — PR #28, left OPEN for review.

    Adds the "Using ISE" sidebar group (autogenerate over using-ise/) — ISE-434..437 stack on this branch — plus the Dashboards page: the four deliberate differences from Overview (rolled up / glanceable / latched / public); services as curated views over groups NOT estate entities, with the why (same group fronts several services, no graph pollution) and retired-entity exclusion; warn/alert rule sections, both rule shapes (asset_count, signal_match), severity always a floor because operators think in floors, save-time regex validation so typos fail in the editor; the webhook-source exclusion with its reasoning (no reliable all-clear → would latch red forever); four levels with "grey is not green — an empty board reading as healthy is the one failure a status wall must never have" and status-word-always-written for accessibility/bad TV colour; latching with "a wall that silences itself is a wall a team learns to ignore", the 3am-blip-at-9am line, status age, stale indicator instead of freezing green, ack shows a marker and never turns a tile green; the public wallboard (chromeless /board/{token}, fit-to-screen never scrolls, only two reads exposed, URL-is-the-credential, revocation immediate, 404-not-401 so it reveals nothing, ~16-tile ceiling → curate don't scroll). 21 pages build. Facts from ADR 0053.
assignee: steve
label: null
priority: medium
task_status: done
---
**Owns the new sidebar group.** Add a `Using ISE` group to the Starlight sidebar in `astro.config.mjs` (autogenerate over `src/content/docs/using-ise/`) — the home for the operator-surface pages (Dashboards, Assist, Events, Tags, Proposals). ISE-434..437 depend on this.

Then write `using-ise/dashboards.md`: what a dashboard is for (a glanceable wallboard, not an operator working surface — rolled up, readable across a room, colour **plus** a written status word); curating tiles from groups and the rules that make a tile red; latched state so an overnight blip is still visible in the morning; the tokened public read route for a TV with no login; how it differs from the Incidents screen.

Ground in ADR 0053 (plus 0037/0028 for group membership, 0038 for what an ack does not do). Operator audience, released capability only.