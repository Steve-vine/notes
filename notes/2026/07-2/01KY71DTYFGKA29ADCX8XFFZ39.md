---
id: 01KY71DTYFGKA29ADCX8XFFZ39
created: 2026-07-23T08:28:14.671255Z
updated: 2026-07-23T08:28:24.14552Z
type: task
title: Restyle the delete note button
assignee: steve
imported_from: linear
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 218
comments:
- id: 01KY71DZ77N2MRTK4MVMVA1P8E
  author: Steve Vine
  at: 2026-07-23T08:28:19.046698Z
  text: |-
    Steve Vine · 2026-07-07:

    **Planned work (Claude, 2026-07-07):** the delete button in the note statusbar is missing the `icon` class the star/lock/split/close buttons share, so it gets text-button padding (misaligned) and no hover treatment. Fix: give it `icon danger` so it inherits the icon sizing/alignment/opacity, keep the bin red at rest, and add a danger-flavoured hover (red border/full opacity — the red analogue of the accent hover the other icons get). One-file change in `NotePane.svelte`.
- id: 01KY71E46H3E92W0B61BA57WC8
  author: Steve Vine
  at: 2026-07-23T08:28:24.145017Z
  text: |-
    Steve Vine · 2026-07-07:

    **Build complete — PR [#202](https://github.com/Steve-vine/notuvia/pull/202)**. The bin now carries the shared `icon` class (same sizing/alignment/rest-opacity as the star and padlock) plus a danger hover — red border and full opacity on roll-over, mirroring the accent hover the other icons get. Stays red at rest as requested. svelte-check + build clean; needs your visual once it's in.
---
Restyle the delete note button to look like the other icon buttons in the bar, the red bin icon is good, it just doesn't line up or have a roll-over effect.

---

Linear DEV-871 · Backlog · created 2026-07-07 · done 2026-07-07