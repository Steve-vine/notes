---
id: 01M00BY4R4V7NYE1W96NF3TSJH
created: 2026-08-14T14:48:37.380446Z
updated: 2026-08-14T14:49:40.552877Z
type: task
title: the tag cloud sizes by entity count and colours by alert count
project: 01KX671DATY39VW6GWK3M2T3DN
number: 716
sprint: svc641e
assignee: steve
label:
- improvement
priority: high
task_status: backlog
tech: null
---
Today size and colour are the same dimension. `CloudTag` computes one scalar `t = heat(alert_count, max)` (`app/frontend/src/pages/TagCloudPage.tsx:75`) and feeds it to BOTH `heatFontSize(t)` and `heatColor(t)`. Two visual channels, one variable — so `entity_count` has no visual encoding at all, despite being what actually decides most of the ranking. It survives only in the tooltip and the aria-label.

Measured on staging, 7d window, of the 200 tags rendered:

| rung | colour | tags | alerts |
|---|---|---|---|
| 0 | gray | 86 | 0 |
| 1 | green | 0 | — (unreachable) |
| 2 | lime | 82 | 1-2 |
| 3 | yellow | 18 | 3-5 |
| 4 | orange | 7 | 7-10 |
| 5 | red | 7 | 13-25 |

168 of 200 words (84%) render in exactly two states. The green rung is mathematically unreachable: `ceil(t*5) == 1` needs `t <= 0.2`, but the smallest positive count of 1 against `max=25` gives `ln2/ln26 = 0.213`. Green only opens up once the hottest tag passes ~31 alerts.

**Split the two channels:**

- **size = `entity_count`** — how much of the estate wears this label. The structural, slow-moving fact. Keep `sqrt` scaling (area, not height, is what the eye reads as weight) against the cloud's max entity count.
- **colour = `alert_count`** — how much it is hurting in the window. The volatile fact. Keep `log1p` normalisation: alert counts are wildly skewed and one pathological tag would flatten the rest.

**The ramp — blue (cold) to red (hot), 5 rungs.** Steve's call, and it matches the reference palette's diverging pair (blue<->red). Validated with the `dataviz` skill's `scripts/validate_palette.js --ordinal`; both modes pass monotone-lightness, adjacent-dL >= 0.06 and light-end contrast:

- light surface: `#659efb, #8b76dc, #9d52a7, #9c3266, #8d191e`
- dark surface:  `#4573bf, #8b79d1, #c482cd, #f390ba, #ffb4ac`

Constructed by interpolating OKLCH hue 260 -> 25 the short way (through violet/magenta, never through green/yellow) with lightness stepped monotonically and gamut-corrected per step, so every word clears text contrast in both themes.

**Two things to know before implementing:**

1. These marks are TEXT, not filled shapes. A textbook diverging ramp puts a pale neutral at the midpoint, which would make mid-heat tags near-invisible against the surface — worse than today. That is why lightness moves monotonically across the whole ramp instead of dipping in the middle. Do not "fix" it back to a conventional diverging ramp.
2. The `dataviz` rule is "sequential = one hue". `alert_count` is sequential (0..max) with no meaningful midpoint, so a blue->red pairing is a deliberate departure. The validator's single-hue check PASSES this ramp at "31 degrees spread", but that is an artifact of hue wrapping past 360 — the true arc is 125 degrees. Recorded so nobody later reads that PASS as proof it is a one-hue ramp.

Rungs drop 6 -> 5: gray is no longer reserved for "zero alerts" (those tags become the coolest blue and are now sized by their entity count, which is the point), and the old green rung never rendered.

**Scope is contained** — `heat`/`heatColor`/`heatFontSize` in `components/statusColors.ts` are used ONLY by `TagCloudPage.tsx` and `TagCloud.test.tsx`. No other screen consumes the ladder, so this is not a shared-design-system change. Update the ladder assertions in `TagCloud.test.tsx:48-67`.

Needs a note in `docs/briefs/ui-brief.md`: the cloud now encodes two variables, and the ramp departs from the one-hue sequential rule on purpose.

**Done when:** a tag on many entities with no alerts renders large and blue, a tag on few entities with heavy alerting renders small and red, and both are legible in light and dark mode.