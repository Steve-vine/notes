---
id: 01M4NJZ4KK8PH739S78NKZMHAN
created: 2026-10-11T13:38:20.403877Z
updated: 2026-10-11T13:38:23.461588Z
type: task
title: A framework's level filter on Compliance has an option for all levels, as the Tier filter has "Any" for Core controls
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 914
sprint: s4gilxe
assignee: steve
label:
- improvement
priority: medium
task_status: backlog
---
Raised by Steve on 2026-10-11 while smoke-testing sprint 68 on staging: "There isn't an option to select all tiers for either of them like you can with core controls." Logged only; not to be actioned until Steve says.

## What Steve saw

- For Core controls the Tier filter offers Any, Essential, Expected, Specialised.
- For CIS and HITRUST the level filter offers only the individual levels. There is no "all".

## Why it is like that

- A framework's levels are cumulative, where Core's tiers are separate. IG3 already includes IG1 and IG2, and r2 includes e1 and i1, so the highest level *is* every requirement. I left out an "all" entry in COM-910 because it would have shown the same figure as the highest level.

## To decide with Steve before building

What "all" should show. Two readings, with different results on screen:

- **A. Everything in the framework.** The gauge shows the highest level's figures (the same as IG3 or r2), named "all levels". Simple, but it duplicates the highest level.
- **B. Every level side by side.** The same as "Any" does for Core controls, where the chart draws the headline and all three tiers. The chart draws one line per level, and the gauge shows either the working-towards level or one gauge per level. This is the closer match to how Core behaves, and it is the only reading that shows something the single levels do not.

My recommendation is B, with the gauge staying on the level the company is working towards and the chart drawing every level's line.

## What people should see (to be completed once A or B is chosen)

- **The level filter has an "all" entry,** first in the list, above the levels in order.
- **It appears for every framework that has levels,** and not for one that has none.
- **It is a look, like any other level:** it changes nothing about the target.

## Notes (technical)

- The per-level figures are already in every day's record (COM-907) and in the gauge's read, so neither reading needs new data.
- Reading B needs `compliance/series.ts` to draw several lines for one framework (today a framework is one line, keyed by its slug) and a colour per level.
- With several frameworks chosen, B multiplies the lines: two frameworks with three levels each is six. Decide whether "all" is offered only while one framework is chosen.
- Overlaps with the level-order task raised at the same time: both change the same list.

**Done when:** to be written with the decision above.