---
id: 01M4NJZ4KK8PH739S78NKZMHAN
created: 2026-10-11T13:38:20.403877Z
updated: 2026-10-11T13:54:19.826191Z
type: task
title: A framework's level filter on Compliance has an option for all levels, as the Tier filter has "Any" for Core controls
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 914
sprint: s4gilxe
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Raised by Steve on 2026-10-11 while smoke-testing sprint 68 on staging: "There isn't an option to select all tiers for either of them like you can with core controls." Logged only; not to be actioned until Steve says.

## What Steve saw

- For Core controls the Tier filter offers Any, Essential, Expected, Specialised.
- For CIS and HITRUST the level filter offers only the individual levels. There is no "all".

## Why it is like that

- A framework's levels are cumulative, where Core's tiers are separate. IG3 already includes IG1 and IG2, and r2 includes e1 and i1, so the highest level *is* every requirement. I left out an "all" entry in COM-910 because it would have shown the same figure as the highest level.

## Decided (Steve, 2026-10-11)

**"All" means everything in the framework.** It shows every requirement, whatever its level. I had recommended drawing every level side by side instead; Steve chose this.

## What people should see

- **The level filter has an "All" entry,** first in the list, above the levels in their own order (the order is COM-913).
- **Choosing it shows the whole framework:** the gauge counts every requirement, and the trend line is the framework at everything.
- **The gauge says so,** for example "met · 156 requirements, all levels", not "at r2".
- **It shows the same figures as the highest level** (IG3, r2), because the levels are cumulative. That is expected.
- **It appears for every framework that has levels,** and not for one that has none.
- **It is a look, like any other level:** it changes nothing about the level the company is working towards. Where the company is working towards a lower level, the page says so, as it does for any other level being looked at.
- **The page still opens on the level the company is working towards,** not on "All".
- **A chip still opens the framework's page** with the same view.

## Notes (technical)

- No new data: "All" is the highest level's entry in the gauge's read and in each day's record (COM-907).
- `CompliancePage.tsx`: the level filter gains an "All" choice that resolves to the framework's last level. Keep it distinct in the address from the highest level chosen by name, so the button reads "All" when "All" was chosen.
- The chip link to the framework's page passes the highest level as the level to look at; that page needs no "all" of its own.
- Shares the list with COM-913 (levels in order). Build the two together, or this one second.
- Tests: "All" on a company working towards a lower level shows the highest level's figures and the "looking at" note; on a framework with no levels there is no filter.

**Done when:** on staging, with CIS chosen and the company working towards IG1, choosing "All" shows 153 safeguards in the gauge, the CIS page still says IG1, and HITRUST's filter offers "All" above e1, i1, r2.