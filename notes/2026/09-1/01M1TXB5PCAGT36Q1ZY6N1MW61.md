---
id: 01M1TXB5PCAGT36Q1ZY6N1MW61
created: 2026-09-06T08:28:49.642268Z
updated: 2026-09-06T08:31:20.696165Z
type: task
title: Pill Colours in dark mode
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 574
sprint: s2fcksg
assignee: steve
label:
- bug
priority: high
task_status: backlog
---
![CleanShot 2026-09-06 at 09.28.06@2x.png](attachments/2026/09/01M1TXB5PCAGT36Q1ZY6N1MW61/CleanShot-2026-09-06-at-09.28.06@2x.png)

Raised by Steve, 2026-09-06, from the framework coverage table. Pills in dark mode wash out to near-grey and are hard to read.

## It is worse than hard to read — the colour has stopped meaning anything

In the snapshot, colour is carrying information and dark mode has flattened it:

- **`DOES PART OF THIS` and `DOES THIS AND MORE` are all but identical.** They are deliberately different colours — green where the control does the whole job, grey where it does a corner of it — and that is the distinction the whole column exists to draw. In the second row the two sit one above the other and a reader cannot tell them apart.
- **`PARTIAL` barely separates from `NOT ASSESSED`.** A muted olive next to a grey, when one means "some of this is implemented" and the other means "nobody has looked".
- **`FULLY COVERED` and `MET`** read as dark grey-green — legible, but only just, and not as *green*.
- The **`5/10`** beside each badge is dimmed grey text on a dark ground, and is the faintest thing in the picture.

So this is not only a legibility complaint. Two rows can say different things and look the same, which on a coverage screen is a wrong answer rather than an ugly one.

## What changes

Raise the saturation and the contrast of the light-variant pills **in dark mode**, so a green reads as green and a grey reads as grey.

- **In `theme.ts`, and nowhere else.** The Badge / Pill / Chip overrides already live there for the no-truncate rule, and the screen convention is explicit that a pill is never restyled at the call site — around fifty files render a bare `Badge`, so a per-site fix is one that comes undone. Mantine's variant colour resolver is the hook: lift the light variant's background alpha and its text shade under the dark scheme, leaving light mode as it is.
- **Aim at a number, not a feeling.** Pill text should reach at least 4.5:1 against its own background in both schemes; "more saturated" on its own is not something a reviewer can check. Take the two closest pairs in the snapshot — `DOES PART OF THIS` against `DOES THIS AND MORE`, and `PARTIAL` against `NOT ASSESSED` — and confirm each pair is distinguishable side by side, not just individually readable.
- **The dimmed `n/10` too.** It sits in the same reading and is currently the weakest element on the row.
- **Assert the resolved colour in a test**, not the prop that was passed. A colour set without a shade can leave the flag a silent no-op and still look right in the test — check the value that actually lands on the element.

## Related

- COM-567 — that `n/10` may disappear entirely beside `DOES EXACTLY THIS` and `DOES THIS AND MORE`, since it is 10 by definition there. Worth knowing, but do not wait: the contrast problem is everywhere pills are, not only on this table.
- `brief/information-architecture.md` → Screen conventions — the pill rule this follows.
