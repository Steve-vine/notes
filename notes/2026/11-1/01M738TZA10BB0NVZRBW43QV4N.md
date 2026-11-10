---
id: 01M738TZA10BB0NVZRBW43QV4N
created: 2026-11-10T17:42:03.841546Z
updated: 2026-11-10T17:43:15.644292Z
type: task
title: 'SOC 2 exact set, part 2: CC6–CC9 (access, operations, change, risk mitigation and suppliers) — one control per point of focus, everything else proposed for removal'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1685
sprint: s6acz3m
blocked_by:
- 01M738TDP2RCFA4KACRVYF7JEV
assignee: steve
label:
- improvement
priority: high
task_status: todo
---
**Why.** This applies the rules in COM-1682 to 16 criteria. Today they have 209 links to 170 controls, against 93 points of focus. This is where COM-1669 added the most, so it's where most links will go.

**Method.** As in COM-1684. The output goes in the same file, `audit/soc2-exact-set.md`.

**Known items to settle here** (from the 2026-11-10 review):
- These are each rated as doing the whole job but don't: CC6.2 IDM.1 (joiners only), CC6.3 ACC.11, CC6.4 PES.4, CC6.5 PES.2, CC7.3 IMA.10 and CC7.5 IMA.16.
- CC6.4: no control covers periodically reviewing who can enter secure areas. This is a likely gap.

**Where.** `audit/` only. **Independent.** Blocked by COM-1683.

**Done when:**
- All 16 criteria have every point of focus assigned to one control, recorded as a gap, or recorded as not applicable with a reason.
- Every current link is either kept or listed for removal with a reason.