---
id: 01M4NJYT6FW31JS7EWK29PYFF0
created: 2026-10-11T13:38:09.743728Z
updated: 2026-10-11T13:38:22.895336Z
type: task
title: A framework's levels are listed in their own order in the Compliance filter — IG1, IG2, IG3 and e1, i1, r2 — not with the target first
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 913
sprint: s4gilxe
assignee: steve
label:
- bug
priority: medium
task_status: backlog
---
Raised by Steve on 2026-10-11 while smoke-testing sprint 68 on staging: "The CIS and HITRUST tiers aren't in order in the filters, e.g. CIS goes IG3, IG1, IG2 and HITRUST goes r2, e1, i1. Order them correctly." Logged only; not to be actioned until Steve says.

## What Steve saw

- On Compliance, with CIS chosen, the level filter lists IG3, IG1, IG2.
- With HITRUST chosen it lists r2, e1, i1.

## Why it does that

- It was my choice in COM-910, not a fault in the data. The level the company is working towards is put first, as the filter's starting choice, and the other levels follow. Both companies on staging are working towards the highest level, so the highest comes first.

## What people should see

- **The levels are listed lowest first, in the framework's own order:** IG1, IG2, IG3; e1, i1, r2.
- **The level the company is working towards is still marked** in the list, for example "r2 · working towards", wherever it falls.
- **The page still opens on that level,** and looking at another level still changes nothing about the target.

## Notes (technical)

- `CompliancePage.tsx`: the level `FilterButton` passes the target as `anyLabel` and the other levels as `options`, which is what puts the target first. The kit's `FilterButton` always renders its "any" entry first.
- The filter needs every level as an ordinary option in order, with the target's label carrying "· working towards", and no separate first entry. That needs a way to tell the kit's button there is no "any" entry (I wrote and then reverted exactly that during COM-910: `anyLabel: null`).
- Keep the button in the accent only while a level other than the target is being looked at.
- This overlaps with the "all levels" task raised at the same time: decide the two together, since an "all" entry would be the first item in this list.
- Update the page tests that expect "i1 · working towards" first.

**Done when:** on staging the CIS level filter reads IG1, IG2, IG3 and the HITRUST one reads e1, i1, r2, each with the working-towards level marked.