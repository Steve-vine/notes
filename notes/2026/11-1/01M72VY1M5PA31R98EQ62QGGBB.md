---
id: 01M72VY1M5PA31R98EQ62QGGBB
created: 2026-11-10T13:56:33.029599Z
updated: 2026-11-10T17:37:52.278971Z
type: task
title: SOC 2 crosswalk re-checked against the points of focus — every library control that serves a criterion is linked to it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1669
sprint: s6acz3m
comments:
- id: 01M733HRZ55796RA2FQ2GYSWNP
  author: Steve Vine
  at: 2026-11-10T16:09:39.55693Z
  text: |-
    Pre-UAT: **Passed** (staging 7e00b5f9, 2026-11-10, checked via the staging MCP as Steve).
    - Frameworks list: SOC 2 shows 528 mappings (510 from this task plus 18 from COM-1670), matching the repo file.
    - SOC 2 requirements list: CC7.1 now lists VUM.1–VUM.4 (patching), VUM.7/VUM.11 (penetration tests), VUM.8, VUM.13, END.3/END.4, NES.11 and THP.16. CC6.1 lists ASM.1/ASM.2, IDM.5, KMC.2/KMC.9 and NES.9. CC8.1 lists CLD.4, NES.9, SOD.4 and SOD.17. CC3.3 lists RIM.2.
    - Every §1 gap in audit/soc2-mapping.md is linked.
    - Staging deploy: Helm, rollout, smoke and Browser smoke all green.
    Merged as #1679. Released in v0.19.0.
assignee: steve
label:
- improvement
priority: high
task_status: done
---
**Why.** The Callitech (T/A Moneypenny) SOC 2 Type 2 audit will use Compass as the single store of evidence, copied on to Carbide and A-LIGN. The gap check (`audit/soc2-mapping.md`, 2026-11-10) found the SOC 2 crosswalk too thin. COM-428 built it requirement-first, choosing the smallest set of controls that satisfies each criterion, judged against a one-line title. So library controls the auditor will test were never linked: asset register, patching, penetration tests, key management, separate environments, account listings, maintenance, visitor logs, legal register, DPIA and others.

**What changes.** Re-check all 61 SOC 2 criteria against their full points of focus (AICPA 2017 TSC, revised 2022) and link every existing library control that serves one. Each link is graded with a relationship, a strength and a note, the same as today. Nothing is removed unless it is plainly wrong. Processing Integrity is reviewed too, for the crosswalk's sake, even though it's out of this audit's scope.

**Where.** `data/mappings/soc-2-tsc-2017.csv` only. The deploy-time importer adds the new links on every environment, and a clean install builds them from the same file. Data only: no migration, no API change. **Independent.**

**Done when:**
- Every gap in `audit/soc2-mapping.md` §1 is linked.
- Every criterion's controls have been checked against its points of focus.
- On staging, SOC 2 lists the added controls, and e.g. CC7.1 shows patching and penetration testing.
- Crosswalk tests are green.