---
id: 01M738VKDZTRQSP58B1T7XRXKJ
created: 2026-11-10T17:42:24.447728Z
updated: 2026-11-10T17:43:17.965157Z
type: task
title: 'SOC 2 exact set, part 5: Processing Integrity (PI1) — one control per point of focus, so the framework is consistent even though PI is out of this audit''s scope'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1688
sprint: s6acz3m
blocked_by:
- 01M738TDP2RCFA4KACRVYF7JEV
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
**Why.** Processing Integrity is out of scope for the Moneypenny audit, but SOC 2 in the library is shared by every company. Leaving PI on the old rules would make its figure mean something different from the rest. It has 5 criteria, with 32 links to 26 controls today. It's lowest priority: do it last, and if time runs short it can move out of the sprint without blocking the rest.

**Method.** As in COM-1684. The output goes in `audit/soc2-exact-set.md`.

**Where.** `audit/` only. **Independent.** Blocked by COM-1683.

**Done when:**
- All 5 criteria have every point of focus assigned to one control, recorded as a gap, or recorded as not applicable with a reason.
- Every current link is either kept or listed for removal with a reason.