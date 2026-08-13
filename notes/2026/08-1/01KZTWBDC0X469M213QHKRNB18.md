---
id: 01KZTWBDC0X469M213QHKRNB18
created: 2026-08-12T11:40:02.816533Z
updated: 2026-08-13T19:00:09.803229Z
type: task
title: 'Region on the screens: rules, list, blast radius and composer'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 664
sprint: sj9fsph
comments:
- id: 01KZV0WNJZDFKCXXVZWX9XVG1D
  author: Steve Vine
  at: 2026-08-12T12:59:22.591728Z
  text: |-
    Done — PR #614, merged as 3bbe358.

    Region reads as a **peer of environment** throughout, because that is what it is: both narrow a rule, both optional, both "any" when blank.

    - Rule editor gains a Region field beside Environment, shared by the create modal and the edit panel through `ruleDrafts` — so the two doors can't drift into stating rules differently
    - Create modal gains Region on the identity, with the live preview building the dotted name from what's filled in: `name.environment` until a region is typed, then `chinwag-v2.prod.uk`
    - List gains a Region column **and a Region filter** — the filter being the point, since two of everything is the expected end state and a list that doubles with no way to narrow it is worse than the one it replaced. Shown only once the estate states a region, so an untagged estate isn't given a control that teaches nothing.
    - Every place a rule renders now shows its region: list chips (`mp-app:chinwag-v2 @prod /uk`), the rule table, the blast-radius provenance

    One deliberate choice: the region cell reads `—`, not "global", where none is stated. A Business Application that genuinely isn't regional and one nobody has tagged yet are different claims, and neither gets invented on the screen.
assignee: steve
label:
- feature
priority: high
task_status: done
tech: null
---
The surfaces for ISE-663. Nothing here invents a region — it renders `display_name`, so a regionless Business Application reads exactly as it does today.

- **Create modal + rule editor** (`ruleDrafts`): a Region field beside Environment, on the identity and on each rule. Both optional, both with the same "any" affordance the environment field already has.
- **Business Applications list**: region in the identity column, so `chinwag-v2.prod.uk` and `chinwag-v2.prod.us` read as the two distinct things they are rather than a repeated name.
- **Blast radius** (ISE-655/656): the impact rollup names the regional Business Application, so "8 of 16 affected" becomes `chinwag-v2.prod.uk (8 of 8)` — which is the whole point. A UK outage must stop claiming the US.
- **Business Services composer**: regional Business Applications listed by their full name; a Business Service composing both UK and US is CORRECT and must not read as a fault (0073 §7 is about customer-facing, not about region).

**Filter, don't just display.** The list needs a region filter beside the environment one — two of everything is the expected end state, and a list that doubles without a way to narrow it is worse than before.