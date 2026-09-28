---
id: 01M3MYKFDPF3MFM25ZSC5SF7DT
created: 2026-09-28T21:26:44.91807Z
updated: 2026-09-28T22:06:32.889432Z
type: task
title: 'Website: Roadmap page — interactive timeline'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 489
sprint: spqrtwg
blocked_by:
- 01M3MY1APNGC5GRXYGCCWJJ9T3
comments:
- id: 01M3MZ5SA67D4BEF9NA17ZSHPQ
  author: Steve Vine
  at: 2026-09-28T21:36:44.870745Z
  text: 'Decision (Steve, 2026-09-28): build the roadmap with the design''s milestones as they are. Steve amends the entries before go-live, so keep them in one data file that is easy to edit.'
- id: 01M3N0WBDSH5A4DEQKK76579DF
  author: Steve Vine
  at: 2026-09-28T22:06:32.889247Z
  text: |-
    Built and pushed to staging (15faf35).
    - /roadmap/ follows the design: kicker, heading and lede; a Shipped/Planned legend; Earlier / Today / Later controls; and the horizontal timeline from June 2026 to June 2027. It has month ticks, the Today marker, a solid shipped line and a dashed planned one, cards staggered above and below the line, and a detail popover.
    - The timeline is laid out at build time with the design's own maths (src/lib/roadmap-layout.ts), so it shows before any script runs.
    - The page script adds drag-to-scroll, the three controls, centring on Today, and the popover on hover and on keyboard focus (Escape closes it). It also moves "today" to the visitor's date, so milestones flip from Planned to Shipped as their dates pass without a rebuild.
    - It is keyboard-reachable (each card is a button) and respects reduced motion. On phones, and with JavaScript off, every milestone shows as a plain list.
    - **The entries are the design's 16, unchanged, in src/data/roadmap.ts, ready for Steve's edits.** Notes on them:
      - Every shipped date matches the date of its decision record, not a release date.
      - "Live editing" (27 Jun) is the hybrid-editor decision; the first live-editing decision was 20 Jun.
      - The Windows beta, Linux beta and 1.0 targets have no decision behind them yet.
    - Checked: the build passes, and interaction tests pass (Today centring, Tab to a card shows the popover, hover, controls, drag, a simulated 2027 date, no-JS list, reduced motion).
    To look at: /roadmap/ on desktop in both themes (hover, drag, Today), and at phone width for the list.
assignee: steve
label:
- brief
priority: low
task_status: active
tech: null
---
The design's Roadmap, "Where Notuvia has been, and where it's going.": a horizontal timeline from June 2026 to June 2027 with a Today marker, milestones marked Shipped or Planned, and detail on hover.

## Scope

- [ ] Milestones in one data file (date, title, one-liner, detail), starting from the design's 16 entries. Shipped or Planned is worked out from the build date.
- [ ] The timeline scrolls and drags, with previous, next and Today buttons, and centres on today when it opens. This needs client JavaScript. Keep it on this page only, and make it keyboard-reachable. On a phone, or with no JavaScript, fall back to a plain vertical list.
- [ ] Check the shipped dates against the app's history. Steve confirms the planned targets before they go public (Public release notes Oct 2026, Windows beta Dec 2026, Linux beta Feb 2027, 1.0 Apr 2027). Say in plain words that targets are not promises, as the design does.

**Done when:** the page matches the design, works by keyboard, and degrades to a list on a phone.