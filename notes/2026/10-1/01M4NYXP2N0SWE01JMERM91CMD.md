---
id: 01M4NYXP2N0SWE01JMERM91CMD
created: 2026-10-11T17:07:18.976391Z
updated: 2026-10-12T19:48:17.340985Z
type: task
title: The by-domain charts on Compliance show their lines — the key sits under the chart instead of filling it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 916
sprint: s4gilxe
comments:
- id: 01M4P08G2W877SA35SRQ2JFGMN
  author: Me
  at: 2026-10-11T17:30:38.556735Z
  text: |-
    Merged to main (PR #918, commit 7d15b8cb). Main's build is green. NOT yet on staging — the deploy needs Steve's go-ahead.

    What is there
    - Both by-domain charts draw their lines at full height. The key is under the chart, not in it.
    - Each name in the key has a short stretch of its own line (dashed domains read as dashed) and its figure: the latest day's, or the day the pointer is on in the chart. A line above the key says which day.
    - Pointing at a name picks its line out on both charts; pressing it keeps it until pressed again. Overall always stays visible.
    - Pointing at the chart shows the day, Overall and the picked domain only.
    - Maturity's axis is marked at each level, 0 to 5 (it read 0.0, 2.0, 5.0).

    Decisions I made (not asked of Steve)
    - The second and fifth points go beyond the screenshot. Once the lines were visible, pointing at them popped up a list of every domain — taller than the chart, covering the key and the panel beneath. I moved the figures into the key rather than leave that.
    - Pressing a name is how one domain is read on its own; there is no way to hide lines.
    - The key is as wide as the panel and wraps: about eight rows at Steve's window size, one long column on a narrow window.

    Checked
    - In a real browser (headless Chromium, the real page, 24 made-up domains): before, the key measured 257px of a 260px box and no lines were drawn; after, the lines have 210px and the key sits beneath. Dark and light, 1600px and 1100px wide, key hover, a pressed domain with the tooltip.
    - New page test for the key's names and figures and for pressing a name.

    Not checked
    - Staging's real data and Steve's own window size. The figures in my check were made up.
- id: 01M4P0E5G9FJ7628KJBHXRR7V4
  author: Me
  at: 2026-10-11T17:33:44.329369Z
  text: 'On staging since 2026-10-11 (Steve''s go-ahead): commit 7d15b8cb, image staging-20261011-1732, deploy run 38160019628 with its smoke check passed. API, worker, scheduler and frontend pods running with no restarts. Ready for Steve''s smoke test.'
assignee: steve
label:
- bug
priority: medium
task_status: done
---
![CleanShot 2026-10-11 at 18.06.01@2x.png](attachments/2026/10/01M4NYXP2N0SWE01JMERM91CMD/CleanShot-2026-10-11-at-18.06.01@2x.png)

Sprint 68, Compliance. Found by Steve on staging, 2026-10-11, straight after COM-915. Fix forward.

## What is wrong

On "Compliance by domain" and "Maturity by domain" the key takes up the entire box. The lines are squashed into a strip a pixel or two high along the top, so neither chart can be read.

## What people should see

- Each chart has its own space: the lines are drawn at full height, as on "Compliance over time".
- The key is under the chart. Every domain is named, with a short stretch of its own line beside it — so a dashed domain reads as dashed.
- Each name carries its figure: the latest day's, or the day the pointer is on in the chart. A line above the key says which day.
- Pointing at a name picks that line out on both charts; pressing it keeps it picked out until pressed again. The Overall line stays visible throughout, to read the domain against.
- Pointing at the chart shows a small box with the day, the Overall figure and the picked domain — not a list of every domain.

## Cause (technical)

`@mantine/charts` takes its legend out of the chart's fixed height (`h`). With ~21 series the legend wrapped to nine rows and measured 257px of a 260px box, leaving nothing for the plot. COM-915's tests could not see it: jsdom lays nothing out. The same count made the built-in tooltip 673px tall — it covered the plot, the key and the panel below.

## Done when

On staging, both by-domain charts show their lines at Steve's usual window size, with the key beneath and nothing overlapping the panels below.