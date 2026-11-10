---
id: 01M738VYSNS10XYX0RYRCGNERX
created: 2026-11-10T17:42:36.085567Z
updated: 2026-11-10T22:33:51.21901Z
type: task
title: SOC 2 exact set made smallest across the whole framework, then signed off by Steve before anything in Compass changes
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1689
sprint: s6acz3m
blocked_by:
- 01M738TSP77AS30RM7VDV5MSAQ
- 01M738TZA10BB0NVZRBW43QV4N
- 01M738V6Q2DMDF53WB9W9H6ER2
- 01M738VE432F10NR9D813899PE
comments:
- id: 01M73FRX9KW23KMJTDVAHPDWS1
  author: Steve Vine
  at: 2026-11-10T19:43:16.275604Z
  text: |-
    Done, merged as #1689. The summary is in `audit/soc2-exact-set.md`, every criterion is in `audit/soc2-exact-set/final.md`, and the data COM-1691 applies is in `final.json`.

    **The set:**
    - **151 controls** (128 existing, 23 new) and **253 links**. Today there are 265 controls and 528 links; before COM-1669 there were 130 controls and 169 links.
    - All 330 points of focus are carried, and none is marked not applicable.
    - 6 criteria are carried by one control alone; the other 55 are sets declared complete together.

    **Links:** 370 of today's links are removed, each with its reason. 158 are kept, and 95 are new: 44 to existing controls and 51 to new ones.

    **The consolidation:**
    - It merged the 29 proposed gaps into 23 new controls. For example, the supplier code of conduct and supplier agreement terms became one control, N-01; the data protection officer and privacy monitoring became N-03.
    - It settled every judgement call the reviewers flagged. 57 decisions are recorded in `final.md`. One example: N-16 (change testing) was added, because CHM.2 only "considers testing evidence".
    - It dropped 10 controls the parts had kept: BCR.6, CLD.3, EVM.14, EVM.18, IMA.4, IMA.18, INC.12, INS.19, VEM.3 and VEM.13.
    - It brought 3 back to close doubts: BCR.7, INS.14 (which covers deputies for critical roles, so no new control) and VEM.11 (suppliers' own suppliers).

    **ADR 0146** amends 0145 §3: a point that names two activities sitting in different controls is carried jointly by both. 52 of the 330 points are carried this way.

    **For Steve:** five items are listed under "For Steve to look at" in the summary:
    - backup power in offices, PES.8 (A1.2-05);
    - carries accepted because the point's examples are illustrative;
    - N-08 (business plan, budget and financial statements);
    - the length of N-01;
    - CHM.2 and VEM.5 kept despite some overlap.

    **Sign-off:** per Steve's instruction to run the sprint through to staging, the sign-off happens in his review of this task, before production. Nothing is in production yet.
assignee: steve
label:
- improvement
priority: high
task_status: done
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