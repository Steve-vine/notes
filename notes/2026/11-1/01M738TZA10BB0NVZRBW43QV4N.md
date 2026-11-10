---
id: 01M738TZA10BB0NVZRBW43QV4N
created: 2026-11-10T17:42:03.841546Z
updated: 2026-11-10T19:20:27.205993Z
type: task
title: 'SOC 2 exact set, part 2: CC6–CC9 (access, operations, change, risk mitigation and suppliers) — one control per point of focus, everything else proposed for removal'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1685
sprint: s6acz3m
blocked_by:
- 01M738TDP2RCFA4KACRVYF7JEV
comments:
- id: 01M73EEZJ3SRFEQ9N97MDGNA8F
  author: Steve Vine
  at: 2026-11-10T19:20:22.338855Z
  text: |-
    Done, merged as #1688. Part 2 of the exact set is in `audit/soc2-exact-set/part2-cc6-cc9.md`, with the data in the matching `.json`.
    - **Coverage:** 16 criteria and 107 points of focus, all assigned. None is marked not applicable.
    - **Kept:** 68 existing controls (88 links, plus 6 to proposed new controls).
    - **Removed:** 141 of today's 209 links, each with its reason.
    - **Shapes:** every criterion is a set.
    - **Known items:**
      - CC6.2 IDM.1 is removed: IDM.3 covers granting and revoking for every user type.
      - CC6.3 ACC.11 is removed: ACC.5 covers roles and segregation of duties, ACC.4 and IDM.5 the review.
      - CC6.4 PES.4, CC6.5 PES.2, CC7.3 IMA.10 and CC7.5 IMA.16 are kept as partial links.
      - The CC6.4 periodic review of physical access is **not** a gap: PES.4's "What good looks like" requires it.
    - **6 new controls proposed (G-P2-1 to G-P2-6):**
      - a register of external connection points;
      - removing data from staff-owned devices;
      - mapping detection coverage to threat sources;
      - incident communications to management and affected parties;
      - privacy by design and data minimisation;
      - a written agreement for each supplier engagement.
    - **Judgement calls** (e.g. functional testing of changes, patch testing) go to COM-1689.
assignee: steve
label:
- improvement
priority: high
task_status: review
---
**Why.** This applies the rules in COM-1682 to 16 criteria. Today they have 209 links to 170 controls, against 107 points of focus (AICPA 2022, from COM-1683). This is where COM-1669 added the most, so it's where most links will go.

**Method.** As in COM-1684. The output goes in the same file, `audit/soc2-exact-set.md`.

**Known items to settle here** (from the 2026-11-10 review):
- These are each rated as doing the whole job but don't: CC6.2 IDM.1 (joiners only), CC6.3 ACC.11, CC6.4 PES.4, CC6.5 PES.2, CC7.3 IMA.10 and CC7.5 IMA.16.
- CC6.4: no control covers periodically reviewing who can enter secure areas. This is a likely gap.
- The 2022 text has more points than Carbide's 2017 set on several criteria: CC8.1 (18 against 14), CC6.1 (13 against 10) and CC7.3 (7 against 4).

**Where.** `audit/` only. **Independent.** Blocked by COM-1683.

**Done when:**
- All 16 criteria have every point of focus assigned to one control, recorded as a gap, or recorded as not applicable with a reason.
- Every current link is either kept or listed for removal with a reason.