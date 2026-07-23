---
id: 01KY70MXK9YR8Y4JNMC9AAN9YG
created: 2026-07-23T08:14:38.185579Z
updated: 2026-07-23T11:04:50.442296Z
type: task
title: Search Results
task_status: done
imported_from: linear
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 159
comments:
- id: 01KY70N1TY68C7FFH947D2725T
  author: Steve Vine
  at: 2026-07-23T08:14:42.525827Z
  text: |-
    Steve Vine · 2026-07-03:

    **Done building** — PR: https://github.com/Steve-vine/notuvia/pull/141

    **What was done:** CSS-only change in `SearchSection.svelte`: the snippet line drops to 65% opacity on top of its muted colour, and its `mark` highlight dims from 0.28 to 0.16 accent alpha so it no longer competes with the title's highlight. Titles untouched.

    **Decisions on the fly:** De-emphasised the snippet rather than boosting the title (keeps the sidebar's overall weight consistent with the browse list).

    **Problems:** None — but it's a visual tweak, so worth an eyeball in the app during review (I can't screenshot on this machine).
sprint: sg5stzf
---
In the results, make the second line of the results less prominent so that title stands out more.

## Agreed work

* In `SearchSection.svelte`, tone the snippet line down: lower its opacity and dim its match-highlight so the highlight no longer pulls the eye as hard as the title's.
* Titles keep their current size/colour and full-strength highlight, so they stand out by contrast.
* Checks: `npm run check`, `npm test`.

---

Linear DEV-797 · Left Panel Improvements · created 2026-07-03 · done 2026-07-04