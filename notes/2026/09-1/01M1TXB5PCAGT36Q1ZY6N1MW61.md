---
id: 01M1TXB5PCAGT36Q1ZY6N1MW61
created: 2026-09-06T08:28:49.642268Z
updated: 2026-09-06T11:25:08.766218Z
type: task
title: Pill Colours in dark mode
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 574
sprint: s2fcksg
comments:
- id: 01M1TZ3YPQJDBRPRXF61JKZ3JK
  author: Steve Vine
  at: 2026-09-06T08:59:47.799518Z
  text: |-
    Done — PR #578, merged to main.

    Measuring it first changed what the fix should be. The **label was never the problem**: Mantine writes a light-variant pill's text at shade 3, which is already 8:1 on the dark ground. Turning the text up, which is what "raise the saturation and the contrast" would naturally get you, would have fixed nothing.

    What had failed is the **ground**. The light variant tints the surface with 15% of the colour, and on dark that is barely a tint at all — so the two pills the coverage table puts side by side were, as colour difference:

    - `DOES THIS AND MORE` (green) vs `DOES PART OF THIS` (grey): ΔE **13.6** → now **27.0**
    - `PARTIAL` (yellow) vs `NOT ASSESSED` (grey): ΔE **13.9** → now **32.5**

    Every pill label stays at 4.5:1 or better (worst is yellow at 4.78:1). The ground is a deep wash of the colour's darkest shade under the same pale label, and it is **opaque** rather than translucent — a pill inside a striped table row sits on a lighter stripe, and at this alpha that lifted the ground enough to drop the label to 4.13:1. Flattened against the dark body colour once, a pill reads the same on every surface.

    Dimmed text went with it: dark-2 is 4.04:1 on the body, under the line, and it is what carries the `7/10`. Now 4.80:1, still clearly quieter than body text at 9.37:1.

    All of it in `theme.ts`, through a `cssVariablesResolver` covering every colour in the theme — including ones nothing uses yet. Wired once at the root.

    Tests assert numbers rather than feelings, and assert what lands on the element: contrast per colour, ΔE > 25 for the two pairs, and one test that renders a real Badge in dark mode and checks the emitted stylesheet actually carries the computed value — which would fail if Mantine never ran the resolver. Verified the pair test fails with Mantine's own values restored (13.63 vs the required 25).

    **One thing found and not fixed here.** Light mode fails the same 4.5:1 bar and always has — 1.75:1 for yellow, 2.17:1 for green, 3.01:1 for grey. It is a real defect, but no tint fixes it: no shade of yellow in the palette is dark enough to reach 4.5:1 on a light ground, so it needs a palette rather than a variant. Left for its own task rather than folded in; worth raising if you want it.
assignee: steve
label:
- bug
priority: high
task_status: done
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
