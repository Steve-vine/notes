---
id: 01M738VYSNS10XYX0RYRCGNERX
created: 2026-11-10T17:42:36.085567Z
updated: 2026-11-10T17:42:36.085567Z
type: task
title: SOC 2 exact set made smallest across the whole framework, then signed off by Steve before anything in Compass changes
assignee: steve
label: improvement
priority: high
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1689
---
**Why.** Parts 1–5 each choose controls one criterion at a time. Rule 2 (COM-1682) is about the whole set: completing SOC 2 shouldn't need a control that isn't needed. So the parts are put together and trimmed, and Steve approves the result before any link in Compass moves.

**What changes:**
- **Merge** parts 1–5 into one list: the SOC 2 control set. For each control, show the points of focus it carries and in which criteria.
- **Trim.** Where a point is carried by a control kept only for that point, and another kept control could carry it just as fully, use the other one and drop the first. Repeat until nothing more can be dropped.
- **Summarise** at the top of `audit/soc2-exact-set.md`:
  - controls needed, against 265 today and 130 before COM-1669;
  - links kept, against 528 today;
  - links removed;
  - gaps, each with its proposed fix: a new control, or a wording change;
  - points recorded as not applicable, with the reasons;
  - the controls whose proposed tier changes as a result (COM-1669's 45 tier rises mostly reverse).
- **Steve reviews** the file and either approves it or sends items back.

**Where.** `audit/` only. **Independent.** Blocked by COM-1684..1687. COM-1688 (PI) joins if it's done; otherwise PI keeps today's links until it is.

**Done when:**
- The merged, trimmed set is in `audit/soc2-exact-set.md`.
- Steve has approved it, with any changes he asked for made. Record his approval as a comment here.