---
id: 01M738TSP77AS30RM7VDV5MSAQ
created: 2026-11-10T17:41:58.087057Z
updated: 2026-11-10T22:33:51.159193Z
type: task
title: 'SOC 2 exact set, part 1: CC1–CC5 (governance, communication, risk, monitoring, control activities) — one control per point of focus, everything else proposed for removal'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1684
sprint: s6acz3m
blocked_by:
- 01M738TDP2RCFA4KACRVYF7JEV
comments:
- id: 01M73EDBGANZ6W3GZRR0A8X3BG
  author: Steve Vine
  at: 2026-11-10T19:19:29.034374Z
  text: |-
    Done, merged as #1684. Part 1 of the exact set is in `audit/soc2-exact-set/part1-cc1-cc5.md` (readable), with the data in the matching `.json`.
    - **Coverage:** 17 criteria and 125 points of focus, every one assigned to a control or a proposed new one. None is marked not applicable.
    - **Kept:** 47 existing controls, 66 links. 51 of those links exist today. 15 are existing controls newly linked where they carry a point, e.g. PEO.12 on CC1.1 and INS.20 on CC2.2.
    - **Removed:** 111 of today's 162 links, each with its reason.
    - **Shapes:** every criterion is a set except CC3.3, which is single: RIM.6, whose method names the fraud risk factors.
    - **Known items:**
      - CC1.2 INS.13 and CC3.3 ACC.10 are removed.
      - CC1.3 INS.4, CC2.2 INS.17, CC2.3 INS.18 and CC4.1 INA.2 are kept, now as partial links.
      - ASM.14 is removed from CC5.3.
    - **11 new controls proposed (G-P1-1 to G-P1-11):**
      - vendor staff bound to the code of conduct;
      - board skills;
      - a data protection accountability role;
      - deputies for critical roles;
      - incentives aligned with controls;
      - data quality of control information;
      - privacy awareness training;
      - an external route for reporting concerns;
      - business plan and budget objectives;
      - financial reporting;
      - procedures for each control activity.
    - **Judgement calls** are listed in the report. COM-1689 re-examines them.

    `audit/exact_set.py` checks a result against ADR 0145 and renders it.
assignee: steve
label:
- improvement
priority: high
task_status: done
---
**Why.** This applies the rules in COM-1682 to 17 criteria. Today they have 162 links to 95 controls, against 125 points of focus (AICPA 2022, from COM-1683).

**Method** (the same for parts 1–5, COM-1684..1688):
1. For each point of focus (COM-1683), name the **one** library control that carries it, with a sentence on why. Prefer a control SOC 2 already needs elsewhere.
2. A point no control carries is a **gap**. Record it with a proposed fix. A new control is preferred, because rewording an existing control changes what it means for every other framework.
3. Every point is covered, including ones this year's auditor doesn't test. The only exception is a point that can't apply to any organisation using Compass: record it with the reason, for Steve to agree.
4. Every current link not chosen in step 1 is **proposed for removal**, with the reason ("carries no point of focus" or "point already carried by X").
5. Set each criterion's shape:
   - one control that does the whole job, alone; or
   - a set of partial controls declared complete together.
6. **Check it the other way round.** Reading only the chosen controls' wording, is there any doubt the criterion is met? If there is, that's a gap.

**Output.** `audit/soc2-exact-set.md`, a section per criterion with:
- a point → control table;
- the links to keep (relationship, strength), the links to remove, and the gaps.

No change to the app in this task. Steve reviews the result in COM-1689.

**Known items to settle here** (from the 2026-11-10 review):
- CC1.2 INS.13, CC1.3 INS.4, CC2.2 INS.17, CC2.3 INS.18, CC3.3 ACC.10 and CC4.1 INA.2 are each rated as doing the whole job but don't.
- ASM.14 (software licensing) under CC5.3 looks wrong.
- CC2.1 has 9 points in the 2022 text, against 4 in Carbide. Expect it to need more than today's set.

**Where.** `audit/` only. **Independent.** Blocked by COM-1683.

**Done when:**
- All 17 criteria have every point of focus assigned to one control, recorded as a gap, or recorded as not applicable with a reason.
- Every current link is either kept or listed for removal with a reason.