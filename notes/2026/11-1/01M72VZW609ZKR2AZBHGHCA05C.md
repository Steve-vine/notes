---
id: 01M72VZW609ZKR2AZBHGHCA05C
created: 2026-11-10T13:57:32.992793Z
updated: 2026-11-25T12:46:25.517829Z
type: task
title: HITRUST CSF v11.8 crosswalk completeness review — every library control that serves a requirement is linked to it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1680
comments:
- id: 01M89BWDQDK1BSB897PENAMK5E
  author: Steve Vine
  at: 2026-11-25T12:46:25.517652Z
  text: |-
    PR #2165 (stacked on COM-1674 #2164).

    All 156 assessable controls reviewed as a control-level reading at e1/i1/r2. 146 gain links, 10 needed nothing. 483 links added (420 → 903), 113 controls new to HITRUST, all partial, each graded with a note. The 78 fully / 78 partly split is unchanged (no flag moved).

    What was missing: the newer privacy controls across 13.x (data protection role, purposes, privacy by design, notice, consent, customer requests); input/processing/output validation on 10.b/10.c/10.e; change control and acceptance; topic breadth under requirements already declared complete (awareness, malware, log sources, patching, backup, the incident lifecycle); supplier agreements and external connections; asset discovery and network baselines.

    Tests: two exception tests used ACC.2 as a control that carries a requirement alone; it no longer does (01.i gained the remote and wireless access controls), so they use INC.3, which carries ISO A.5.12 alone.

    For a curator — existing links that look overstated (not changed):
    - 13.q PDH.12 "exactly this": HITRUST wants a PIA for new/changed processing generally, not only high-risk.
    - 13.c PDH.16 "exactly this": records disclosures, doesn't give an accounting on request.
    - 13.p INA (compliance owner): not a privacy lead — PDH data protection role fits.
    - 10.c and 10.e SOD.1/SOD.4: thin — the processing-validation control should carry these.
    - 09.r NES.3: hiding routing info is narrower than protecting system documentation.
    - 06.j ACC.4 and EVM.3: overlaps only — still really unmet.

    Now look discharged or complete (not declared): 13.p, 13.i, 06.a alone; 10.b and 10.e substantially; jointly 13.k, 13.a, 13.t, 13.s, 13.d, 09.f, 12.d, 09.a, 05.c, 01.a.
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Follows the SOC 2 finding (COM-1669, `audit/soc2-mapping.md`): COM-428 built every crosswalk requirement-first, choosing the smallest set of controls that satisfies each requirement, and the tests check coverage, not completeness. So relevant library controls can be missing from a requirement.

HITRUST ships as a licensed skeleton (titles only, ADR 0100). Judge each requirement against its intent at the e1/i1/r2 levels and link every library control that serves it, graded the same way as today. Edit `data/mappings/hitrust-csf-v11-8.csv` only; the deploy-time importer applies it. Data only. **Independent.**

**Done when:** every requirement has been reviewed, the additions are graded with notes, and the crosswalk tests are green.