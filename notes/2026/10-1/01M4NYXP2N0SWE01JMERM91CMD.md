---
id: 01M4NYXP2N0SWE01JMERM91CMD
created: 2026-10-11T17:07:18.976391Z
updated: 2026-10-11T17:16:33.728849Z
type: task
title: The by-domain charts on Compliance show their lines — the key sits under the chart instead of filling it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 916
sprint: s4gilxe
assignee: steve
label:
- bug
priority: medium
task_status: active
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