---
id: 01KYW2Q8KGT3HM9P09BYXZ06C1
created: 2026-07-31T12:34:55.216698Z
updated: 2026-08-07T11:55:14.766537Z
type: task
title: ISE brand theme — dark default, favicon, social cards
project: 01KX671DATY39VW6GWK3M2T3DN
number: 404
sprint: sp3en5k
blocked_by:
- 01KYW2Q2N03YTZX0VEAMZAKN9N
comments:
- id: 01KYW4BB5356NNK7P1FYYXF2T9
  author: Steve Vine
  at: 2026-07-31T13:03:21.763596Z
  text: |-
    Done on feature/ise-404-brand-theme (PR #2 → main, squash-merged).

    - Compass brand palette mapped onto Starlight accent variables (light accent #1772a8, dark accent #4aace0), Inter self-hosted variable font (@fontsource-variable/inter), 700-weight headings.
    - Dark mode default via a small head script — the built-in toggle still works and explicit visitor choices (incl. auto) are respected.
    - New ISE favicon (brand-blue rounded square) and a 1200×630 og.png social card, wired up with og:image + twitter:card metadata.

    Build/lint/format green.
assignee: steve
priority: medium
task_status: done
---
Apply the ISE look from the app design system (`../ise/docs/briefs/design-system.md`, Compass): brand blue palette (light accent `#1772a8`, dark accent `#4aace0`), Inter with system fallback, 700-weight headings. Dark mode is the default colour scheme, with Starlight's built-in light/dark toggle available. Add an ISE favicon and Open Graph / Twitter card metadata so links to ise.cool unfurl properly.

Depends on ISE-403.